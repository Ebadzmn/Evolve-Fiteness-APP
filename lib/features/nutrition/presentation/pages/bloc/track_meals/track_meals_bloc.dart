import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/save_track_meal_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/delete_tracked_food_item_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/add_food_items_to_meal_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meal_suggestions_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/update_water_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_water_config_usecase.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_suggestion_entity.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'track_meals_event.dart';
import 'track_meals_state.dart';

class TrackMealsBloc extends Bloc<TrackMealsEvent, TrackMealsState> {
  final GetTrackMealsUseCase getMeals;
  final GetNutritionPlanUseCase getPlan;
  final SaveTrackMealUseCase saveMeal;
  final DeleteTrackedFoodItemUseCase deleteFoodItem;
  final AddFoodItemsToMealUseCase addFoodItemsToMeal;
  final GetTrackMealSuggestionsUseCase getSuggestions;
  final GetProfileUseCase getProfile;
  final UpdateWaterUseCase updateWater;
  final GetWaterConfigUseCase getWaterConfig;
  Timer? _suggestionsDebounce;

  TrackMealsBloc({
    required DateTime initialDate,
    required this.getMeals,
    required this.getPlan,
    required this.saveMeal,
    required this.deleteFoodItem,
    required this.addFoodItemsToMeal,
    required this.getSuggestions,
    required this.getProfile,
    required this.updateWater,
    required this.getWaterConfig,
  }) : super(TrackMealsState(date: initialDate)) {
    on<TrackMealsLoadRequested>(_onLoad);
    on<TrackMealsDateChanged>(_onDateChanged);
    on<TrackMealsAddMeal>(_onAddMeal);
    on<TrackMealsDeleteFoodItem>(_onDeleteFoodItem);
    on<TrackMealsAddFoodItemsToMeal>(_onAddFoodItemsToMeal);
    on<TrackMealsSuggestionQueryChanged>(_onSuggestionQueryChanged);
    on<TrackMealsSuggestionRequested>(_onSuggestionRequested);
    on<TrackMealsSuggestionsCleared>(_onSuggestionsCleared);
    on<TrackMealsLogWater>(_onLogWater);
  }

  Future<void> _onLoad(
    TrackMealsLoadRequested event,
    Emitter<TrackMealsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TrackMealsStatus.loading,
        suggestionsByRow: const {},
        suggestionQueryByRow: const {},
        suggestionsRowIndex: null,
        suggestionsLoading: false,
        trackingData: null,
        bottleAmountMl: 0,
        glassAmountMl: 0,
      ),
    );

    final mealsResult = await getMeals(event.date);

    dynamic planResult;
    final profileResult = await getProfile();
    await profileResult.fold(
      (failure) async {
        // Ignore plan failure; tracking data can still load
      },
      (profile) async {
        planResult = await getPlan(profile.athlete.id);
      },
    );

    NutritionDailyTrackingEntity? trackingData;
    String? errorMessage;

    mealsResult.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (data) {
        trackingData = data;
        // Backward compatibility: use the first day's meals if available
        if (data.data.isNotEmpty) {
          // We need to map TrackingMealEntity to NutritionMealEntity if we want to keep using 'meals' list in UI temporarily
          // Or just leave meals empty and switch UI.
          // Since NutritionMealEntity and TrackingMealEntity are different, we can't just assign.
          // For now, let's leave 'meals' empty or rely on the UI using trackingData.
          // But wait, the state.meals is List<NutritionMealEntity>.
          // TrackingMealEntity is unrelated type.
          // I will NOT try to map it here to avoid complex mapping logic. I will switch the UI to use trackingData.
        }
      },
    );

    if (errorMessage != null) {
      emit(
        state.copyWith(
          status: TrackMealsStatus.success,
          errorMessage: errorMessage,
          trackingData: null,
          bottleAmountMl: 0,
          glassAmountMl: 0,
        ),
      );
      return;
    }

    NutritionPlanEntity? planEntity;
    if (planResult != null) {
      planResult.fold(
        (failure) {
          // Ignore plan failure for now logic as before
        },
        (response) {
          planEntity = NutritionPlanEntity(
            title: 'Daily Goal',
            mealsCount: response.meals.length,
            waterLiters: 4.0,
            calories: response.totals.totalCalories,
            proteinG: response.totals.totalProtein,
            carbsG: response.totals.totalCarbs,
            fatsG: response.totals.totalFats,
            meals: response.meals,
          );
        },
      );
    }

    int? bottleAmount;
    int? glassAmount;

    final waterResult = await getWaterConfig(event.date);
    waterResult.fold(
      (failure) {
        // Ignore and keep defaults
      },
      (config) {
        bottleAmount = config['bottle'];
        glassAmount = config['glass'];
      },
    );

    emit(
      state.copyWith(
        status: TrackMealsStatus.success,
        meals: [], // Clearing legacy meals list as we move to trackingData
        plan: planEntity,
        trackingData: trackingData,
        bottleAmountMl: bottleAmount,
        glassAmountMl: glassAmount,
      ),
    );
  }

  Future<void> _onDateChanged(
    TrackMealsDateChanged event,
    Emitter<TrackMealsState> emit,
  ) async {
    emit(
      state.copyWith(
        date: event.date,
        trackingData: null,
        bottleAmountMl: 0,
        glassAmountMl: 0,
      ),
    );
    add(TrackMealsLoadRequested(event.date));
  }

  Future<void> _onAddMeal(
    TrackMealsAddMeal event,
    Emitter<TrackMealsState> emit,
  ) async {
    try {
      await saveMeal(event.date, event.meal);
      add(TrackMealsLoadRequested(event.date));
    } catch (e) {
      emit(
        state.copyWith(
          status: TrackMealsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteFoodItem(
    TrackMealsDeleteFoodItem event,
    Emitter<TrackMealsState> emit,
  ) async {
    try {
      await deleteFoodItem(event.date, event.mealId, event.foodId);
      add(TrackMealsLoadRequested(event.date));
    } catch (e) {
      emit(
        state.copyWith(
          status: TrackMealsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddFoodItemsToMeal(
    TrackMealsAddFoodItemsToMeal event,
    Emitter<TrackMealsState> emit,
  ) async {
    final result = await addFoodItemsToMeal(
      event.date,
      event.mealId,
      event.food,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TrackMealsStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        add(TrackMealsLoadRequested(event.date));
      },
    );
  }

  Future<void> _onLogWater(
    TrackMealsLogWater event,
    Emitter<TrackMealsState> emit,
  ) async {
    final result = await updateWater(event.date, event.unit, event.amount);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TrackMealsStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        add(TrackMealsLoadRequested(event.date));
      },
    );
  }

  void _onSuggestionQueryChanged(
    TrackMealsSuggestionQueryChanged event,
    Emitter<TrackMealsState> emit,
  ) {
    final query = event.query.trim();
    final updatedQueryByRow = Map<int, String>.from(state.suggestionQueryByRow);
    updatedQueryByRow[event.rowIndex] = query;

    if (query.length < 2) {
      final updatedSuggestionsByRow = Map<int, List<MealSuggestionEntity>>.from(
        state.suggestionsByRow,
      );
      updatedSuggestionsByRow.remove(event.rowIndex);
      emit(
        state.copyWith(
          suggestionsByRow: updatedSuggestionsByRow,
          suggestionQueryByRow: updatedQueryByRow,
          suggestionsRowIndex: event.rowIndex,
          suggestionsLoading: false,
        ),
      );
      _suggestionsDebounce?.cancel();
      return;
    }

    emit(
      state.copyWith(
        suggestionQueryByRow: updatedQueryByRow,
        suggestionsRowIndex: event.rowIndex,
        suggestionsLoading: true,
      ),
    );

    _suggestionsDebounce?.cancel();
    _suggestionsDebounce = Timer(const Duration(milliseconds: 350), () {
      add(
        TrackMealsSuggestionRequested(rowIndex: event.rowIndex, query: query),
      );
    });
  }

  Future<void> _onSuggestionRequested(
    TrackMealsSuggestionRequested event,
    Emitter<TrackMealsState> emit,
  ) async {
    final currentQuery = state.suggestionQueryByRow[event.rowIndex];
    if (currentQuery == null || currentQuery != event.query.trim()) return;

    emit(
      state.copyWith(
        suggestionsRowIndex: event.rowIndex,
        suggestionsLoading: true,
      ),
    );

    final result = await getSuggestions(event.query.trim());
    result.fold(
      (_) {
        final updatedSuggestionsByRow =
            Map<int, List<MealSuggestionEntity>>.from(state.suggestionsByRow);
        updatedSuggestionsByRow[event.rowIndex] =
            const <MealSuggestionEntity>[];
        emit(
          state.copyWith(
            suggestionsByRow: updatedSuggestionsByRow,
            suggestionsRowIndex: event.rowIndex,
            suggestionsLoading: false,
          ),
        );
      },
      (suggestions) {
        final updatedSuggestionsByRow =
            Map<int, List<MealSuggestionEntity>>.from(state.suggestionsByRow);
        updatedSuggestionsByRow[event.rowIndex] = suggestions;
        emit(
          state.copyWith(
            suggestionsByRow: updatedSuggestionsByRow,
            suggestionsRowIndex: event.rowIndex,
            suggestionsLoading: false,
          ),
        );
      },
    );
  }

  void _onSuggestionsCleared(
    TrackMealsSuggestionsCleared event,
    Emitter<TrackMealsState> emit,
  ) {
    final updatedSuggestionsByRow = Map<int, List<MealSuggestionEntity>>.from(
      state.suggestionsByRow,
    );
    updatedSuggestionsByRow.remove(event.rowIndex);
    final updatedQueryByRow = Map<int, String>.from(state.suggestionQueryByRow);
    updatedQueryByRow.remove(event.rowIndex);
    emit(
      state.copyWith(
        suggestionsByRow: updatedSuggestionsByRow,
        suggestionQueryByRow: updatedQueryByRow,
        suggestionsRowIndex: state.suggestionsRowIndex == event.rowIndex
            ? null
            : state.suggestionsRowIndex,
        suggestionsLoading: false,
      ),
    );
  }

  @override
  Future<void> close() {
    _suggestionsDebounce?.cancel();
    return super.close();
  }
}
