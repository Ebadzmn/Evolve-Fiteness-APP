import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_response_entity.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'nutrition_plan_event.dart';
import 'nutrition_plan_state.dart';

class NutritionPlanBloc extends Bloc<NutritionPlanEvent, NutritionPlanState> {
  final GetNutritionPlanUseCase getPlan;
  final GetProfileUseCase getProfile;

  NutritionPlanBloc({required this.getPlan, required this.getProfile})
    : super(const NutritionPlanState()) {
    on<NutritionPlanLoadRequested>(_onLoad);
    on<NutritionPlanTabChanged>(_onTabChanged);
  }

  Future<void> _onLoad(
    NutritionPlanLoadRequested event,
    Emitter<NutritionPlanState> emit,
  ) async {
    emit(state.copyWith(status: NutritionPlanStatus.loading));

    final profileResult = await getProfile();
    await profileResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: NutritionPlanStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (profile) async {
        final result = await getPlan(profile.athlete.id);

        result.fold(
          (failure) => emit(
            state.copyWith(
              status: NutritionPlanStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (response) {
            final initialPlan = _filterPlan(response, 0);
            emit(
              state.copyWith(
                status: NutritionPlanStatus.success,
                fullData: response,
                data: initialPlan,
                selectedTabIndex: 0,
              ),
            );
          },
        );
      },
    );
  }

  void _onTabChanged(
    NutritionPlanTabChanged event,
    Emitter<NutritionPlanState> emit,
  ) {
    if (state.fullData == null) return;
    final filteredPlan = _filterPlan(state.fullData!, event.index);
    emit(state.copyWith(data: filteredPlan, selectedTabIndex: event.index));
  }

  NutritionPlanEntity _filterPlan(
    NutritionPlanResponseEntity fullData,
    int index,
  ) {
    final meals = fullData.meals.where((m) {
      final type = m.trainingDay.toLowerCase();
      if (index == 0) return type.contains('training');
      if (index == 1) return type.contains('rest');
      return type.contains('special');
    }).toList();

    double p = 0, c = 0, f = 0;
    int cal = 0;
    for (var m in meals) {
      p += m.proteinG;
      c += m.carbsG;
      f += m.fatsG;
      cal += m.calories;
    }

    return NutritionPlanEntity(
      title: index == 0
          ? 'Training Day'
          : (index == 1 ? 'Rest Day' : 'Special Day'),
      mealsCount: meals.length,
      waterLiters: 4.0, // Hardcoded
      calories: cal,
      proteinG: p,
      carbsG: c,
      fatsG: f,
      meals: meals,
    );
  }
}
