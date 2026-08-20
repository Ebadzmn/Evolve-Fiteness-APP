import 'meal_food_item_entity.dart';

class NutritionMealEntity {
  final String id;
  final String timeLabel;
  final String title; // mealName
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final List<MealFoodItemEntity> items; // Refactored from List<String>
  final String trainingDay; // 'training day', 'restday', etc.

  const NutritionMealEntity({
    required this.id,
    required this.timeLabel,
    required this.title,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.items,
    required this.trainingDay,
  });
}

class NutritionPlanEntity {
  final String title; // e.g. "Training Day" or "Rest Day"
  final int mealsCount;
  final double waterLiters; // Hardcoded or calculated? API doesn't send water.
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final List<NutritionMealEntity> meals;

  const NutritionPlanEntity({
    required this.title,
    required this.mealsCount,
    required this.waterLiters,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.meals,
  });
}
