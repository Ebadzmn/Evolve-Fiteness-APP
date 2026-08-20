import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/save_training_history_usecase.dart';
import 'workout_session_state.dart';

class WorkoutSessionCubit extends Cubit<WorkoutSessionState> {
  final GetTrainingPlanByIdUseCase getTrainingPlanById;
  final SaveTrainingHistoryUseCase saveTrainingHistory;
  final GetProfileUseCase getProfile;

  WorkoutSessionCubit({
    required this.getTrainingPlanById,
    required this.saveTrainingHistory,
    required this.getProfile,
  }) : super(WorkoutSessionInitial());

  Future<void> loadWorkoutSession(String planId) async {
    emit(WorkoutSessionLoading());
    final result = await getTrainingPlanById(planId);
    result.fold(
      (failure) => emit(WorkoutSessionError(message: failure.message)),
      (plan) => emit(WorkoutSessionLoaded(plan: plan)),
    );
  }

  Future<void> saveSession({
    required String trainingName,
    required TrainingTime time,
    required List<PushData> pushData,
    required String note,
  }) async {
    // Keep current state to retrieve plan if needed, or emit loading overlay?
    // We probably want to stay on the page but show loading.
    // Ideally we'd have a specific "Saving" state or a status field.
    // For now, let's just emit Loading and then Saved or Error.
    // NOTE: This might rebuild the whole page and lose the form state if not careful.
    // In strict Bloc, the UI should listen to "Saving" and show a dialog,
    // NOT replace the whole "Loaded" state that holds the list.
    // However, since we are "completing" the session, maybe replacing it is fine or we navigate away.
    // Let's assume we replace state because we are done.

    // But first, get UserID
    final profileResult = await getProfile();
    String? userId;
    profileResult.fold(
      (failure) {
        emit(
          WorkoutSessionError(
            message: 'Failed to get user profile: ${failure.message}',
          ),
        );
      },
      (profile) {
        userId = profile.athlete.id; // Corrected to use athlete.id
      },
    );

    if (userId == null) return; // Error emitted above

    final request = TrainingHistoryRequest(
      userId: userId!,
      trainingName: trainingName,
      time: time,
      pushData: pushData,
      note: note,
      dateTime: DateTime.now(),
    );

    final result = await saveTrainingHistory(request);
    result.fold(
      (failure) => emit(WorkoutSessionError(message: failure.message)),
      (_) => emit(WorkoutSessionSaved()),
    );
  }
}
