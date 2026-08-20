import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class GetTrackMealsUseCase {
  final NutritionRepository repo;
  GetTrackMealsUseCase(this.repo);
  Future<Either<ApiException, NutritionDailyTrackingEntity>> call(
    DateTime date,
  ) => repo.getTrackedMeals(date);
}
