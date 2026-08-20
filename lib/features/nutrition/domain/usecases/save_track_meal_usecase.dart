import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import '../../data/repositories/nutrition_repository.dart';

class SaveTrackMealUseCase {
  final NutritionRepository repo;
  SaveTrackMealUseCase(this.repo);
  Future<void> call(DateTime date, NutritionMealEntity meal) =>
      repo.saveTrackMeal(date, meal);
}
