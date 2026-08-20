import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_suggestion_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class GetTrackMealSuggestionsUseCase {
  final NutritionRepository repo;
  GetTrackMealSuggestionsUseCase(this.repo);

  Future<Either<ApiException, List<MealSuggestionEntity>>> call(
    String search,
  ) => repo.getTrackMealSuggestions(search);
}
