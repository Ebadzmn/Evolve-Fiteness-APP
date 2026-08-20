import 'package:dartz/dartz.dart';
import '../../../../domain/entities/nutrition_entities/meal_food_item_entity.dart';
import 'package:dio/dio.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_response_entity.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import '../../../../domain/entities/nutrition_entities/food_item_entity.dart';
import '../../../../features/nutrition/data/repositories/nutrition_repository.dart';
import '../datasources/nutrition_remote_data_source.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_statistics_entity.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
import '../../../../domain/entities/nutrition_entities/supplement_entity.dart';
import '../../../../domain/entities/nutrition_entities/meal_suggestion_entity.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  final NutritionRemoteDataSource remoteDataSource;

  NutritionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ApiException, NutritionPlanResponseEntity>> getNutritionPlan(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.fetchNutritionPlan(userId);
      return Right(result);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<List<FoodItemEntity>> getFoodItems({
    int? page,
    int? limit,
    String? search,
    String? filter,
  }) async {
    try {
      return await remoteDataSource.fetchFoodItems(
        page: page,
        limit: limit,
        search: search,
        filter: filter,
      );
    } on DioException catch (e) {
      throw ApiException(message: e.message ?? 'Failed to fetch food items');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Either<ApiException, List<MealSuggestionEntity>>>
  getTrackMealSuggestions(String search) async {
    try {
      final result = await remoteDataSource.fetchTrackMealSuggestions(search);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiException(message: e.message ?? 'Failed to fetch suggestions'),
      );
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, NutritionDailyTrackingEntity>> getTrackedMeals(
    DateTime date,
  ) async {
    try {
      // Convert DateTime to YYYY-MM-DD string
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final result = await remoteDataSource.fetchTrackedMeals(dateStr);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiException(message: e.message ?? 'Failed to fetch tracked meals'),
      );
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> addFoodItemToMeal(
    DateTime date,
    String mealId,
    MealFoodItemEntity foodItem,
  ) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final qtyStr = foodItem.quantity.replaceAll(RegExp(r'[^0-9]'), '');
      final qty = int.tryParse(qtyStr) ?? 0;
      await remoteDataSource.addFoodItemToMeal(dateStr, mealId, {
        'foodNme': foodItem.name,
        'quantity': qty,
      });
      return const Right(null);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> addFoodItemsToMeal(
    DateTime date,
    String mealId,
    List<MealFoodItemEntity> food,
  ) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      await remoteDataSource.addFoodItemsToMeal(
        dateStr,
        mealId,
        food.map((item) {
          final qtyStr = item.quantity.replaceAll(RegExp(r'[^0-9]'), '');
          final qty = int.tryParse(qtyStr) ?? 0;
          return {'foodNme': item.name, 'quantity': qty};
        }).toList(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> saveTrackMeal(
    DateTime date,
    NutritionMealEntity meal,
  ) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      await remoteDataSource.saveTrackedMeal(dateStr, {
        'mealNumber': meal.title,
        'food': meal.items.map((item) {
          // quantity usually comes as "30g" or "30". Try to parse integer.
          // Removing non-digits to be safe if user typed "30g"
          final qtyStr = item.quantity.replaceAll(RegExp(r'[^0-9]'), '');
          final qty = int.tryParse(qtyStr) ?? 0;
          return {'foodNme': item.name, 'quantity': qty};
        }).toList(),
      });
      return const Right(null);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<void> deleteTrackedFoodItem(
    DateTime date,
    String mealId,
    String foodId,
  ) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      await remoteDataSource.deleteTrackedFoodItem(dateStr, mealId, foodId);
    } on DioException catch (e) {
      throw ApiException(message: e.message ?? 'Failed to delete food item');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Either<ApiException, void>> updateWater(
    DateTime date,
    String unit,
    int amount,
  ) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      await remoteDataSource.updateWater(dateStr, unit, amount);
      return const Right(null);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, Map<String, int>>> getWaterConfig(
    DateTime date,
  ) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final result = await remoteDataSource.fetchWaterConfig(dateStr);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiException(message: e.message ?? 'Failed to fetch water config'),
      );
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<NutritionStatisticsEntity> getNutritionStatistics(
    DateTime date,
  ) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return await remoteDataSource.fetchNutritionStatistics(dateStr);
    } on DioException catch (e) {
      throw ApiException(message: e.message ?? 'Failed to fetch statistics');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Either<ApiException, SupplementResponseEntity>> getSupplements(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.fetchSupplements(userId);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiException(message: e.message ?? 'Failed to fetch supplements'),
      );
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
