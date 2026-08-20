import '../../../../core/network/api_client.dart';
import '../models/timeline_model.dart';


abstract class TimelineRemoteDataSource {
  Future<List<TimelineModel>> getTimeline(String athleteId);
}

class TimelineRemoteDataSourceImpl implements TimelineRemoteDataSource {
  final ApiClient apiClient;

  TimelineRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TimelineModel>> getTimeline(String athleteId) async {
    final response = await apiClient.get('/timeline/$athleteId');
    
    // The prompt says "Response: data[]" 
    // Usually standard responses have `data` field holding the array, or the response directly is an array.
    final responseData = response.data;
    
    List<dynamic> list;
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      list = responseData['data'] as List<dynamic>;
    } else if (responseData is List<dynamic>) {
      list = responseData;
    } else {
      list = [];
    }

    return list.map((e) => TimelineModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
