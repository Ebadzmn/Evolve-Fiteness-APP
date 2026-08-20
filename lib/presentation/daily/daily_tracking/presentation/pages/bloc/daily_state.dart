import 'package:equatable/equatable.dart';
import '../../../../../../domain/entities/daily_entities/daily_tracking_entity.dart';
import '../../../../../../domain/entities/training_entities/training_plan_entity.dart';

enum DailyStatus { initial, loading, success, saving, saved, error }

class DailyState extends Equatable {
  final DailyStatus status;
  final DailyTrackingEntity? data;
  final String? errorMessage;
  final bool isReadOnly;
  final bool isUpdate;
  final List<TrainingPlanEntity> trainingPlans;

  const DailyState({
    this.status = DailyStatus.initial,
    this.data,
    this.errorMessage,
    this.isReadOnly = false,
    this.isUpdate = false,
    this.trainingPlans = const [],
  });

  DailyState copyWith({
    DailyStatus? status,
    DailyTrackingEntity? data,
    String? errorMessage,
    bool? isReadOnly,
    bool? isUpdate,
    List<TrainingPlanEntity>? trainingPlans,
  }) => DailyState(
    status: status ?? this.status,
    data: data ?? this.data,
    errorMessage: errorMessage ?? this.errorMessage,
    isReadOnly: isReadOnly ?? this.isReadOnly,
    isUpdate: isUpdate ?? this.isUpdate,
    trainingPlans: trainingPlans ?? this.trainingPlans,
  );

  @override
  List<Object?> get props => [
    status,
    data,
    errorMessage,
    isReadOnly,
    isUpdate,
    trainingPlans,
  ];
}
