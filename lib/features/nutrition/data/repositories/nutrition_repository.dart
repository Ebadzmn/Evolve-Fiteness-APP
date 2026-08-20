import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_response_entity.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import '../../../../domain/entities/nutrition_entities/food_item_entity.dart';
import '../../../../domain/entities/nutrition_entities/meal_food_item_entity.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_statistics_entity.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
import '../../../../domain/entities/nutrition_entities/supplement_entity.dart';
import '../../../../domain/entities/nutrition_entities/meal_suggestion_entity.dart';

abstract class NutritionRepository {
  Future<Either<ApiException, NutritionPlanResponseEntity>> getNutritionPlan(
    String userId,
  );
  Future<List<FoodItemEntity>> getFoodItems({
    int? page,
    int? limit,
    String? search,
    String? filter,
  });
  Future<Either<ApiException, List<MealSuggestionEntity>>>
  getTrackMealSuggestions(String search);
  Future<Either<ApiException, NutritionDailyTrackingEntity>> getTrackedMeals(
    DateTime date,
  );
  Future<void> deleteTrackedFoodItem(
    DateTime date,
    String mealId,
    String foodId,
  );
  Future<Either<ApiException, void>> addFoodItemToMeal(
    DateTime date,
    String mealId,
    MealFoodItemEntity foodItem,
  );
  Future<Either<ApiException, void>> addFoodItemsToMeal(
    DateTime date,
    String mealId,
    List<MealFoodItemEntity> food,
  );
  Future<Either<ApiException, void>> saveTrackMeal(
    DateTime date,
    NutritionMealEntity meal,
  );
  Future<Either<ApiException, void>> updateWater(DateTime date, String unit, int amount);
  Future<Either<ApiException, Map<String, int>>> getWaterConfig(DateTime date);
  Future<NutritionStatisticsEntity> getNutritionStatistics(DateTime date);
  Future<Either<ApiException, SupplementResponseEntity>> getSupplements(
    String userId,
  );
}
