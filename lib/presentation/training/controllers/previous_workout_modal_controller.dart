import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:get/get.dart';

class PreviousWorkoutModalController extends GetxController {
  final String planTitle;
  final GetTrainingHistoryUseCase _getHistoryUseCase = sl<GetTrainingHistoryUseCase>();

  PreviousWorkoutModalController({required this.planTitle});

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<TrainingHistoryEntity> workouts = <TrainingHistoryEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlanHistory();
  }

  Future<void> fetchPlanHistory() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getHistoryUseCase.call();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (response) {
        // Filter history by current plan title
        final matchingWorkouts = response.history
            .where((h) => h.trainingName == planTitle)
            .toList();

        if (matchingWorkouts.isNotEmpty) {
          matchingWorkouts.sort((a, b) => b.dateTime.compareTo(a.dateTime));
          workouts.assignAll(matchingWorkouts);
        } else {
          workouts.clear();
        }
        isLoading.value = false;
      },
    );
  }
}
