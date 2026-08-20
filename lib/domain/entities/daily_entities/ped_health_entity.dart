import 'package:equatable/equatable.dart';

class PedHealthEntity extends Equatable {
  final bool dosageTaken;
  final String sideEffects;
  final String systolicText;
  final String diastolicText;
  final String restingHrText;
  final String glucoseText;

  const PedHealthEntity({
    required this.dosageTaken,
    required this.sideEffects,
    required this.systolicText,
    required this.diastolicText,
    required this.restingHrText,
    required this.glucoseText,
  });

  PedHealthEntity copyWith({
    bool? dosageTaken,
    String? sideEffects,
    String? systolicText,
    String? diastolicText,
    String? restingHrText,
    String? glucoseText,
  }) => PedHealthEntity(
    dosageTaken: dosageTaken ?? this.dosageTaken,
    sideEffects: sideEffects ?? this.sideEffects,
    systolicText: systolicText ?? this.systolicText,
    diastolicText: diastolicText ?? this.diastolicText,
    restingHrText: restingHrText ?? this.restingHrText,
    glucoseText: glucoseText ?? this.glucoseText,
  );

  @override
  List<Object?> get props => [
    dosageTaken,
    sideEffects,
    systolicText,
    diastolicText,
    restingHrText,
    glucoseText,
  ];
}
