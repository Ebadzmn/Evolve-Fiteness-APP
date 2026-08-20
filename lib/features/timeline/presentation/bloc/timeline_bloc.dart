import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_timeline_usecase.dart';
import 'timeline_event.dart';
import 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final GetTimelineUseCase getTimelineUseCase;

  TimelineBloc({required this.getTimelineUseCase}) : super(TimelineInitial()) {
    on<FetchTimeline>(_onFetchTimeline);
  }

  Future<void> _onFetchTimeline(
    FetchTimeline event,
    Emitter<TimelineState> emit,
  ) async {
    emit(TimelineLoading());
    final result = await getTimelineUseCase(event.athleteId);
    
    result.fold(
      (failure) => emit(TimelineError(failure.message)),
      (timelineData) {
        if (timelineData.isEmpty) {
          emit(TimelineEmpty());
        } else {
          emit(TimelineLoaded(timelineData));
        }
      },
    );
  }
}
