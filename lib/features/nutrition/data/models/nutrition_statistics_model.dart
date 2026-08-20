import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_statistics_entity.dart';

class NutritionStatisticsModel extends NutritionStatisticsEntity {
  const NutritionStatisticsModel({
    required super.caloriesByDate,
    required super.totals,
    required super.percentages,
    required super.water,
  });

  factory NutritionStatisticsModel.fromJson(Map<String, dynamic> json) {
    return NutritionStatisticsModel(
      caloriesByDate: (json['caloriesByDate'] as List? ?? [])
          .map((e) => DailyCaloriesModel.fromJson(e))
          .toList(),
      totals: NutritionTotalsModel.fromJson(json['totals'] ?? {}),
      percentages: NutritionPercentagesModel.fromJson(
        json['stats']?['percentages'] ?? {},
      ),
      water: (json['water'] as num?)?.toInt() ?? 0,
    );
  }
}

class DailyCaloriesModel extends DailyCaloriesEntity {
  const DailyCaloriesModel({
    required super.date,
    required super.day,
    required super.totalCalories,
  });

  factory DailyCaloriesModel.fromJson(Map<String, dynamic> json) {
    return DailyCaloriesModel(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      totalCalories: (json['totalCalories'] as num?)?.toDouble() ?? 0.0,
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
      totalCalories: (json['totalCalories'] as num?)?.toDouble() ?? 0.0,
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
