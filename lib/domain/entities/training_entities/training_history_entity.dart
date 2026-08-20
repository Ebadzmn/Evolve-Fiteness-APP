import 'package:equatable/equatable.dart';

class TrainingHistoryResponseEntity extends Equatable {
  final List<TrainingHistoryEntity> history;
  final PREntity pr;

  const TrainingHistoryResponseEntity({
    required this.history,
    required this.pr,
  });

  @override
  List<Object?> get props => [history, pr];
}

class TrainingHistoryEntity extends Equatable {
  final String id;
  final String userId;
  final String trainingName;
  final TrainingTimeEntity time;
  final List<PushDataEntity> pushData;
  final String note;
  final DateTime dateTime;
  final DateTime updatedAt;
  final num? totalWeight;

  const TrainingHistoryEntity({
    required this.id,
    required this.userId,
    required this.trainingName,
    required this.time,
    required this.pushData,
    required this.note,
    required this.dateTime,
    required this.updatedAt,
    this.totalWeight,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    trainingName,
    time,
    pushData,
    note,
    dateTime,
    updatedAt,
    totalWeight,
  ];
}

class PushDataEntity extends Equatable {
  final num weight;
  final String repRange;
  final String rir;
  final int sets;
  final String exerciseName;
  final String? exerciseNotes;
  final num? oneRM;

  const PushDataEntity({
    required this.weight,
    required this.repRange,
    required this.rir,
    required this.sets,
    required this.exerciseName,
    this.exerciseNotes,
    this.oneRM,
  });

  @override
  List<Object?> get props => [weight, repRange, rir, sets, exerciseName, exerciseNotes, oneRM];
}

class TrainingTimeEntity extends Equatable {
  final String hour;
  final String minute;

  const TrainingTimeEntity({required this.hour, required this.minute});

  @override
  List<Object?> get props => [hour, minute];
}

class PREntity extends Equatable {
  final bool volumePR;

  const PREntity({required this.volumePR});

  @override
  List<Object?> get props => [volumePR];
}
