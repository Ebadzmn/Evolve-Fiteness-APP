import 'package:equatable/equatable.dart';

class TrainingSplitItem extends Equatable {
  final String dayLabel;
  final String work;
  const TrainingSplitItem({required this.dayLabel, required this.work});
  @override
  List<Object?> get props => [dayLabel, work];
}
