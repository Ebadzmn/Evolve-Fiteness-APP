import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plans_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'training_plan_event.dart';
import 'training_plan_state.dart';

class TrainingPlanBloc extends Bloc<TrainingPlanEvent, TrainingPlanState> {
  final GetTrainingPlansUseCase getTrainingPlans;
  final GetTrainingHistoryUseCase? getTrainingHistory;

  TrainingPlanBloc({
    required this.getTrainingPlans,
    this.getTrainingHistory,
  }) : super(const TrainingPlanState()) {
    on<TrainingPlanLoadRequested>(_onLoadRequested);
    on<TrainingPlanReordered>(_onReordered);
  }

  Future<void> _onLoadRequested(
    TrainingPlanLoadRequested event,
    Emitter<TrainingPlanState> emit,
  ) async {
    emit(state.copyWith(status: TrainingPlanStatus.loading));
    
    final Map<String, DateTime> lastWorkoutDates = {};
    if (getTrainingHistory != null) {
      final historyResult = await getTrainingHistory!.call();
      historyResult.fold(
        (_) {},
        (historyResponse) {
          for (final history in historyResponse.history) {
            final key = history.trainingName.trim().toLowerCase();
            if (key.isEmpty) continue;
            if (!lastWorkoutDates.containsKey(key) ||
                history.dateTime.isAfter(lastWorkoutDates[key]!)) {
              lastWorkoutDates[key] = history.dateTime;
            }
          }
        },
      );
    }

    final result = await getTrainingPlans();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TrainingPlanStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (plans) {
        emit(
          state.copyWith(
            status: TrainingPlanStatus.success,
            plans: plans,
            lastWorkoutDates: lastWorkoutDates,
          ),
        );
      },
    );
  }

  void _onReordered(
    TrainingPlanReordered event,
    Emitter<TrainingPlanState> emit,
  ) {
    int oldIndex = event.oldIndex;
    int newIndex = event.newIndex;
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final updatedList = List<TrainingPlanEntity>.from(state.plans);
    final item = updatedList.removeAt(oldIndex);
    updatedList.insert(newIndex, item);
    emit(state.copyWith(plans: updatedList));
  }
}
