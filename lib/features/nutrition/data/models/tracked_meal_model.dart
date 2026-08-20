import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';

class TrackedMealResponseModel {
  final List<DailyTrackedData> data;

  TrackedMealResponseModel({required this.data});

  factory TrackedMealResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<DailyTrackedData> dataList = list
        .map((i) => DailyTrackedData.fromJson(i))
        .toList();
    return TrackedMealResponseModel(data: dataList);
  }
}

class DailyTrackedData {
  final String id;
  final String date;
  final List<TrackedMealItem> meals;

  DailyTrackedData({required this.id, required this.date, required this.meals});

  factory DailyTrackedData.fromJson(Map<String, dynamic> json) {
    var mealsList = json['meals'] as List? ?? [];
    List<TrackedMealItem> meals = mealsList
        .map((i) => TrackedMealItem.fromJson(i))
        .toList();
    return DailyTrackedData(
      id: json['_id'] ?? '',
      date: json['date']?.toString() ?? '',
      meals: meals,
    );
  }
}

class TrackedMealItem extends NutritionMealEntity {
  const TrackedMealItem({
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

  factory TrackedMealItem.fromJson(Map<String, dynamic> json) {
    var foodList = json['food'] as List? ?? [];
    List<MealFoodItemEntity> foodItems = foodList.map((f) {
      final name = f['foodNme'] ?? 'Unknown';
      final qty = f['quantity']?.toString() ?? '0';
      final id = f['_id'];
      return MealFoodItemEntity(id: id, name: name, quantity: '$qty g');
    }).toList();

    return TrackedMealItem(
      id: json['_id'] ?? '',
      timeLabel: 'Custom', // API doesn't seem to provide time, user can edit?
      title: json['mealNumber'] ?? 'Meal',
      calories: (json['totalCalories'] as num?)?.toInt() ?? 0,
      proteinG: (json['totalProtein'] as num?)?.toDouble() ?? 0.0,
      carbsG: (json['totalCarbs'] as num?)?.toDouble() ?? 0.0,
      fatsG: (json['totalFats'] as num?)?.toDouble() ?? 0.0,
      items: foodItems,
      trainingDay: 'training day', // Default as it's not in this API response
    );
  }
}
