import '../../../../domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import '../../../../domain/entities/nutrition_entities/meal_food_item_entity.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_response_entity.dart';

class NutritionMealModel extends NutritionMealEntity {
  const NutritionMealModel({
    required super.id,
    required super.timeLabel,
    required super.title,
    required super.calories,
    required super.proteinG,
    required super.carbsG,
    required super.fatsG,
    required super.items,
    required super.trainingDay,
  });

  factory NutritionMealModel.fromJson(Map<String, dynamic> json) {
    return NutritionMealModel(
      id: json['_id'] ?? '',
      timeLabel: json['time'] ?? '',
      title: json['mealName'] ?? '',
      calories: (json['totalCalories'] as num?)?.toInt() ?? 0,
      proteinG: (json['totalProtein'] as num?)?.toDouble() ?? 0.0,
      carbsG: (json['totalCarbs'] as num?)?.toDouble() ?? 0.0,
      fatsG: (json['totalFats'] as num?)?.toDouble() ?? 0.0,
      items:
          (json['food'] as List<dynamic>?)
              ?.map(
                (item) => MealFoodItemEntity(
                  name: item['foodName'] ?? 'Unknown',
                  quantity: '${item['quantity']}g',
                ),
              )
              .toList() ??
          [],
      trainingDay: json['trainingDay'] ?? 'training day',
    );
  }
}

class NutritionTotalsModel extends NutritionTotalsEntity {
  const NutritionTotalsModel({
    required super.totalProtein,
    required super.totalFats,
    required super.totalCarbs,
    required super.totalCalories,
  });

  factory NutritionTotalsModel.fromJson(Map<String, dynamic> json) {
    return NutritionTotalsModel(
      totalProtein: (json['totalProtein'] as num?)?.toDouble() ?? 0.0,
      totalFats: (json['totalFats'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['totalCarbs'] as num?)?.toDouble() ?? 0.0,
      totalCalories: (json['totalCalories'] as num?)?.toInt() ?? 0,
    );
  }
}

class NutritionPlanResponseModel extends NutritionPlanResponseEntity {
  const NutritionPlanResponseModel({
    required super.meals,
    required super.totals,
  });

  factory NutritionPlanResponseModel.fromJson(Map<String, dynamic> json) {
    return NutritionPlanResponseModel(
      meals:
          (json['plans'] as List<dynamic>?)
              ?.map((e) => NutritionMealModel.fromJson(e))
              .toList() ??
          [],
      totals: NutritionTotalsModel.fromJson(json['totals'] ?? {}),
    );
  }
}
