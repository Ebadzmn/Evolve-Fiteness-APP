import '../../domain/entities/timeline_entity.dart';

class TimelineModel extends TimelineEntity {
  const TimelineModel({
    required super.date,
    required super.phase,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      date: json['checkInDate'] as String? ?? json['date'] as String? ?? '',
      phase: json['phase'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkInDate': date,
      'phase': phase,
    };
  }
}
