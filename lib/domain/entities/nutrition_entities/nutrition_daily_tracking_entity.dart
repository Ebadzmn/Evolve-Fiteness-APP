import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_response_entity.dart';
import 'meal_food_item_entity.dart';

class NutritionDailyTrackingEntity extends Equatable {
  final List<DailyTrackingDataEntity> data;
  final NutritionTotalsEntity totals;
  final List<CaloriesByDateEntity> caloriesByDate;
  final int water;
  final NutritionStatsEntity stats;

  const NutritionDailyTrackingEntity({
    required this.data,
    required this.totals,
    required this.caloriesByDate,
    required this.water,
    required this.stats,
  });

  @override
  List<Object?> get props => [data, totals, caloriesByDate, water, stats];
}

class DailyTrackingDataEntity extends Equatable {
  final String id;
  final String userId;
  final String date;
  final List<TrackingMealEntity> meals;

  const DailyTrackingDataEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.meals,
  });

  @override
  List<Object?> get props => [id, userId, date, meals];
}

class TrackingMealEntity extends Equatable {
  final String id;
  final String mealNumber;
  final List<MealFoodItemEntity> food;
  final double totalProtein;
  final double totalFats;
  final double totalCarbs;
  final double totalCalories;

  const TrackingMealEntity({
    required this.id,
    required this.mealNumber,
    required this.food,
    required this.totalProtein,
    required this.totalFats,
    required this.totalCarbs,
    required this.totalCalories,
  });

  @override
  List<Object?> get props => [
    id,
    mealNumber,
    food,
    totalProtein,
    totalFats,
    totalCarbs,
    totalCalories,
  ];
}

class CaloriesByDateEntity extends Equatable {
  final String date;
  final String day;
  final double totalCalories;

  const CaloriesByDateEntity({
    required this.date,
    required this.day,
    required this.totalCalories,
  });

  @override
  List<Object?> get props => [date, day, totalCalories];
}

class NutritionStatsEntity extends Equatable {
  final NutritionPercentagesEntity percentages;

  const NutritionStatsEntity({required this.percentages});

  @override
  List<Object?> get props => [percentages];
}

class NutritionPercentagesEntity extends Equatable {
  final double proteinPercent;
  final double carbsPercent;
  final double fatsPercent;

  const NutritionPercentagesEntity({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatsPercent,
  });

  @override
  List<Object?> get props => [proteinPercent, carbsPercent, fatsPercent];
}
