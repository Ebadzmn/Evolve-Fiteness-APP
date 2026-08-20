import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/nutrition_plan_model.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_response_entity.dart';
import '../../../../domain/entities/nutrition_entities/food_item_entity.dart';
import '../models/nutrition_statistics_model.dart';
import '../models/nutrition_daily_tracking_model.dart';
import '../models/supplement_model.dart';
import '../../../../domain/entities/nutrition_entities/meal_suggestion_entity.dart';

abstract class NutritionRemoteDataSource {
  Future<NutritionPlanResponseEntity> fetchNutritionPlan(String userId);
  Future<List<FoodItemEntity>> fetchFoodItems({
    int? page,
    int? limit,
    String? search,
    String? filter,
  });
  Future<List<MealSuggestionEntity>> fetchTrackMealSuggestions(String search);
  Future<NutritionDailyTrackingModel> fetchTrackedMeals(String date);
  Future<void> deleteTrackedFoodItem(String date, String mealId, String foodId);
  Future<void> addFoodItemToMeal(
    String date,
    String mealId,
    Map<String, dynamic> foodItem,
  );
  Future<void> addFoodItemsToMeal(
    String date,
    String mealId,
    List<Map<String, dynamic>> food,
  );
  Future<void> saveTrackedMeal(String date, Map<String, dynamic> mealData);
  Future<void> updateWater(String date, String unit, int amount);
  Future<Map<String, int>> fetchWaterConfig(String date);
  Future<NutritionStatisticsModel> fetchNutritionStatistics(String date);
  Future<SupplementResponseModel> fetchSupplements(String userId);
}

class NutritionRemoteDataSourceImpl implements NutritionRemoteDataSource {
  final ApiClient apiClient;

  NutritionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<NutritionPlanResponseEntity> fetchNutritionPlan(String userId) async {
    // Construct the URL: {{baseUrl}}/coach/nutrition/69482a6a6557e1feae3fc446
    final response = await apiClient.get(
      '${ApiUrls.baseUrl}/coach/nutrition/$userId',
    );

    if (response.data['success'] == true) {
      final data = response.data['data'];
      return NutritionPlanResponseModel.fromJson(data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<List<FoodItemEntity>> fetchFoodItems({
    int? page,
    int? limit,
    String? search,
    String? filter,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (filter != null && filter.isNotEmpty) queryParams['filter'] = filter;

    final response = await apiClient.get(
      ApiUrls.nutritionFood,
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      // The API returns a paginated response: data: { items: [], ... }
      final dataObj = response.data['data'];
      final List items = dataObj['items'] ?? [];
      return items.map((e) => FoodItemEntity.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<List<MealSuggestionEntity>> fetchTrackMealSuggestions(
    String search,
  ) async {
    final response = await apiClient.get(
      ApiUrls.trackMealSuggestions,
      queryParameters: {'search': search},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'];
      if (data is List) {
        return data
            .map(
              (e) => MealSuggestionEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
      }
      return const [];
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<NutritionDailyTrackingModel> fetchTrackedMeals(String date) async {
    // API Call: {{baseUrl}}/track/meal?date=2026-01-06
    final response = await apiClient.get(
      ApiUrls.trackMeal,
      queryParameters: {'date': date},
    );

    if (response.data['success'] == true) {
      return NutritionDailyTrackingModel.fromJson(response.data['data']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<void> deleteTrackedFoodItem(
    String date,
    String mealId,
    String foodId,
  ) async {
    final url = '${ApiUrls.trackMeal}/$date/$mealId';
    final response = await apiClient.delete(
      url,
      queryParameters: {'foodId': foodId},
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<void> addFoodItemToMeal(
    String date,
    String mealId,
    Map<String, dynamic> foodItem,
  ) async {
    await apiClient.post('${ApiUrls.trackMeal}/$mealId', data: foodItem);
  }

  @override
  Future<void> addFoodItemsToMeal(
    String date,
    String mealId,
    List<Map<String, dynamic>> food,
  ) async {
    for (final item in food) {
      await apiClient.post('${ApiUrls.trackMeal}/$mealId', data: item);
    }
  }

  @override
  Future<void> saveTrackedMeal(
    String date,
    Map<String, dynamic> mealData,
  ) async {
    await apiClient.post(ApiUrls.trackMeal, data: {...mealData, 'date': date});
  }

  @override
  Future<void> updateWater(String date, String unit, int amount) async {
    await apiClient.post(ApiUrls.water, data: {
      'date': date,
      'unit': unit,
      'amount': amount,
    });
  }

  @override
  Future<Map<String, int>> fetchWaterConfig(String date) async {
    final response = await apiClient.get(
      ApiUrls.water,
      queryParameters: {'date': date},
    );

    if (response.data['success'] == true) {
      final List<dynamic> raw = response.data['data'] as List<dynamic>? ?? [];
      final Map<String, int> totalsByUnit = {};

      for (final item in raw) {
        if (item is! Map<String, dynamic>) continue;
        final unit = item['unit']?.toString();
        final amount = (item['amount'] as num?)?.toInt();
        if (unit != null && amount != null) {
          totalsByUnit[unit] = (totalsByUnit[unit] ?? 0) + amount;
        }
      }

      return totalsByUnit;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<NutritionStatisticsModel> fetchNutritionStatistics(String date) async {
    final response = await apiClient.get(
      ApiUrls.trackMeal,
      queryParameters: {'date': date},
    );

    if (response.data['success'] == true) {
      return NutritionStatisticsModel.fromJson(response.data['data']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<SupplementResponseModel> fetchSupplements(String userId) async {
    final response = await apiClient.get(
      '${ApiUrls.baseUrl}/supplement/nutrition/$userId',
    );

    if (response.data['success'] == true) {
      final data = response.data['data'];
      // API returns array directly, not paginated response
      if (data is List) {
        return SupplementResponseModel(
          items: data.map((e) => SupplementModel.fromJson(e)).toList(),
          total: data.length,
          page: 1,
          limit: data.length,
        );
      } else {
        return SupplementResponseModel.fromJson(data);
      }
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }
}
