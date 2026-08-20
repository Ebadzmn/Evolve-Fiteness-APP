import 'package:flutter_bloc/flutter_bloc.dart';
import 'training_event.dart';
import 'training_state.dart';
import '../../../../domain/usecases/get_training_initial_usecase.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final GetTrainingInitialUseCase getInitial;
  TrainingBloc({required this.getInitial}) : super(const TrainingState()) {
    on<TrainingInitRequested>(_onInit);
    on<RefreshRequested>(_onRefresh);
  }

  Future<void> _onInit(
    TrainingInitRequested event,
    Emitter<TrainingState> emit,
  ) async {
    emit(state.copyWith(status: TrainingStatus.loading));
    try {
      final data = await getInitial();
      emit(state.copyWith(status: TrainingStatus.ready, data: data));
    } catch (e) {
      emit(
        state.copyWith(
          status: TrainingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefresh(
    RefreshRequested event,
    Emitter<TrainingState> emit,
  ) async {
    try {
      final data = await getInitial();
      emit(state.copyWith(status: TrainingStatus.ready, data: data));
    } catch (e) {
      emit(
        state.copyWith(
          status: TrainingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
