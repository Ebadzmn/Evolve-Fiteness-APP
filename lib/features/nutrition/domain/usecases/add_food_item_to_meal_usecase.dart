import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class AddFoodItemToMealUseCase {
  final NutritionRepository repository;

  AddFoodItemToMealUseCase(this.repository);

  Future<Either<ApiException, void>> call(
    DateTime date,
    String mealId,
    MealFoodItemEntity foodItem,
  ) async {
    return await repository.addFoodItemToMeal(date, mealId, foodItem);
  }
}
