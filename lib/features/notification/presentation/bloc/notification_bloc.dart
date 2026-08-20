import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/notification/domain/usecases/get_athlete_notes_usecase.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetAthleteNotesUseCase getNotes;
  final GetProfileUseCase getProfile;

  NotificationBloc({
    required this.getNotes,
    required this.getProfile,
  }) : super(const NotificationState()) {
    on<FetchAthleteNotes>(_onFetchNotes);
  }

  Future<void> _onFetchNotes(
    FetchAthleteNotes event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotesStatus.loading, errorMessage: null));

    final profileResult = await getProfile();
    await profileResult.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotesStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (profile) async {
        final athleteId = profile.athlete.id;
        final notesResult = await getNotes(athleteId);
        notesResult.fold(
          (failure) {
            emit(
              state.copyWith(
                status: NotesStatus.error,
                errorMessage: failure.message,
              ),
            );
          },
          (notes) {
            if (notes.isEmpty) {
              emit(
                state.copyWith(
                  status: NotesStatus.empty,
                  notes: [],
                  errorMessage: null,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  status: NotesStatus.loaded,
                  notes: notes,
                  errorMessage: null,
                ),
              );
            }
          },
        );
      },
    );
  }
}

