import '../../../../domain/entities/nutrition_entities/nutrition_statistics_entity.dart';
import '../../data/repositories/nutrition_repository.dart';

class GetNutritionStatisticsUseCase {
  final NutritionRepository repository;

  GetNutritionStatisticsUseCase(this.repository);

  Future<NutritionStatisticsEntity> call(DateTime date) {
    return repository.getNutritionStatistics(date);
  }
}
