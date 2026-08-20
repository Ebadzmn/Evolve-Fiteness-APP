import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/checkin_entities/check_in_entity.dart';
import '../../domain/entities/checkin_entities/check_in_date_entity.dart';
import '../../domain/entities/checkin_entities/old_check_in_entity.dart';
import '../../core/network/api_client.dart';
import '../../core/apiUrls/api_urls.dart';

class FakeCheckInRepository {
  final ApiClient apiClient;
  static const String _entriesKey = 'weekly_checkin_entries';

  FakeCheckInRepository({required this.apiClient});

  Future<CheckInDateEntity> getCheckInDate() async {
    final response = await apiClient.get(ApiUrls.checkInDate);
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'];
      return CheckInDateEntity.fromMap(data);
    }
    // Fallback or throw error
    throw Exception('Failed to load check-in date');
  }

  Future<CheckInEntity> loadInitial() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    final nowWeekId = _computeWeekId(DateTime.now());
    final list = prefs.getStringList(_entriesKey) ?? const <String>[];
    for (final jsonStr in list.reversed) {
      final entity = CheckInEntity.fromJson(jsonStr);
      if (entity.weekId == nowWeekId) {
        return entity;
      }
    }
    return const CheckInEntity();
  }

  Future<String?> save(
    CheckInEntity data, {
    List<Map<String, String>>? answers,
  }) async {
    final wellBeing = data.wellBeing.metrics.map(
      (key, value) => MapEntry(key, value.round()),
    );

    final questionAndAnswer = <Map<String, dynamic>>[];
    String note = data.athleteNote;

    if (answers != null && answers.isNotEmpty) {
      for (final qa in answers) {
        final q = qa['question'] ?? '';
        final qLower = q.toLowerCase();
        final a = qa['answer'] ?? '';

        if (qLower.contains('something you want to tell me') ||
            qLower.contains('athlete note')) {
          note = a.isNotEmpty ? a : note;
          // Include it in the original QnA list as well to ensure parity with backend expectation
          questionAndAnswer.add({
            'question': q,
            'answer': a,
            'status': a.isNotEmpty,
          });
        } else {
          questionAndAnswer.add({
            'question': q,
            'answer': a,
            'status': a.isNotEmpty,
          });
        }
      }
    } else {
      questionAndAnswer.add({
        'question': 'Q1 . What are you proud of? *',
        'answer': data.answer1,
        'status': data.answer1.isNotEmpty,
      });
      questionAndAnswer.add({
        'question': 'Q2 . Calories per default quantity *',
        'answer': data.answer2,
        'status': data.answer2.isNotEmpty,
      });
    }

    final formData = FormData.fromMap({
      'currentWeight': data.currentWeight,
      'averageWeight': data.averageWeight,
      'questionAndAnswer': questionAndAnswer,
      'wellBeing': wellBeing,
      'athleteNote': note,
      'image': await Future.wait(
        data.uploads.picturePaths.map(
          (p) => MultipartFile.fromFile(p, filename: p.split('/').last),
        ),
      ),
      'media':
          data.uploads.videoPath != null && data.uploads.videoPath!.isNotEmpty
          ? [
            await MultipartFile.fromFile(
              data.uploads.videoPath!,
              filename: data.uploads.videoPath!.split('/').last,
            ),
          ]
          : [],
    });
    
    final response = await apiClient.post(ApiUrls.checkInPost, data: formData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      final weekId = _computeWeekId(DateTime.now());
      final list = prefs.getStringList(_entriesKey) ?? <String>[];
      final toSave = data.copyWith(weekId: weekId).toJson();
      list.add(toSave);
      await prefs.setStringList(_entriesKey, list);

      // Return updatedAt if available in the response data
      final responseData = response.data['data'];
      if (responseData != null && responseData is Map && responseData.containsKey('updatedAt')) {
        return responseData['updatedAt'].toString();
      }
      // Fallback
      return DateTime.now().toIso8601String();
    } else {
      throw Exception(
        'Failed to submit check-in: ${response.data['message'] ?? 'Unknown error'}',
      );
    }
  }

  Future<List<CheckInEntity>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_entriesKey) ?? const <String>[];
    final items = <CheckInEntity>[];
    for (final s in list) {
      try {
        items.add(CheckInEntity.fromJson(s));
      } catch (_) {}
    }

    // Seed some dummy history if nothing saved yet, so Old Check-In is testable
    if (items.isEmpty) {
      final now = DateTime.now();
      for (int i = 0; i < 3; i++) {
        final weekDate = now.subtract(Duration(days: 7 * i));
        final weekId = _computeWeekId(weekDate);
        items.add(
          CheckInEntity(
            weekId: weekId,
            wellBeing: const CheckInWellBeing(
              metrics: {
                'energyLevel': 6,
                'stressLevel': 4,
                'moodLevel': 5,
                'sleepQuality': 6,
                'hungerLevel': 4,
              },
            ),
            nutrition: CheckInNutrition(
              dietLevel: 6 + (i.toDouble()),
              digestion: 5 + (i.toDouble()),
              challenge: 'Sample challenge week ${i + 1}',
            ),
            training: CheckInTraining(
              feelStrength: 6 + i.toDouble(),
              pumps: 6,
              trainingCompleted: true,
              cardioCompleted: i % 2 == 0,
              feedback: 'Sample feedback week ${i + 1}',
              cardioType: i % 2 == 0 ? 'Walking' : 'Cycling',
              cardioDuration: '${20 + i * 5} min',
            ),
            uploads: const CheckInUploads(
              picturesUploaded: true,
              videoUploaded: false,
            ),
            athleteNote: 'Sample notes for week starting $weekId',
          ),
        );
      }
    }

    items.sort((a, b) {
      final aw = a.weekId ?? '';
      final bw = b.weekId ?? '';
      return bw.compareTo(aw);
    });
    return items;
  }

  String _computeWeekId(DateTime dt) {
    final monday = dt.subtract(Duration(days: dt.weekday - 1));
    final y = monday.year.toString().padLeft(4, '0');
    final m = monday.month.toString().padLeft(2, '0');
    final d = monday.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Fetch old check-in data from API with pagination.
  /// Returns null if no data found for the given skip value.
  Future<OldCheckInEntity?> getOldCheckIn(int skip) async {
    try {
      final response = await apiClient.get(
        ApiUrls.oldCheckInData,
        queryParameters: {'skip': skip},
      );
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data['data'];
        if (data is List && data.isNotEmpty) {
          data = data.first;
        }
        if (data != null && data is Map<String, dynamic>) {
          return OldCheckInEntity.fromMap(data);
        }
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error in getOldCheckIn: $e');
      debugPrint('Stacktrace: $stackTrace');
      return null;
    }
  }

  /// Fetch existing check-in data for the current user.
  Future<OldCheckInEntity?> getCheckInUser() async {
    try {
      final response = await apiClient.get(ApiUrls.checkInUser);
      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data['data'];
        if (data is List && data.isNotEmpty) {
          data = data.first;
        }
        if (data != null && data is Map<String, dynamic>) {
          return OldCheckInEntity.fromMap(data);
        }
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error in getCheckInUser: $e');
      debugPrint('Stacktrace: $stackTrace');
      return null;
    }
  }
}
