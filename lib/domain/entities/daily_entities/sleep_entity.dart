import 'package:equatable/equatable.dart';

class SleepEntity extends Equatable {
  final String durationText;
  final double quality;

  const SleepEntity({required this.durationText, required this.quality});

  SleepEntity copyWith({String? durationText, double? quality}) => SleepEntity(
    durationText: durationText ?? this.durationText,
    quality: quality ?? this.quality,
  );

  @override
  List<Object?> get props => [durationText, quality];
}
