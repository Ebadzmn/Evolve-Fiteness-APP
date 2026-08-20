import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import '../../../../domain/usecases/get_supplements_usecase.dart';
import 'nutrition_supplement_event.dart';
import 'nutrition_supplement_state.dart';

class NutritionSupplementBloc
    extends Bloc<NutritionSupplementEvent, NutritionSupplementState> {
  final GetSupplementsUseCase getSupplements;
  final GetProfileUseCase getProfile;

  NutritionSupplementBloc({
    required this.getSupplements,
    required this.getProfile,
  }) : super(const NutritionSupplementState()) {
    on<NutritionSupplementLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    NutritionSupplementLoadRequested event,
    Emitter<NutritionSupplementState> emit,
  ) async {
    emit(state.copyWith(status: NutritionSupplementStatus.loading));

    final profileResult = await getProfile();
    await profileResult.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NutritionSupplementStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (profile) async {
        final userId = profile.athlete.id;
        final result = await getSupplements(userId);
        result.fold(
          (failure) => emit(
            state.copyWith(
              status: NutritionSupplementStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (data) => emit(
            state.copyWith(
              status: NutritionSupplementStatus.success,
              data: data,
            ),
          ),
        );
      },
    );
  }
}
