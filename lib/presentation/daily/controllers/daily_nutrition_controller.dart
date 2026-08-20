import 'package:get/get.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_response_entity.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';

class DailyNutritionController extends GetxController {
  final GetNutritionPlanUseCase getPlan;
  final GetProfileUseCase getProfile;

  DailyNutritionController({
    required this.getPlan,
    required this.getProfile,
  });

  final selectedPlan = ''.obs;
  final plans = const ['Training Day', 'Rest Day', 'Special Day'];

  final isLoading = false.obs;

  final calories = 0.obs;
  final carbs = 0.0.obs;
  final protein = 0.0.obs;
  final fats = 0.0.obs;

  NutritionPlanResponseEntity? _fullData;

  @override
  void onInit() {
    super.onInit();
    fetchNutritionPlan();
  }

  Future<void> fetchNutritionPlan() async {
    isLoading.value = true;
    try {
      final profileResult = await getProfile();
      await profileResult.fold(
        (failure) async {
          isLoading.value = false;
        },
        (profile) async {
          final result = await getPlan(profile.athlete.id);
          result.fold(
            (failure) {},
            (response) {
              _fullData = response;
              _applyPlanFilter();
            },
          );
        },
      );
    } catch (_) {
      // Handle error silently
    } finally {
      isLoading.value = false;
    }
  }

  void onPlanChanged(String plan) {
    selectedPlan.value = plan;
    _applyPlanFilter();
  }

  void _applyPlanFilter() {
    if (_fullData == null || selectedPlan.value.isEmpty) return;

    final index = plans.indexOf(selectedPlan.value);
    if (index == -1) return;
    final filtered = _filterPlan(_fullData!, index);

    calories.value = filtered.calories;
    carbs.value = filtered.carbsG;
    protein.value = filtered.proteinG;
    fats.value = filtered.fatsG;
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
      title: plans[index],
      mealsCount: meals.length,
      waterLiters: 4.0,
      calories: cal,
      proteinG: p,
      carbsG: c,
      fatsG: f,
      meals: meals,
    );
  }
}
