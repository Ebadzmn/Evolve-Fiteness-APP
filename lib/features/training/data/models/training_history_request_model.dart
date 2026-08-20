class TrainingHistoryRequest {
  final String userId;
  final String trainingName;
  final TrainingTime time;
  final List<PushData> pushData;
  final String note;
  final DateTime dateTime;

  TrainingHistoryRequest({
    required this.userId,
    required this.trainingName,
    required this.time,
    required this.pushData,
    required this.note,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'trainingName': trainingName,
      'time': time.toJson(),
      'pushData': pushData.map((e) => e.toJson()).toList(),
      'note': note,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

class TrainingTime {
  final String hour;
  final String minite;

  TrainingTime({required this.hour, required this.minite});

  Map<String, dynamic> toJson() {
    return {'hour': hour, 'minite': minite};
  }
}

class PushData {
  final num weight;
  final String repRange;
  final String rir;
  final int sets;
  final String exerciseName;
  final String? exerciseNotes;

  PushData({
    required this.weight,
    required this.repRange,
    required this.rir,
    required this.sets,
    required this.exerciseName,
    this.exerciseNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'repRange': repRange,
      'rir': rir,
      'sets': sets,
      'exerciseName': exerciseName,
      if (exerciseNotes != null) 'exerciseNotes': exerciseNotes,
      if (exerciseNotes != null) 'excerciseNotes': exerciseNotes,
    };
  }
}
