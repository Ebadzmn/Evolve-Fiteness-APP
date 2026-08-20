import 'nutrition_plan_entity.dart';

class NutritionPlanResponseEntity {
  final List<NutritionMealEntity> meals;
  final NutritionTotalsEntity totals;

  const NutritionPlanResponseEntity({
    required this.meals,
    required this.totals,
  });
}

class NutritionTotalsEntity {
  final double totalProtein;
  final double totalFats;
  final double totalCarbs;
  final int totalCalories;

  const NutritionTotalsEntity({
    required this.totalProtein,
    required this.totalFats,
    required this.totalCarbs,
    required this.totalCalories,
  });
}
