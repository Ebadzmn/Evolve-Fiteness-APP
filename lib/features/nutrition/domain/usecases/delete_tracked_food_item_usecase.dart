import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class DeleteTrackedFoodItemUseCase {
  final NutritionRepository repo;

  DeleteTrackedFoodItemUseCase(this.repo);

  Future<void> call(DateTime date, String mealId, String foodId) async {
    return repo.deleteTrackedFoodItem(date, mealId, foodId);
  }
}
