import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';

class TrainingHistoryResponseModel extends TrainingHistoryResponseEntity {
  const TrainingHistoryResponseModel({
    required super.history,
    required super.pr,
  });

  factory TrainingHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TrainingHistoryResponseModel(
      history:
          (json['histories'] as List<dynamic>?)
              ?.map((e) => TrainingHistoryModel.fromJson(e))
              .toList() ??
          [],
      pr: PRModel.fromJson(json['pr'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'history': history
          .map((e) => (e as TrainingHistoryModel).toJson())
          .toList(),
      'pr': (pr as PRModel).toJson(),
    };
  }
}

class TrainingHistoryModel extends TrainingHistoryEntity {
  const TrainingHistoryModel({
    required super.id,
    required super.userId,
    required super.trainingName,
    required super.time,
    required super.pushData,
    required super.note,
    required super.dateTime,
    required super.updatedAt,
    super.totalWeight,
  });

  factory TrainingHistoryModel.fromJson(Map<String, dynamic> json) {
    return TrainingHistoryModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      trainingName: json['trainingName'] ?? '',
      time: TrainingTimeModel.fromJson(json['time'] ?? {}),
      pushData:
          (json['pushData'] as List<dynamic>?)
              ?.map((e) => PushDataModel.fromJson(e))
              .toList() ??
          [],
      note: json['note'] ?? '',
      dateTime: DateTime.tryParse(json['dateTime'] ?? json['createdAt'] ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      totalWeight: json['totalWeight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'trainingName': trainingName,
      'time': (time as TrainingTimeModel).toJson(),
      'pushData': pushData.map((e) => (e as PushDataModel).toJson()).toList(),
      'note': note,
      'dateTime': dateTime.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'totalWeight': totalWeight,
    };
  }
}

class PushDataModel extends PushDataEntity {
  const PushDataModel({
    required super.weight,
    required super.repRange,
    required super.rir,
    required super.sets,
    required super.exerciseName,
    super.exerciseNotes,
    super.oneRM,
  });

  factory PushDataModel.fromJson(Map<String, dynamic> json) {
    return PushDataModel(
      weight: json['weight'] ?? 0,
      repRange: json['repRange'] ?? '',
      rir: json['rir'] ?? '',
      sets: json['sets'] ?? json['set'] ?? 0,
      exerciseName: json['exerciseName'] ?? '',
      exerciseNotes: json['exerciseNotes'] ?? json['excerciseNotes'],
      oneRM: json['oneRM'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'repRange': repRange,
      'rir': rir,
      'sets': sets,
      'exerciseName': exerciseName,
      if (exerciseNotes != null) 'exerciseNotes': exerciseNotes,
      if (exerciseNotes != null) 'excerciseNotes': exerciseNotes,
      'oneRM': oneRM,
    };
  }
}

class TrainingTimeModel extends TrainingTimeEntity {
  const TrainingTimeModel({required super.hour, required super.minute});

  factory TrainingTimeModel.fromJson(Map<String, dynamic> json) {
    return TrainingTimeModel(
      hour: json['hour'] ?? '',
      minute: json['minite'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'hour': hour, 'minite': minute};
  }
}

class PRModel extends PREntity {
  const PRModel({required super.volumePR});

  factory PRModel.fromJson(Map<String, dynamic> json) {
    return PRModel(volumePR: json['volumePR'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {'volumePR': volumePR};
  }
}
