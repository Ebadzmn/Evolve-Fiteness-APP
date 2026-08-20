class NutritionStatisticsEntity {
  final List<DailyCaloriesEntity> caloriesByDate;
  final NutritionTotalsEntity totals;
  final NutritionPercentagesEntity percentages;
  final int water;

  const NutritionStatisticsEntity({
    required this.caloriesByDate,
    required this.totals,
    required this.percentages,
    required this.water,
  });
}

class DailyCaloriesEntity {
  final String date;
  final String day;
  final double totalCalories;

  const DailyCaloriesEntity({
    required this.date,
    required this.day,
    required this.totalCalories,
  });
}

class NutritionTotalsEntity {
  final double totalProtein;
  final double totalFats;
  final double totalCarbs;
  final double totalCalories;

  const NutritionTotalsEntity({
    required this.totalProtein,
    required this.totalFats,
    required this.totalCarbs,
    required this.totalCalories,
  });
}

class NutritionPercentagesEntity {
  final double proteinPercent;
  final double carbsPercent;
  final double fatsPercent;

  const NutritionPercentagesEntity({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatsPercent,
  });
}
