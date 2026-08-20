import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'training_history_event.dart';
import 'training_history_state.dart';

class TrainingHistoryBloc
    extends Bloc<TrainingHistoryEvent, TrainingHistoryState> {
  final GetTrainingHistoryUseCase getHistory;

  TrainingHistoryBloc({required this.getHistory})
    : super(const TrainingHistoryState()) {
    on<TrainingHistoryLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    TrainingHistoryLoadRequested event,
    Emitter<TrainingHistoryState> emit,
  ) async {
    emit(state.copyWith(status: TrainingHistoryStatus.loading));
    // TODO: Get real USER ID from Profile/Auth Bloc
    final result = await getHistory();
    result.fold(
      (failure) {
        print("Bloc Failure: ${failure.message}");
        emit(
          state.copyWith(
            status: TrainingHistoryStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        print("Bloc Success: ${response.history.length} items");
        final sortedHistory = response.history.toList()
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
        emit(
          state.copyWith(
            status: TrainingHistoryStatus.success,
            history: sortedHistory,
          ),
        );
      },
    );
  }
}
