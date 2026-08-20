import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/training_split_model.dart';

abstract class TrainingSplitRemoteDataSource {
  Future<List<TrainingSplitModel>> fetchTrainingSplit(String userId);
}

class TrainingSplitRemoteDataSourceImpl
    implements TrainingSplitRemoteDataSource {
  final ApiClient apiClient;

  TrainingSplitRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TrainingSplitModel>> fetchTrainingSplit(String userId) async {
    final response = await apiClient.get('${ApiUrls.trainingSplit}/$userId');

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      if (data.isNotEmpty) {
        // The API returns a list of "Training Splits", each containing a "splite" array
        // We probably want the first one or a specific one. Based on user request structure,
        // data[0] contains the actual split object.
        final splitData = data[0]['splite'] as List<dynamic>;
        return splitData.map((e) => TrainingSplitModel.fromJson(e)).toList();
      }
      return [];
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }
}
