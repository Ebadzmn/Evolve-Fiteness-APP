import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/domain/entities/daily_entities/daily_tracking_entity.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/usecases/daily/get_daily_initial_usecase.dart';
import 'package:fitness_app/domain/usecases/daily/get_daily_by_date_usecase.dart';
import 'package:fitness_app/domain/usecases/daily/save_daily_usecase.dart';
import 'package:fitness_app/domain/usecases/daily/update_daily_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plans_usecase.dart';
import 'package:fitness_app/usecase/usecase.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import '../../../../../../domain/entities/daily_entities/nutrition_entity.dart';
import '../../../../../../domain/entities/daily_entities/vital_entity.dart';
import '../../../../../../domain/entities/daily_entities/ped_health_entity.dart';

enum DailyStatus { initial, loading, success, saving, saved, error }

class DailyTrackingController extends GetxController {
  final GetDailyInitialUseCase getInitial;
  final GetDailyByDateUseCase getByDate;
  final SaveDailyUseCase saveDaily;
  final UpdateDailyUseCase updateDaily;
  final SharedPreferences sharedPreferences;
  final GetTrainingPlansUseCase getTrainingPlans;

  DailyTrackingController({
    required this.getInitial,
    required this.getByDate,
    required this.saveDaily,
    required this.updateDaily,
    required this.sharedPreferences,
    required this.getTrainingPlans,
  });

  var status = DailyStatus.initial.obs;
  var data = Rxn<DailyTrackingEntity>();
  var errorMessage = RxnString();
  var isReadOnly = false.obs;
  var isUpdate = false.obs;
  var trainingPlans = <TrainingPlanEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    initDailyTracking();

    ever(status, (DailyStatus s) {
      if (s == DailyStatus.error) {
        Get.snackbar(
          'Error',
          errorMessage.value ?? 'An error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (s == DailyStatus.saved) {
        Get.snackbar(
          'Success',
          'Daily tracking saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    });
  }

  Future<void> initDailyTracking() async {
    status.value = DailyStatus.loading;
    try {
      final plansResult = await getTrainingPlans();
      plansResult.fold((_) {}, (list) => trainingPlans.value = list);

      // Fetch today's data instead of just loading a blank template
      await onDateChanged(DateTime.now());
    } catch (e) {
      status.value = DailyStatus.error;
      errorMessage.value = e.toString();
    }
  }

  Future<void> onDateChanged(DateTime date) async {
    status.value = DailyStatus.loading;
    try {
      final result = await getByDate(date);
      final rawLabel = result.vital.dateLabel.trim();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDay = DateTime(date.year, date.month, date.day);
      final isFuture = selectedDay.isAfter(today);

      if (rawLabel.isEmpty || isFuture) {
        try {
          final initial = await getInitial(NoParams());
          final y = date.year;
          final m = date.month.toString().padLeft(2, '0');
          final d = date.day.toString().padLeft(2, '0');
          final label = '$y.$m.$d';
          data.value = initial.copyWith(
            vital: initial.vital.copyWith(dateLabel: label),
          );
          isReadOnly.value = false;
          isUpdate.value = false;
          status.value = DailyStatus.success;
          return;
        } catch (_) {}
      }

      data.value = result;
      isReadOnly.value = false;
      isUpdate.value = true;
      status.value = DailyStatus.success;
    } catch (e) {
      if (e is ApiException) {
        final msg = e.message.toLowerCase();
        final isNotFound =
            (e.statusCode == 404) ||
            msg.contains('no daily tracking') ||
            msg.contains('not found') ||
            msg.contains('invalid daily tracking response');
        if (isNotFound) {
          try {
            final initial = await getInitial(NoParams());
            final y = date.year;
            final m = date.month.toString().padLeft(2, '0');
            final d = date.day.toString().padLeft(2, '0');
            final label = '$y.$m.$d';
            data.value = initial.copyWith(
              vital: initial.vital.copyWith(dateLabel: label),
            );
            isReadOnly.value = false;
            isUpdate.value = false;
            status.value = DailyStatus.success;
            return;
          } catch (_) {}
        }
      }
      status.value = DailyStatus.error;
      errorMessage.value = e.toString();
    }
  }

  void onWellBeingChanged(String field, double value) {
    if (data.value == null) return;
    final wb = data.value!.wellBeing;
    var updated = wb;
    switch (field) {
      case 'energy':
        updated = wb.copyWith(energy: value);
        break;
      case 'stress':
        updated = wb.copyWith(stress: value);
        break;
      case 'muscleSoreness':
        updated = wb.copyWith(muscleSoreness: value);
        break;
      case 'mood':
        updated = wb.copyWith(mood: value);
        break;
      case 'motivation':
        updated = wb.copyWith(motivation: value);
        break;
    }
    data.value = data.value!.copyWith(wellBeing: updated);
  }

  void onTrainingToggleChanged(String field, bool value) {
    if (data.value == null) return;
    final t = data.value!.training;
    final updated = field == 'trainingCompleted'
        ? t.copyWith(trainingCompleted: value)
        : t.copyWith(cardioCompleted: value);
    data.value = data.value!.copyWith(training: updated);
  }

  void onTrainingFeedbackChanged(String feedback) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      training: data.value!.training.copyWith(feedback: feedback),
    );
  }

  void onDailyNotesChanged(String notes) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(notes: notes);
  }

  void onNutritionChanged(
    String field, {
    double? numberValue,
    String? textValue,
  }) {
    if (data.value == null) return;
    final n = data.value!.nutrition;
    NutritionEntity updated = n;
    switch (field) {
      case 'dietLevel':
        updated = n.copyWith(dietLevel: numberValue ?? n.dietLevel);
        break;
      case 'digestion':
        updated = n.copyWith(digestion: numberValue ?? n.digestion);
        break;
      case 'hunger':
        updated = n.copyWith(hunger: numberValue ?? n.hunger);
        break;
      case 'challenge':
        updated = n.copyWith(challenge: textValue ?? n.challenge);
        break;
    }
    data.value = data.value!.copyWith(nutrition: updated);
  }

  Future<void> onSavePressed() async {
    if (data.value == null) return;
    status.value = DailyStatus.saving;
    try {
      if (isUpdate.value) {
        final parts = data.value!.vital.dateLabel.split('.');
        final y = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final d = int.parse(parts[2]);
        await updateDaily(
          UpdateDailyParams(entity: data.value!, date: DateTime(y, m, d)),
        );
      } else {
        await saveDaily(data.value!);
        isUpdate.value = true;
      }
      if (data.value!.vital.weightText.isNotEmpty) {
        await sharedPreferences.setString(
          'cached_weight',
          data.value!.vital.weightText,
        );
      }
      status.value = DailyStatus.saved;
    } catch (e) {
      status.value = DailyStatus.error;
      errorMessage.value = 'Failed';
    }
  }

  void onVitalTextChanged(String field, String value) {
    if (data.value == null) return;
    final v = data.value!.vital;
    VitalEntity updated = v;
    switch (field) {
      case 'weightText':
        updated = v.copyWith(weightText: value);
        break;
      case 'waterText':
        updated = v.copyWith(waterText: value);
        break;
      case 'bodyTempText':
        updated = v.copyWith(bodyTempText: value);
        break;
      case 'activityStepCount':
        updated = v.copyWith(activityStepCount: value);
        break;
    }
    data.value = data.value!.copyWith(vital: updated);
  }

  void onSickChanged(bool isSick) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(isSick: isSick);
  }

  void onSleepDurationChanged(String durationText) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      sleep: data.value!.sleep.copyWith(durationText: durationText),
    );
  }

  void onSleepQualityChanged(double quality) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      sleep: data.value!.sleep.copyWith(quality: quality),
    );
  }

  void onTrainingPlanToggled(String plan, bool selected) {
    if (data.value == null) return;

    final currentPlans = Set<String>.from(data.value!.training.plans);
    if (selected) {
      currentPlans.add(plan);
    } else {
      currentPlans.remove(plan);
    }

    data.value = data.value!.copyWith(
      training: data.value!.training.copyWith(plans: currentPlans),
    );
  }

  void onTrainingCardioTypeChanged(String type) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      training: data.value!.training.copyWith(cardioType: type),
    );
  }

  void onTrainingDurationChanged(String duration) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      training: data.value!.training.copyWith(duration: duration),
    );
  }

  void onTrainingIntensityChanged(double intensity) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      training: data.value!.training.copyWith(intensity: intensity),
    );
  }

  void onNutritionTextChanged(String field, String value) {
    if (data.value == null) return;
    final n = data.value!.nutrition;
    NutritionEntity updated = n;
    switch (field) {
      case 'caloriesText':
        updated = n.copyWith(caloriesText: value);
        break;
      case 'carbsText':
        updated = n.copyWith(carbsText: value);
        break;
      case 'proteinText':
        updated = n.copyWith(proteinText: value);
        break;
      case 'fatsText':
        updated = n.copyWith(fatsText: value);
        break;
      case 'saltText':
        updated = n.copyWith(saltText: value);
        break;
    }
    data.value = data.value!.copyWith(nutrition: updated);
  }

  void onWomenCyclePhaseChanged(String? phase) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      women: data.value!.women.copyWith(cyclePhase: phase),
    );
  }

  void onWomenCycleDayChanged(String dayLabel) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      women: data.value!.women.copyWith(cycleDayLabel: dayLabel),
    );
  }

  void onWomenPmsChanged(double value) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      women: data.value!.women.copyWith(pms: value),
    );
  }

  void onWomenCrampsChanged(double value) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      women: data.value!.women.copyWith(cramps: value),
    );
  }

  void onWomenSymptomsChanged(Set<String> symptoms) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      women: data.value!.women.copyWith(symptoms: symptoms),
    );
  }

  void onPedDosageChanged(bool taken) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      pedHealth: data.value!.pedHealth.copyWith(dosageTaken: taken),
    );
  }

  void onPedSideEffectsChanged(String text) {
    if (data.value == null) return;
    data.value = data.value!.copyWith(
      pedHealth: data.value!.pedHealth.copyWith(sideEffects: text),
    );
  }

  void onPedBpChanged(String field, String value) {
    if (data.value == null) return;
    final p = data.value!.pedHealth;
    PedHealthEntity updated = p;
    switch (field) {
      case 'systolicText':
        updated = p.copyWith(systolicText: value);
        break;
      case 'diastolicText':
        updated = p.copyWith(diastolicText: value);
        break;
      case 'restingHrText':
        updated = p.copyWith(restingHrText: value);
        break;
      case 'glucoseText':
        updated = p.copyWith(glucoseText: value);
        break;
    }
    data.value = data.value!.copyWith(pedHealth: updated);
  }
}
