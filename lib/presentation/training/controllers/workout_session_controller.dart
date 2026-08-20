import 'dart:async';
import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';
import 'package:fitness_app/features/training/domain/repositories/exercise_repository.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/save_training_history_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/features/training/presentation/bloc/timer_bloc.dart';

class WorkoutSessionController extends GetxController {
  final GetTrainingPlanByIdUseCase getTrainingPlanById;
  final GetTrainingHistoryUseCase getTrainingHistory;
  final SaveTrainingHistoryUseCase _saveTrainingHistory;
  final GetProfileUseCase getProfile;
  final ExerciseRepository exerciseRepository;
  final SharedPreferences sharedPreferences;

  WorkoutSessionController({
    required this.getTrainingPlanById,
    required this.getTrainingHistory,
    required SaveTrainingHistoryUseCase saveTrainingHistory,
    required this.getProfile,
    required this.exerciseRepository,
    required this.sharedPreferences,
  }) : _saveTrainingHistory = saveTrainingHistory;

  // UI State
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<TrainingPlanEntity> plan = Rxn<TrainingPlanEntity>();
  final RxList<TrainingPlanExerciseEntity> sessionExercises =
      <TrainingPlanExerciseEntity>[].obs;
  final RxBool isChangingExercise = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isSaved = false.obs;

  // Form State
  final Map<int, List<Map<String, TextEditingController>>> exerciseControllers =
      {};
  final Map<int, TextEditingController> exerciseNoteControllers = {};
  final Map<int, List<Map<String, RxBool>>> fieldErrors = {};
  final RxMap<int, bool> completedExercises = <int, bool>{}.obs;
  final TextEditingController noteController = TextEditingController();

  // Timer State
  final RxInt duration = 0.obs;
  final RxBool isTimerRunning = false.obs;
  // Timer is now managed by Background Service & TimerBloc

  String? _planKey;
  bool _hasLoadedFromPrefs = false;
  bool _hasLoadedHistoryPrefill = false;

  @override
  void onInit() {
    super.onInit();
    noteController.addListener(_onNoteChanged);
  }

  @override
  void onClose() {
    noteController.removeListener(_onNoteChanged);
    noteController.dispose();
    _disposeControllers();
    super.onClose();
  }

  void _disposeControllers() {
    for (final list in exerciseControllers.values) {
      for (final controllers in list) {
        for (final c in controllers.values) {
          c.dispose();
        }
      }
    }
    for (final controller in exerciseNoteControllers.values) {
      controller.dispose();
    }
    exerciseControllers.clear();
    exerciseNoteControllers.clear();
    fieldErrors.clear();
  }

  Future<void> loadWorkoutSession(String planId) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getTrainingPlanById(planId);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (loadedPlan) {
        plan.value = loadedPlan;
        _planKey = loadedPlan.id.toString();

        if (sessionExercises.isEmpty) {
          sessionExercises.assignAll(loadedPlan.exercises);
        }

        _initializeControllers(sessionExercises);

        if (!_hasLoadedFromPrefs) {
          _hasLoadedFromPrefs = true;
          _loadSavedControllers(sessionExercises);
        }

        if (!_hasLoadedHistoryPrefill) {
          _hasLoadedHistoryPrefill = true;
          _prefillFromHistory(loadedPlan.title, sessionExercises);
        }

        isLoading.value = false;
      },
    );
  }

  void _initializeControllers(List<TrainingPlanExerciseEntity> exercises) {
    for (int i = 0; i < exercises.length; i++) {
      final exerciseIndex = i;
      final exercise = exercises[i];
      final setsDetail = (exercise.exerciseSets as List?) ?? const [];
      final setsCount = setsDetail.isNotEmpty ? setsDetail.length : 1;

      final existing = exerciseControllers[i];
      if (existing != null && existing.length == setsCount) {
        continue;
      }

      final oldList = exerciseControllers[i];
      if (oldList != null) {
        for (final map in oldList) {
          for (final c in map.values) {
            c.dispose();
          }
        }
      }

      exerciseControllers[i] = List.generate(setsCount, (setIndex) {
        final controllers = {
          'weight': TextEditingController(),
          'reps': TextEditingController(),
          'rir': TextEditingController(),
        };
        _attachControllerListeners(i, setIndex, controllers);
        return controllers;
      });

      exerciseNoteControllers.putIfAbsent(exerciseIndex, () {
        // Load globally saved note for this exercise
        final exerciseName = exercise.name;
        final globalKey = 'global_note_$exerciseName';
        final savedGlobalNote = sharedPreferences.getString(globalKey);

        final initialText =
            (savedGlobalNote != null && savedGlobalNote.isNotEmpty)
            ? savedGlobalNote
            : (exercise.comment ?? '');

        final controller = TextEditingController(text: initialText);
        controller.addListener(
          () => _saveExerciseNote(exerciseIndex, controller.text),
        );
        return controller;
      });

      fieldErrors[i] = List.generate(setsCount, (_) {
        return {'weight': false.obs, 'reps': false.obs, 'rir': false.obs};
      });
    }
  }

  void _attachControllerListeners(
    int exerciseIndex,
    int setIndex,
    Map<String, TextEditingController> controllers,
  ) {
    controllers['weight']?.addListener(() {
      _saveField(
        exerciseIndex,
        setIndex,
        'weight',
        controllers['weight']?.text ?? '',
      );
    });
    controllers['reps']?.addListener(() {
      _saveField(
        exerciseIndex,
        setIndex,
        'reps',
        controllers['reps']?.text ?? '',
      );
    });
    controllers['rir']?.addListener(() {
      _saveField(
        exerciseIndex,
        setIndex,
        'rir',
        controllers['rir']?.text ?? '',
      );
    });
  }

  // Persistent State Logic
  String _buildFieldKey(int exerciseIndex, int setIndex, String field) {
    return 'workout_${_planKey}_ex${exerciseIndex}_set${setIndex}_$field';
  }

  String _buildNoteKey() {
    return 'workout_${_planKey}_note';
  }

  String _buildExerciseNoteKey(int exerciseIndex) {
    return 'workout_${_planKey}_ex${exerciseIndex}_note';
  }

  String _buildCompletionKey(int exerciseIndex) {
    return 'workout_${_planKey}_ex${exerciseIndex}_completed';
  }

  String _buildLastValueKey(String exerciseName, int setIndex, String field) {
    return 'last_val_${_planKey}_${exerciseName}_set${setIndex}_$field';
  }

  Future<void> _saveField(
    int exerciseIndex,
    int setIndex,
    String field,
    String value,
  ) async {
    if (_planKey == null) return;

    // Save current session data
    final sessionKey = _buildFieldKey(exerciseIndex, setIndex, field);
    await sharedPreferences.setString(sessionKey, value);

    // Save permanent "last value" data
    if (value.isNotEmpty) {
      final exerciseName = sessionExercises[exerciseIndex].name;
      final lastKey = _buildLastValueKey(exerciseName, setIndex, field);
      await sharedPreferences.setString(lastKey, value);
    }
  }

  String getLastValue(String exerciseName, int setIndex, String field) {
    if (_planKey == null) return '';
    final key = _buildLastValueKey(exerciseName, setIndex, field);
    return sharedPreferences.getString(key) ?? '';
  }

  Future<void> _saveNote(String value) async {
    if (_planKey == null) return;
    final key = _buildNoteKey();
    await sharedPreferences.setString(key, value);
  }

  Future<void> _saveExerciseNote(int exerciseIndex, String value) async {
    if (_planKey == null || sessionExercises.isEmpty) return;

    // Save draft for this session
    final key = _buildExerciseNoteKey(exerciseIndex);
    await sharedPreferences.setString(key, value);

    // Save locally across all sessions for this specific exercise
    if (exerciseIndex < sessionExercises.length) {
      final exerciseName = sessionExercises[exerciseIndex].name;
      final globalKey = 'global_note_$exerciseName';
      await sharedPreferences.setString(globalKey, value);
    }
  }

  void _onNoteChanged() {
    _saveNote(noteController.text);
  }

  Future<void> toggleExerciseCompletion(int index) async {
    final currentValue = completedExercises[index] ?? false;
    final newValue = !currentValue;
    completedExercises[index] = newValue;
    await _saveCompletion(index, newValue);
  }

  Future<void> _saveCompletion(int index, bool value) async {
    if (_planKey == null) return;
    final key = _buildCompletionKey(index);
    await sharedPreferences.setBool(key, value);

    // Save completion date (YYYY-MM-DD)
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await sharedPreferences.setString(
      'workout_${_planKey}_last_checked_date',
      todayStr,
    );
  }

  Future<void> _loadSavedControllers(
    List<TrainingPlanExerciseEntity> exercises,
  ) async {
    if (_planKey == null) return;

    // Check if the date has changed since the last saved completions
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final savedDate = sharedPreferences.getString(
      'workout_${_planKey}_last_checked_date',
    );

    if (savedDate != null && savedDate != todayStr) {
      // Different day! Clear the completed exercises from shared preferences
      for (int i = 0; i < exercises.length; i++) {
        final key = _buildCompletionKey(i);
        await sharedPreferences.remove(key);
      }
      await sharedPreferences.remove('workout_${_planKey}_last_checked_date');
      completedExercises.clear();
    } else {
      // Same day or first check, load completion status
      for (int i = 0; i < exercises.length; i++) {
        final key = _buildCompletionKey(i);
        final value = sharedPreferences.getBool(key);
        if (value != null) {
          completedExercises[i] = value;
        }
      }
    }

    for (int i = 0; i < exercises.length; i++) {
      final controllersList = exerciseControllers[i];
      if (controllersList == null) continue;

      for (int setIndex = 0; setIndex < controllersList.length; setIndex++) {
        final map = controllersList[setIndex];

        for (final field in ['weight', 'reps', 'rir']) {
          final key = _buildFieldKey(i, setIndex, field);
          final value = sharedPreferences.getString(key);
          if (value != null && value.isNotEmpty) {
            final controller = map[field];
            if (controller != null && controller.text != value) {
              controller.text = value;
            }
          }
        }
      }
    }

    final noteKey = _buildNoteKey();
    final noteValue = sharedPreferences.getString(noteKey);
    if (noteValue != null && noteValue.isNotEmpty) {
      if (noteController.text != noteValue) {
        noteController.text = noteValue;
      }
    }

    for (int i = 0; i < exercises.length; i++) {
      final controller = exerciseNoteControllers[i];
      if (controller == null) continue;

      final key = _buildExerciseNoteKey(i);
      final value = sharedPreferences.getString(key);
      if (value != null && controller.text != value) {
        controller.text = value;
      }
    }
  }

  Future<void> _prefillFromHistory(
    String planTitle,
    List<TrainingPlanExerciseEntity> exercises,
  ) async {
    if (_planKey == null || exercises.isEmpty) return;

    final result = await getTrainingHistory();
    result.fold(
      (failure) {
        debugPrint('Workout history prefill failed: ${failure.message}');
      },
      (response) {
        final matchingWorkouts = response.history
            .where((history) => history.trainingName == planTitle)
            .toList();

        if (matchingWorkouts.isEmpty) return;

        matchingWorkouts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

        final latestWorkout = matchingWorkouts.first;
        final byExercise = <String, List<PushDataEntity>>{};

        for (final item in latestWorkout.pushData) {
          byExercise.putIfAbsent(item.exerciseName, () => []).add(item);
        }

        for (int i = 0; i < exercises.length; i++) {
          final exercise = exercises[i];
          final controller = exerciseControllers[i];
          if (controller == null) continue;

          final historySets = byExercise[exercise.name];
          if (historySets == null || historySets.isEmpty) continue;

          historySets.sort((a, b) => a.sets.compareTo(b.sets));

          final noteCtrl = exerciseNoteControllers[i];
          if (noteCtrl != null && noteCtrl.text.isEmpty) {
            final historyNote = historySets.first.exerciseNotes;
            if (historyNote != null && historyNote.isNotEmpty) {
              noteCtrl.text = historyNote;
            }
          }

          for (int sIndex = 0; sIndex < controller.length; sIndex++) {
            final map = controller[sIndex];
            final historySet = historySets.length > sIndex
                ? historySets[sIndex]
                : historySets.last;

            if ((map['weight']?.text ?? '').isEmpty) {
              map['weight']?.text = historySet.weight.toString();
            }
            if ((map['reps']?.text ?? '').isEmpty) {
              map['reps']?.text = historySet.repRange;
            }
            if ((map['rir']?.text ?? '').isEmpty) {
              map['rir']?.text = historySet.rir;
            }
          }
        }
      },
    );
  }

  Future<void> _clearSavedControllers() async {
    if (_planKey == null) return;

    for (int i = 0; i < sessionExercises.length; i++) {
      final controllersList = exerciseControllers[i];
      final completionKey = _buildCompletionKey(i);
      await sharedPreferences.remove(completionKey);

      if (controllersList == null) continue;

      for (int setIndex = 0; setIndex < controllersList.length; setIndex++) {
        for (final field in ['weight', 'reps', 'rir']) {
          final key = _buildFieldKey(i, setIndex, field);
          await sharedPreferences.remove(key);
        }
      }
    }

    for (int i = 0; i < sessionExercises.length; i++) {
      final key = _buildExerciseNoteKey(i);
      await sharedPreferences.remove(key);
    }

    final globalNoteKey = _buildNoteKey();
    await sharedPreferences.remove(globalNoteKey);

    await sharedPreferences.remove('workout_${_planKey}_last_checked_date');
    completedExercises.clear();
  }

  // Timer logic moved to TimerBloc & Background Service

  Future<List<ExerciseEntity>> searchExercises({String? searchTerm}) async {
    final trimmed = searchTerm?.trim() ?? '';
    final result = await exerciseRepository.getExercises(
      page: 1,
      limit: 10,
      searchTerm: trimmed.isEmpty ? null : trimmed,
    );

    return result.fold((failure) {
      Get.snackbar(
        'Error',
        failure.message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return <ExerciseEntity>[];
    }, (items) => items);
  }

  // Exercise Picker Logic
  Future<void> changeExercise(
    BuildContext context,
    Future<ExerciseEntity?> Function() showPicker,
  ) async {
    if (isChangingExercise.value) return;

    isChangingExercise.value = true;
    try {
      final selected = await showPicker();
      if (selected == null) return;

      final newExercise = TrainingPlanExerciseEntity(
        name: selected.title,
        sets: '1',
        muscle: selected.category,
        type: selected.equipment,
        range: '',
        rir: '',
        exerciseId: selected.id,
        exerciseSets: const [],
      );

      final next = List<TrainingPlanExerciseEntity>.from(sessionExercises)
        ..add(newExercise);
      sessionExercises.assignAll(next);
      _initializeControllers(next);

      Get.snackbar(
        'Success',
        '${selected.title} added to workout.',
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } finally {
      isChangingExercise.value = false;
    }
  }

  // Exercise Navigation Logic
  Future<void> goToExerciseDetails(
    String? exerciseId,
    BuildContext context,
  ) async {
    if (exerciseId == null || exerciseId.isEmpty) {
      Get.snackbar(
        'Error',
        'Exercise details not available.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50))),
      barrierDismissible: false,
    );

    final result = await exerciseRepository.getExerciseById(exerciseId);

    Get.back(); // close dialog

    result.fold(
      (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      },
      (exercise) {
        context.push(AppRoutes.exerciseDetailPage, extra: exercise);
      },
    );
  }

  // Submission Logic
  bool validateAllFields() {
    bool hasError = false;

    for (int i = 0; i < sessionExercises.length; i++) {
      final controllersList = exerciseControllers[i];
      if (controllersList == null || controllersList.isEmpty) {
        hasError = true;
        continue;
      }

      for (int s = 0; s < controllersList.length; s++) {
        final map = controllersList[s];
        final errorsForSet = fieldErrors[i]![s];

        final weight = map['weight']?.text.trim() ?? '';
        final reps = map['reps']?.text.trim() ?? '';
        final rir = map['rir']?.text.trim() ?? '';

        final weightError = weight.isEmpty;
        final repsError = reps.isEmpty;
        final rirError = rir.isEmpty;

        errorsForSet['weight']?.value = weightError;
        errorsForSet['reps']?.value = repsError;
        errorsForSet['rir']?.value = rirError;

        if (weightError || repsError || rirError) {
          hasError = true;
        }
      }
    }

    if (hasError) {
      Get.snackbar(
        'Incomplete',
        'Please complete all sets before submitting.',
        colorText: Colors.white,
        backgroundColor: Colors.orange,
      );
      return false;
    }

    return true;
  }

  Future<void> onComplete([BuildContext? context]) async {
    if (!validateAllFields()) return;

    isSaving.value = true;
    final timerBloc = context?.read<TimerBloc>();

    final List<PushData> pushData = [];

    for (int i = 0; i < sessionExercises.length; i++) {
      final exercise = sessionExercises[i];
      final setsDetail = (exercise.exerciseSets as List?) ?? const [];
      final controllersList = exerciseControllers[i];

      if (controllersList == null || controllersList.isEmpty) continue;

      if (setsDetail.isEmpty) {
        final controllers = controllersList.first;
        final weight = num.tryParse(controllers['weight']?.text ?? '0') ?? 0;
        final repRange = controllers['reps']?.text ?? '';
        final rir = controllers['rir']?.text ?? '';

        pushData.add(
          PushData(
            weight: weight,
            repRange: repRange,
            rir: rir,
            sets: 1,
            exerciseName: exercise.name,
            exerciseNotes: exerciseNoteControllers[i]?.text.trim(),
          ),
        );
      } else {
        for (int s = 0; s < setsDetail.length; s++) {
          final controllers = controllersList.length > s
              ? controllersList[s]
              : controllersList.last;
          final setModel = setsDetail[s];
          final weight = num.tryParse(controllers['weight']?.text ?? '0') ?? 0;
          final userRep = controllers['reps']?.text ?? '';
          final userRir = controllers['rir']?.text ?? '';
          final repRange = userRep.isNotEmpty
              ? userRep
              : (setModel.repRange?.toString() ?? '');
          final rir = userRir.isNotEmpty
              ? userRir
              : (setModel.rir?.toString() ?? '');
          final setNumber =
              int.tryParse(setModel.sets?.toString() ?? '') ?? (s + 1);

          pushData.add(
            PushData(
              weight: weight,
              repRange: repRange,
              rir: rir,
              sets: setNumber,
              exerciseName: exercise.name,
              exerciseNotes: exerciseNoteControllers[i]?.text.trim(),
            ),
          );
        }
      }
    }

    final currentDuration = duration.value;
    timerBloc?.add(PauseTimer());
    final hours = (currentDuration ~/ 3600).toString();
    final minutes = ((currentDuration % 3600) ~/ 60).toString();

    // Get UserID
    final profileResult = await getProfile();
    String? userId;
    profileResult.fold(
      (failure) {
        errorMessage.value = 'Failed to get user profile: ${failure.message}';
        isSaving.value = false;
      },
      (profile) {
        userId = profile.athlete.id;
      },
    );

    if (userId == null) return;

    final request = TrainingHistoryRequest(
      userId: userId!,
      trainingName: plan.value?.title ?? '',
      time: TrainingTime(hour: hours, minite: minutes),
      pushData: pushData,
      note: noteController.text,
      dateTime: DateTime.now(), // Captured at the moment of submission
    );

    final result = await _saveTrainingHistory(request);
    result.fold(
      (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        isSaving.value = false;
      },
      (_) async {
        await _clearSavedControllers();
        timerBloc?.add(ResetTimer());
        isSaved.value = true;
        isSaving.value = false;
        Get.back();
        Get.snackbar(
          'Success',
          'Workout saved successfully!',
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      },
    );
  }
}
