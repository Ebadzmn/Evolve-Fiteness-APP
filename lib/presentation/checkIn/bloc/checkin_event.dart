import 'package:equatable/equatable.dart';

abstract class CheckInEvent extends Equatable {
  const CheckInEvent();
  @override
  List<Object?> get props => [];
}

class CheckInTabSet extends CheckInEvent {
  final String tab; // 'weekly' | 'old'
  const CheckInTabSet(this.tab);
  @override
  List<Object?> get props => [tab];
}

class CheckInInitRequested extends CheckInEvent {
  const CheckInInitRequested();
}

class CheckInStepSet extends CheckInEvent {
  final int step;
  const CheckInStepSet(this.step);
  @override
  List<Object?> get props => [step];
}

class CheckInNextPressed extends CheckInEvent {
  const CheckInNextPressed();
}

class AnswerChanged extends CheckInEvent {
  final int index;
  final String value;
  const AnswerChanged(this.index, this.value);
  @override
  List<Object?> get props => [index, value];
}

class WellBeingChanged extends CheckInEvent {
  final String field;
  final double value;
  const WellBeingChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class NutritionNumberChanged extends CheckInEvent {
  final String field;
  final double value;
  const NutritionNumberChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class NutritionTextChanged extends CheckInEvent {
  final String field;
  final String value;
  const NutritionTextChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class UploadsToggled extends CheckInEvent {
  final String field;
  final bool value;
  const UploadsToggled(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TrainingNumberChanged extends CheckInEvent {
  final String field;
  final double value;
  const TrainingNumberChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TrainingToggleChanged extends CheckInEvent {
  final String field;
  final bool value;
  const TrainingToggleChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TrainingTextChanged extends CheckInEvent {
  final String field;
  final String value;
  const TrainingTextChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class AthleteNoteChanged extends CheckInEvent {
  final String value;
  const AthleteNoteChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class SubmitPressed extends CheckInEvent {
  final List<Map<String, String>> answers;
  const SubmitPressed({required this.answers});
  @override
  List<Object?> get props => [answers];
}

class CheckInHistoryPrev extends CheckInEvent {
  const CheckInHistoryPrev();
}

class CheckInHistoryNext extends CheckInEvent {
  const CheckInHistoryNext();
}

class CheckInDateRequested extends CheckInEvent {
  const CheckInDateRequested();
  @override
  List<Object?> get props => [];
}

class PhotoSelected extends CheckInEvent {
  final List<String> paths;
  const PhotoSelected(this.paths);
  @override
  List<Object?> get props => [paths];
}

class PhotoRemoved extends CheckInEvent {
  final String path;
  const PhotoRemoved(this.path);
  @override
  List<Object?> get props => [path];
}

class VideoSelected extends CheckInEvent {
  final String path;
  const VideoSelected(this.path);
  @override
  List<Object?> get props => [path];
}

class UploadButtonPressed extends CheckInEvent {
  const UploadButtonPressed();
}

class WeightChanged extends CheckInEvent {
  final String field;
  final double value;
  const WeightChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class CheckInRefreshRequested extends CheckInEvent {
  const CheckInRefreshRequested();
}
