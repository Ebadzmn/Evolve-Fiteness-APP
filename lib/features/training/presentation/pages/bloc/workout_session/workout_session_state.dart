import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';

abstract class WorkoutSessionState extends Equatable {
  const WorkoutSessionState();

  @override
  List<Object?> get props => [];
}

class WorkoutSessionInitial extends WorkoutSessionState {}

class WorkoutSessionLoading extends WorkoutSessionState {}

class WorkoutSessionLoaded extends WorkoutSessionState {
  final TrainingPlanEntity plan;

  const WorkoutSessionLoaded({required this.plan});

  @override
  List<Object?> get props => [plan];
}

class WorkoutSessionError extends WorkoutSessionState {
  final String message;

  const WorkoutSessionError({required this.message});

  @override
  List<Object?> get props => [message];
}

class WorkoutSessionSaved extends WorkoutSessionState {}
