import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> fetchExercises({
    String? muscleCategory,
    int? page,
    int? limit,
    String? searchTerm,
  });
  Future<ExerciseModel> fetchExerciseById(String id);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ApiClient apiClient;

  ExerciseRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ExerciseModel>> fetchExercises({
    String? muscleCategory,
    int? page,
    int? limit,
    String? searchTerm,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (muscleCategory != null && muscleCategory != 'All') {
      queryParams['musalCategory'] = muscleCategory;
    }
    if (page != null) {
      queryParams['page'] = page;
    }
    if (limit != null) {
      queryParams['limit'] = limit;
    }
    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams['search'] = searchTerm;
    }

    final response = await apiClient.get(
      ApiUrls.exercise,
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data']['exercises'];

      return data.map((e) => ExerciseModel.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<ExerciseModel> fetchExerciseById(String id) async {
    final response = await apiClient.get(ApiUrls.exerciseById(id));

    if (response.data is Map<String, dynamic>) {
      final body = response.data as Map<String, dynamic>;
      if (body['success'] == true && body['data'] != null) {
        return ExerciseModel.fromJson(body['data'] as Map<String, dynamic>);
      }
      if (body['data'] is Map<String, dynamic>) {
        return ExerciseModel.fromJson(body['data'] as Map<String, dynamic>);
      }
      if (body['exercise'] is Map<String, dynamic>) {
        return ExerciseModel.fromJson(body['exercise'] as Map<String, dynamic>);
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      error: 'Failed to load exercise details',
    );
  }
}
