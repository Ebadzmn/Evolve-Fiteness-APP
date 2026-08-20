import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_dashboard_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/fake_nutrition_repository.dart';

class GetNutritionInitialUseCase {
  final FakeNutritionRepository repo;
  GetNutritionInitialUseCase(this.repo);

  Future<NutritionDashboardEntity> call() => repo.loadInitial();
}
