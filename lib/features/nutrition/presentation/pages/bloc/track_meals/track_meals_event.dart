import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';

abstract class TrackMealsEvent extends Equatable {
  const TrackMealsEvent();
  @override
  List<Object?> get props => [];
}

class TrackMealsLoadRequested extends TrackMealsEvent {
  final DateTime date;
  const TrackMealsLoadRequested(this.date);
  @override
  List<Object?> get props => [date];
}

class TrackMealsDateChanged extends TrackMealsEvent {
  final DateTime date;
  const TrackMealsDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class TrackMealsAddMeal extends TrackMealsEvent {
  final DateTime date;
  final NutritionMealEntity meal;
  const TrackMealsAddMeal(this.date, this.meal);
  @override
  List<Object?> get props => [date, meal];
}

class TrackMealsDeleteFoodItem extends TrackMealsEvent {
  final String mealId;
  final String foodId;
  final DateTime date;
  const TrackMealsDeleteFoodItem({
    required this.mealId,
    required this.foodId,
    required this.date,
  });
  @override
  List<Object?> get props => [mealId, foodId, date];
}

class TrackMealsSuggestionQueryChanged extends TrackMealsEvent {
  final int rowIndex;
  final String query;
  const TrackMealsSuggestionQueryChanged({
    required this.rowIndex,
    required this.query,
  });
  @override
  List<Object?> get props => [rowIndex, query];
}

class TrackMealsSuggestionRequested extends TrackMealsEvent {
  final int rowIndex;
  final String query;
  const TrackMealsSuggestionRequested({
    required this.rowIndex,
    required this.query,
  });
  @override
  List<Object?> get props => [rowIndex, query];
}

class TrackMealsSuggestionsCleared extends TrackMealsEvent {
  final int rowIndex;
  const TrackMealsSuggestionsCleared({required this.rowIndex});
  @override
  List<Object?> get props => [rowIndex];
}

class TrackMealsAddFoodItemsToMeal extends TrackMealsEvent {
  final DateTime date;
  final String mealId;
  final List<MealFoodItemEntity> food;
  const TrackMealsAddFoodItemsToMeal({
    required this.date,
    required this.mealId,
    required this.food,
  });
  @override
  List<Object?> get props => [date, mealId, food];
}

class TrackMealsLogWater extends TrackMealsEvent {
  final DateTime date;
  final String unit;
  final int amount;
  const TrackMealsLogWater({
    required this.date,
    required this.unit,
    required this.amount,
  });
  @override
  List<Object?> get props => [date, unit, amount];
}
