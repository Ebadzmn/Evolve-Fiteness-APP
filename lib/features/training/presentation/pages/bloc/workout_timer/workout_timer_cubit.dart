import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_timer_state.dart';

class WorkoutTimerCubit extends Cubit<WorkoutTimerState> {
  Timer? _timer;

  WorkoutTimerCubit() : super(const WorkoutTimerState());

  void startTimer() {
    if (state.isRunning) return;

    emit(state.copyWith(isRunning: true));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.copyWith(duration: state.duration + 1));
    });
  }

  void stopTimer() {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  void toggleTimer() {
    if (state.isRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  void resetTimer() {
    stopTimer();
    emit(const WorkoutTimerState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
