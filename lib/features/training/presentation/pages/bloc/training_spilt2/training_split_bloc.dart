import 'package:flutter_bloc/flutter_bloc.dart';
import 'training_split_event.dart';
import 'training_split_state.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_split_usecase.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';

class TrainingSplitBloc extends Bloc<TrainingSplitEvent, TrainingSplitState> {
  final GetTrainingSplitUseCase getSplit;
  final GetProfileUseCase getProfile;

  TrainingSplitBloc({required this.getSplit, required this.getProfile})
    : super(const TrainingSplitState()) {
    on<TrainingSplitInitRequested>(_onInit);
  }

  Future<void> _onInit(
    TrainingSplitInitRequested event,
    Emitter<TrainingSplitState> emit,
  ) async {
    emit(state.copyWith(status: TrainingSplitStatus.loading));

    final profileResult = await getProfile();
    await profileResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: TrainingSplitStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (profile) async {
        final userId = profile.athlete.id;
        final result = await getSplit(userId);
        result.fold(
          (failure) => emit(
            state.copyWith(
              status: TrainingSplitStatus.error,
              errorMessage: failure.message,
            ),
          ),
          (items) => emit(
            state.copyWith(status: TrainingSplitStatus.ready, items: items),
          ),
        );
      },
    );
  }
}
