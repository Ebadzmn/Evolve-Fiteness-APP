import 'package:equatable/equatable.dart';

class CheckInDateEntity extends Equatable {
  final String checkInDay;
  final String lastDate;
  final String nextCheckInDate;
  final double currentWeight;
  final double averageWeight;

  const CheckInDateEntity({
    required this.checkInDay,
    required this.lastDate,
    required this.nextCheckInDate,
    required this.currentWeight,
    required this.averageWeight,
  });

  CheckInDateEntity copyWith({
    String? checkInDay,
    String? lastDate,
    String? nextCheckInDate,
    double? currentWeight,
    double? averageWeight,
  }) {
    return CheckInDateEntity(
      checkInDay: checkInDay ?? this.checkInDay,
      lastDate: lastDate ?? this.lastDate,
      nextCheckInDate: nextCheckInDate ?? this.nextCheckInDate,
      currentWeight: currentWeight ?? this.currentWeight,
      averageWeight: averageWeight ?? this.averageWeight,
    );
  }

  factory CheckInDateEntity.fromMap(Map<String, dynamic> map) {
    return CheckInDateEntity(
      checkInDay: map['checkInDay'] ?? '',
      lastDate: map['lastDate'] ?? '',
      nextCheckInDate: map['nextCheckInDate'] ?? '',
      currentWeight: (map['currentWeight'] ?? 0).toDouble(),
      averageWeight: (map['averageWeight'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'checkInDay': checkInDay,
      'lastDate': lastDate,
      'nextCheckInDate': nextCheckInDate,
      'currentWeight': currentWeight,
      'averageWeight': averageWeight,
    };
  }

  @override
  List<Object?> get props => [
    checkInDay,
    lastDate,
    nextCheckInDate,
    currentWeight,
    averageWeight,
  ];
}
