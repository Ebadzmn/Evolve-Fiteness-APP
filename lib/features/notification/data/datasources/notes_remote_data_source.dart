import 'package:dio/dio.dart';
import 'package:fitness_app/core/apiUrls/api_urls.dart';
import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/features/notification/data/models/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<List<NoteModel>> getAthleteNotes(String athleteId);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final ApiClient apiClient;

  NotesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NoteModel>> getAthleteNotes(String athleteId) async {
    final response = await apiClient.get(ApiUrls.athleteNotes(athleteId));

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }
}

