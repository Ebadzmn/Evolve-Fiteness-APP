import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/features/training/data/models/training_plan_model.dart';
import 'package:fitness_app/features/training/data/models/training_history_model.dart';
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';

abstract class TrainingRemoteDataSource {
  Future<List<TrainingPlanModel>> getTrainingPlans(String userId);
  Future<TrainingPlanModel> getTrainingPlanById(String id);
  Future<void> saveTrainingHistory(TrainingHistoryRequest request);
  Future<TrainingHistoryResponseModel> getTrainingHistory();
}

class TrainingRemoteDataSourceImpl implements TrainingRemoteDataSource {
  final ApiClient apiClient;

  TrainingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TrainingPlanModel>> getTrainingPlans(String userId) async {
    final response = await apiClient.get('/training/plan/$userId');

    // Check if the response data is valid and has success true
    if (response.data != null && response.data['success'] == true) {
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => TrainingPlanModel.fromJson(json)).toList();
    } else {
      throw Exception(
        response.data['message'] ?? 'Failed to load training plans',
      );
    }
  }

  @override
  Future<TrainingPlanModel> getTrainingPlanById(String id) async {
    final response = await apiClient.get('/training/plan/id/$id');

    if (response.data != null && response.data['success'] == true) {
      final data = response.data['data'];
      return TrainingPlanModel.fromJson(data);
    } else {
      throw Exception(
        response.data['message'] ?? 'Failed to load training plan details',
      );
    }
  }

  @override
  Future<void> saveTrainingHistory(TrainingHistoryRequest request) async {
    final response = await apiClient.post(
      '/training/history',
      data: request.toJson(),
    );

    if (response.data != null && response.data['success'] == true) {
      return;
    } else {
      throw Exception(
        response.data['message'] ?? 'Failed to save training history',
      );
    }
  }

  @override
  Future<TrainingHistoryResponseModel> getTrainingHistory() async {
    try {
      final response = await apiClient.get('/training/history');
      print("API Response: ${response.data}"); // Debug log

      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'];
        print("API Response Data: $data"); // Debug log
        return TrainingHistoryResponseModel.fromJson(data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load training history',
        );
      }
    } catch (e) {
      print("API Error: $e");
      rethrow;
    }
  }
}
