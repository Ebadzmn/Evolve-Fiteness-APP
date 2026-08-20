import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/profile_entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;

  ProfileBloc({required this.getProfile}) : super(const ProfileState()) {
    on<ProfileLoadRequested>(_onLoad);
    on<ProfileImageUpdateRequested>(_onImageUpdate);
  }

  Future<void> _onLoad(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState(status: ProfileStatus.loading));
    final result = await getProfile();
    result.fold(
      (failure) => emit(
        ProfileState(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        ProfileState(
          status: ProfileStatus.success,
          profile: data,
        ),
      ),
    );
  }

  Future<void> _onImageUpdate(
    ProfileImageUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isUpdatingImage: true,
        errorMessage: null,
        successMessage: null,
        tempImagePath: event.image.path,
      ),
    );

    final result = await getProfile.updateProfileImage(event.image);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isUpdatingImage: false,
          errorMessage: failure.message,
          successMessage: null,
        ),
      ),
      (data) {
        final current = state.profile;
        if (current != null) {
          final updatedAthlete = AthleteEntity(
            id: current.athlete.id,
            name: current.athlete.name,
            coachId: current.athlete.coachId,
            role: current.athlete.role,
            email: current.athlete.email,
            gender: current.athlete.gender,
            category: current.athlete.category,
            phase: current.athlete.phase,
            weight: current.athlete.weight,
            height: current.athlete.height,
            image: data.athlete.image,
            notifiedThisWeek: current.athlete.notifiedThisWeek,
            age: current.athlete.age,
            waterQuantity: current.athlete.waterQuantity,
            status: current.athlete.status,
            trainingDaySteps: current.athlete.trainingDaySteps,
            restDaySteps: current.athlete.restDaySteps,
            checkInDay: current.athlete.checkInDay,
            goal: current.athlete.goal,
            verified: current.athlete.verified,
            isActive: current.athlete.isActive,
            createdAt: current.athlete.createdAt,
            updatedAt: current.athlete.updatedAt,
            lastActive: current.athlete.lastActive,
          );

          final updatedProfile = ProfileEntity(
            athlete: updatedAthlete,
            coachName: current.coachName,
            timeline: current.timeline,
            show: current.show,
            countDown: current.countDown,
          );

          emit(
            state.copyWith(
              isUpdatingImage: false,
              profile: updatedProfile,
              errorMessage: null,
              successMessage: 'Profile picture updated successfully',
              tempImagePath: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isUpdatingImage: false,
              profile: data,
              errorMessage: null,
              successMessage: 'Profile picture updated successfully',
              tempImagePath: null,
            ),
          );
        }
      },
    );
  }
}
