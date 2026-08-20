import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';

abstract class TrainingPlanDetailState extends Equatable {
  const TrainingPlanDetailState();

  @override
  List<Object?> get props => [];
}

class TrainingPlanDetailInitial extends TrainingPlanDetailState {}

class TrainingPlanDetailLoading extends TrainingPlanDetailState {}

class TrainingPlanDetailLoaded extends TrainingPlanDetailState {
  final TrainingPlanEntity plan;

  const TrainingPlanDetailLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}

class TrainingPlanDetailError extends TrainingPlanDetailState {
  final String message;

  const TrainingPlanDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
