import 'package:bloc/bloc.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'training_plan_detail_state.dart';

class TrainingPlanDetailCubit extends Cubit<TrainingPlanDetailState> {
  final GetTrainingPlanByIdUseCase getTrainingPlanById;

  TrainingPlanDetailCubit({required this.getTrainingPlanById})
    : super(TrainingPlanDetailInitial());

  Future<void> loadTrainingPlanDetail(
    String id, {
    TrainingPlanEntity? initialPlan,
  }) async {
    // If we have an initial plan (from previous screen), emit it first as loaded or loading?
    // User wants to hit API when clicking card. So maybe show loading immediately.
    // However, if we want to show cached data first, we could.
    // Given the request "click card -> hit api", showing loading or updating is better.
    emit(TrainingPlanDetailLoading());

    final result = await getTrainingPlanById(id);
    result.fold(
      (failure) => emit(TrainingPlanDetailError(failure.message)),
      (plan) => emit(TrainingPlanDetailLoaded(plan)),
    );
  }
}
