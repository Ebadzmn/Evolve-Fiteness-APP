import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
import 'package:fitness_app/features/nutrition/data/models/nutrition_plan_model.dart';

class NutritionDailyTrackingModel extends NutritionDailyTrackingEntity {
  const NutritionDailyTrackingModel({
    required super.data,
    required super.totals,
    required super.caloriesByDate,
    required super.water,
    required super.stats,
  });

  factory NutritionDailyTrackingModel.fromJson(Map<String, dynamic> json) {
    return NutritionDailyTrackingModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => DailyTrackingDataModel.fromJson(e))
              .toList() ??
          [],
      totals: NutritionTotalsModel.fromJson(json['totals'] ?? {}),
      caloriesByDate:
          (json['caloriesByDate'] as List<dynamic>?)
              ?.map((e) => CaloriesByDateModel.fromJson(e))
              .toList() ??
          [],
      water: (json['water'] as num?)?.toInt() ?? 0,
      stats: NutritionStatsModel.fromJson(json['stats'] ?? {}),
    );
  }
}

class DailyTrackingDataModel extends DailyTrackingDataEntity {
  const DailyTrackingDataModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.meals,
  });

  factory DailyTrackingDataModel.fromJson(Map<String, dynamic> json) {
    return DailyTrackingDataModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] ?? '',
      meals:
          (json['meals'] as List<dynamic>?)
              ?.map((e) => TrackingMealModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TrackingMealModel extends TrackingMealEntity {
  const TrackingMealModel({
    required super.id,
    required super.mealNumber,
    required super.food,
    required super.totalProtein,
    required super.totalFats,
    required super.totalCarbs,
    required super.totalCalories,
  });

  factory TrackingMealModel.fromJson(Map<String, dynamic> json) {
    return TrackingMealModel(
      id: json['_id'] ?? '',
      mealNumber: json['mealNumber'] ?? '',
      food:
          (json['food'] as List<dynamic>?)
              ?.map(
                (e) => MealFoodItemEntity(
                  name: e['foodNme'] ?? '',
                  quantity: (e['quantity'] as num?)?.toString() ?? '0',
                  id: e['_id'],
                ),
              )
              .toList() ??
          [],
      totalProtein: (json['totalProtein'] as num?)?.toDouble() ?? 0.0,
      totalFats: (json['totalFats'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['totalCarbs'] as num?)?.toDouble() ?? 0.0,
      totalCalories: (json['totalCalories'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CaloriesByDateModel extends CaloriesByDateEntity {
  const CaloriesByDateModel({
    required super.date,
    required super.day,
    required super.totalCalories,
  });

  factory CaloriesByDateModel.fromJson(Map<String, dynamic> json) {
    return CaloriesByDateModel(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      totalCalories: (json['totalCalories'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class NutritionStatsModel extends NutritionStatsEntity {
  const NutritionStatsModel({required super.percentages});

  factory NutritionStatsModel.fromJson(Map<String, dynamic> json) {
    return NutritionStatsModel(
      percentages: NutritionPercentagesModel.fromJson(
        json['percentages'] ?? {},
      ),
    );
  }
}

class NutritionPercentagesModel extends NutritionPercentagesEntity {
  const NutritionPercentagesModel({
    required super.proteinPercent,
    required super.carbsPercent,
    required super.fatsPercent,
  });

  factory NutritionPercentagesModel.fromJson(Map<String, dynamic> json) {
    return NutritionPercentagesModel(
      proteinPercent: (json['proteinPercent'] as num?)?.toDouble() ?? 0.0,
      carbsPercent: (json['carbsPercent'] as num?)?.toDouble() ?? 0.0,
      fatsPercent: (json['fatsPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
