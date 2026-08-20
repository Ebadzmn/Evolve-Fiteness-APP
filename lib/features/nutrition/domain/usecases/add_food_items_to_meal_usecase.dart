import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class AddFoodItemsToMealUseCase {
  final NutritionRepository repository;

  AddFoodItemsToMealUseCase(this.repository);

  Future<Either<ApiException, void>> call(
    DateTime date,
    String mealId,
    List<MealFoodItemEntity> food,
  ) async {
    return repository.addFoodItemsToMeal(date, mealId, food);
  }
}
