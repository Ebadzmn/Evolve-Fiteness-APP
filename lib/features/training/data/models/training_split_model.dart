import '../../../../domain/entities/training_entities/training_split_entity.dart';

class TrainingSplitModel extends TrainingSplitItem {
  const TrainingSplitModel({required super.dayLabel, required super.work});

  factory TrainingSplitModel.fromJson(Map<String, dynamic> json) {
    return TrainingSplitModel(
      dayLabel: json['day'] ?? '',
      work: json['exerciseName'] ?? '',
    );
  }
}
