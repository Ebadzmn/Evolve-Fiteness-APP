import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/injection_container.dart';

// Events
abstract class TimerEvent extends Equatable {
  const TimerEvent();
  @override
  List<Object?> get props => [];
}

class StartTimer extends TimerEvent {}
class PauseTimer extends TimerEvent {}
class ResetTimer extends TimerEvent {}
class SyncTimer extends TimerEvent {
  final int seconds;
  final bool isRunning;
  const SyncTimer(this.seconds, this.isRunning);
  @override
  List<Object?> get props => [seconds, isRunning];
}

// State
class TimerState extends Equatable {
  final int duration;
  final bool isRunning;

  const TimerState({required this.duration, required this.isRunning});

  factory TimerState.initial() => const TimerState(duration: 0, isRunning: false);

  TimerState copyWith({int? duration, bool? isRunning}) {
    return TimerState(
      duration: duration ?? this.duration,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  List<Object?> get props => [duration, isRunning];
}

// Bloc
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  StreamSubscription? _serviceSubscription;
  final FlutterBackgroundService _service = FlutterBackgroundService();
  final String planId;

  TimerBloc({required this.planId}) : super(TimerState.initial()) {
    on<StartTimer>(_onStart);
    on<PauseTimer>(_onPause);
    on<ResetTimer>(_onReset);
    on<SyncTimer>(_onSync);

    _serviceSubscription = _service.on('update').listen((event) {
      if (event != null &&
          event['planId']?.toString() == planId &&
          event['seconds'] != null) {
        add(SyncTimer(
          event['seconds'] as int,
          event['isRunning'] as bool? ?? state.isRunning,
        ));
      }
    });

    _checkInitialState();
    _loadPersistedState();
  }

  Future<void> _checkInitialState() async {
    final isRunning = await _service.isRunning();
    if (isRunning) {
      _service.invoke('requestUpdate', {'planId': planId});
    }
  }

  String _encodePlanId(String value) => Uri.encodeComponent(value);

  String _startTimeKey() =>
      'workout_timer_${_encodePlanId(planId)}_start_time';

  String _offsetSecondsKey() =>
      'workout_timer_${_encodePlanId(planId)}_offset_seconds';

  String _isRunningKey() =>
      'workout_timer_${_encodePlanId(planId)}_is_running';

  Future<void> _loadPersistedState() async {
    final prefs = sl<SharedPreferences>();
    final startTimeStr = prefs.getString(_startTimeKey());
    final offsetSeconds = prefs.getInt(_offsetSecondsKey()) ?? 0;
    final isRunning = prefs.getBool(_isRunningKey()) ?? false;

    int seconds = offsetSeconds;
    if (startTimeStr != null) {
      final startTime = DateTime.parse(startTimeStr);
      seconds += DateTime.now().difference(startTime).inSeconds;
    }

    if (seconds != state.duration || isRunning != state.isRunning) {
      add(SyncTimer(seconds, isRunning));
    }
  }

  Future<void> _onStart(StartTimer event, Emitter<TimerState> emit) async {
    await _ensureServiceReady();
    _service.invoke('startTimer', {'planId': planId});
    emit(state.copyWith(isRunning: true));
  }

  Future<void> _ensureServiceReady() async {
    if (await _service.isRunning()) return;

    await _service.startService();

    for (var attempt = 0; attempt < 10; attempt++) {
      if (await _service.isRunning()) return;
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  void _onPause(PauseTimer event, Emitter<TimerState> emit) {
    _service.invoke('pauseTimer', {'planId': planId});
    emit(state.copyWith(isRunning: false));
  }

  void _onReset(ResetTimer event, Emitter<TimerState> emit) {
    _service.invoke('resetTimer', {'planId': planId});
    emit(TimerState.initial());
  }

  void _onSync(SyncTimer event, Emitter<TimerState> emit) {
    // If the duration is same but isRunning changed, or vice versa
    if (state.duration != event.seconds || state.isRunning != event.isRunning) {
      emit(state.copyWith(duration: event.seconds, isRunning: event.isRunning));
    }
  }

  @override
  Future<void> close() {
    _serviceSubscription?.cancel();
    return super.close();
  }
}
