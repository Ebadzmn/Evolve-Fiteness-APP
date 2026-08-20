import 'package:equatable/equatable.dart';

abstract class DailyEvent extends Equatable {
  const DailyEvent();
  @override
  List<Object?> get props => [];
}

class DailyInitRequested extends DailyEvent {
  const DailyInitRequested();
}

class DailyDateChanged extends DailyEvent {
  final DateTime date;
  const DailyDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class WellBeingChanged extends DailyEvent {
  final String
  field; // 'energy', 'stress', 'muscleSoreness', 'mood', 'motivation'
  final double value;
  const WellBeingChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TrainingToggleChanged extends DailyEvent {
  final String field; // 'trainingCompleted' | 'cardioCompleted'
  final bool value;
  const TrainingToggleChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TrainingFeedbackChanged extends DailyEvent {
  final String feedback;
  const TrainingFeedbackChanged(this.feedback);
  @override
  List<Object?> get props => [feedback];
}

class DailyNotesChanged extends DailyEvent {
  final String notes;
  const DailyNotesChanged(this.notes);
  @override
  List<Object?> get props => [notes];
}

class NutritionChanged extends DailyEvent {
  final String
  field; // 'dietLevel' | 'digestion' | 'hunger' | 'salt' | 'challenge'
  final double? numberValue;
  final String? textValue;
  const NutritionChanged(this.field, {this.numberValue, this.textValue});
  @override
  List<Object?> get props => [field, numberValue, textValue];
}

class SavePressed extends DailyEvent {
  const SavePressed();
}

class VitalTextChanged extends DailyEvent {
  final String
  field; // 'weightText' | 'waterText' | 'bodyTempText' | 'activityTimeText'
  final String value;
  const VitalTextChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class SickChanged extends DailyEvent {
  final bool isSick;
  const SickChanged(this.isSick);
  @override
  List<Object?> get props => [isSick];
}

class SleepDurationChanged extends DailyEvent {
  final String durationText;
  const SleepDurationChanged(this.durationText);
  @override
  List<Object?> get props => [durationText];
}

class SleepQualityChanged extends DailyEvent {
  final double quality;
  const SleepQualityChanged(this.quality);
  @override
  List<Object?> get props => [quality];
}

class TrainingPlanToggled extends DailyEvent {
  final String plan;
  final bool selected;
  const TrainingPlanToggled(this.plan, this.selected);
  @override
  List<Object?> get props => [plan, selected];
}

class TrainingCardioTypeChanged extends DailyEvent {
  final String type;
  const TrainingCardioTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

class TrainingDurationChanged extends DailyEvent {
  final String duration;
  const TrainingDurationChanged(this.duration);
  @override
  List<Object?> get props => [duration];
}

class TrainingIntensityChanged extends DailyEvent {
  final double intensity;
  const TrainingIntensityChanged(this.intensity);
  @override
  List<Object?> get props => [intensity];
}

class NutritionTextChanged extends DailyEvent {
  final String
  field; // 'caloriesText'|'carbsText'|'proteinText'|'fatsText'|'saltText'
  final String value;
  const NutritionTextChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class WomenCyclePhaseChanged extends DailyEvent {
  final String? phase;
  const WomenCyclePhaseChanged(this.phase);
  @override
  List<Object?> get props => [phase];
}

class WomenPmsChanged extends DailyEvent {
  final double value;
  const WomenPmsChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class WomenCrampsChanged extends DailyEvent {
  final double value;
  const WomenCrampsChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class WomenSymptomsChanged extends DailyEvent {
  final Set<String> symptoms;
  const WomenSymptomsChanged(this.symptoms);
  @override
  List<Object?> get props => [symptoms];
}

class PedDosageChanged extends DailyEvent {
  final bool taken;
  const PedDosageChanged(this.taken);
  @override
  List<Object?> get props => [taken];
}

class PedSideEffectsChanged extends DailyEvent {
  final String text;
  const PedSideEffectsChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class PedBpChanged extends DailyEvent {
  final String
  field; // 'systolicText'|'diastolicText'|'restingHrText'|'glucoseText'
  final String value;
  const PedBpChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}
