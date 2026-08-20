import 'package:fitness_app/core/storage/nutrition_storage.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_dashboard_entity.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final GetProfileUseCase getProfile;
  final GetNutritionPlanUseCase getPlan;
  final GetTrackMealsUseCase getTrackMeals;
  final NutritionStorage nutritionStorage;

  NutritionBloc({
    required this.getProfile,
    required this.getPlan,
    required this.getTrackMeals,
    required this.nutritionStorage,
  }) : super(const NutritionState()) {
    on<NutritionInitRequested>(_onInit);
  }

  Future<void> _onInit(
    NutritionInitRequested event,
    Emitter<NutritionState> emit,
  ) async {
    // 1. Show stored data immediately if available
    final storedData = NutritionDashboardEntity(
      caloriesConsumed: nutritionStorage.getTrackedCalories().toInt(),
      caloriesGoal: nutritionStorage.getPlanCalories(),
      proteinConsumed: nutritionStorage.getTrackedProtein().toInt(),
      proteinGoal: nutritionStorage.getPlanProtein().toInt(),
      carbsConsumed: nutritionStorage.getTrackedCarbs().toInt(),
      carbsGoal: nutritionStorage.getPlanCarbs().toInt(),
      fatConsumed: nutritionStorage.getTrackedFats().toInt(),
      fatGoal: nutritionStorage.getPlanFats().toInt(),
    );

    emit(state.copyWith(status: NutritionStatus.success, data: storedData));

    try {
      // 2. Refresh from API
      // First get profile for userId
      final profileResult = await getProfile();
      await profileResult.fold(
        (failure) async {
          emit(state.copyWith(status: NutritionStatus.success));
        },
        (profile) async {
          final userId = profile.athlete.id;

          // Fetch Plan (Goals) and Tracked Meals (Progress) in parallel
          final results = await Future.wait([
            getPlan(userId),
            getTrackMeals(DateTime.now()),
          ]);

          final planResult =
              results[0]
                  as dynamic; // Either<ApiException, NutritionPlanResponseEntity>
          final trackMealsResult =
              results[1]
                  as dynamic; // Either<ApiException, NutritionDailyTrackingEntity>

          NutritionDashboardEntity? updatedData;

          int? caloriesGoal;
          int? proteinGoal;
          int? carbsGoal;
          int? fatGoal;

          int? caloriesConsumed;
          int? proteinConsumed;
          int? carbsConsumed;
          int? fatConsumed;

          planResult.fold((failure) {}, (plan) {
            caloriesGoal = plan.totals.totalCalories;
            proteinGoal = plan.totals.totalProtein.toInt();
            carbsGoal = plan.totals.totalCarbs.toInt();
            fatGoal = plan.totals.totalFats.toInt();

            // Update storage
            nutritionStorage.savePlanTotals(
              protein: plan.totals.totalProtein,
              fats: plan.totals.totalFats,
              carbs: plan.totals.totalCarbs,
              calories: plan.totals.totalCalories,
            );
          });

          trackMealsResult.fold((failure) {}, (trackingData) {
            caloriesConsumed = trackingData.totals.totalCalories.toInt();
            proteinConsumed = trackingData.totals.totalProtein.toInt();
            carbsConsumed = trackingData.totals.totalCarbs.toInt();
            fatConsumed = trackingData.totals.totalFats.toInt();

            // Update storage
            nutritionStorage.saveTrackedTotals(
              protein: trackingData.totals.totalProtein,
              fats: trackingData.totals.totalFats,
              carbs: trackingData.totals.totalCarbs,
              calories: trackingData.totals.totalCalories.toDouble(),
            );
          });

          // Construct updated entity using new data or existing stored data as fallback
          updatedData = NutritionDashboardEntity(
            caloriesConsumed: caloriesConsumed ?? storedData.caloriesConsumed,
            caloriesGoal: caloriesGoal ?? storedData.caloriesGoal,
            proteinConsumed: proteinConsumed ?? storedData.proteinConsumed,
            proteinGoal: proteinGoal ?? storedData.proteinGoal,
            carbsConsumed: carbsConsumed ?? storedData.carbsConsumed,
            carbsGoal: carbsGoal ?? storedData.carbsGoal,
            fatConsumed: fatConsumed ?? storedData.fatConsumed,
            fatGoal: fatGoal ?? storedData.fatGoal,
          );

          emit(
            state.copyWith(status: NutritionStatus.success, data: updatedData),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(status: NutritionStatus.success));
    }
  }
}
