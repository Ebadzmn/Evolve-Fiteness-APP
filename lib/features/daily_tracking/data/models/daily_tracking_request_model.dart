import '../../../../domain/entities/daily_entities/daily_tracking_entity.dart';

class DailyTrackingRequestModel {
  final DailyTrackingEntity entity;

  DailyTrackingRequestModel(this.entity);

  Map<String, dynamic> toJson() {
    // Helper to parse double or int from string like "65.2 (kg)" or "120"
    String cleanNum(String text) {
      final regExp = RegExp(r'[\d\.]+');
      final match = regExp.firstMatch(text);
      return match?.group(0) ?? '0';
    }

    // Helper for date formatting from 2023.08.15 -> 2023-08-15
    String formatDate(String dateLabel) {
      return dateLabel.replaceAll('.', '-');
    }

    final Map<String, dynamic> data = {
      "date": formatDate(entity.vital.dateLabel),
      "weight": double.tryParse(cleanNum(entity.vital.weightText)) ?? 0,
      "sleepHour": entity.sleep.durationText.isEmpty
          ? "0"
          : entity.sleep.durationText,
      "sleepQuality": entity.sleep.quality.toString(),
      "water": entity.vital.waterText.isEmpty ? "0" : entity.vital.waterText,

      "bloodPressure": {
        "systolic": cleanNum(entity.pedHealth.systolicText),
        "diastolic": cleanNum(entity.pedHealth.diastolicText),
        "restingHeartRate": cleanNum(entity.pedHealth.restingHrText),
        "bloodGlucose": cleanNum(entity.pedHealth.glucoseText),
      },

      "energyAndWellBeing": {
        "energyLevel": entity.wellBeing.energy,
        "stressLevel": entity.wellBeing.stress,
        "muscelLevel": entity.wellBeing.muscleSoreness,
        "mood": entity.wellBeing.mood,
        "motivation": entity.wellBeing.motivation,
        "bodyTemperature": cleanNum(entity.vital.bodyTempText),
      },

      "training": {
        "trainingCompleted": entity.training.trainingCompleted,
        "trainingPlan": entity.training.plans
            .where((p) => p != 'PLACE_HOLDER')
            .toList(),
        "cardioCompleted": entity.training.cardioCompleted,
        "cardioType":
            (entity.training.cardioType == 'No' ||
                entity.training.cardioType.isEmpty)
            ? ""
            : entity.training.cardioType.toUpperCase().replaceAll(' ', '_'),
        "duration":
            (!entity.training.cardioCompleted ||
                entity.training.duration == "0" ||
                entity.training.duration.isEmpty)
            ? ""
            : entity.training.duration,
      },

      "activityStep":
          int.tryParse(cleanNum(entity.vital.activityStepCount)) ?? 0,

      "nutrition": {
        "calories":
            double.tryParse(cleanNum(entity.nutrition.caloriesText)) ?? 0,
        "carbs": double.tryParse(cleanNum(entity.nutrition.carbsText)) ?? 0,
        "protein": double.tryParse(cleanNum(entity.nutrition.proteinText)) ?? 0,
        "fats": double.tryParse(cleanNum(entity.nutrition.fatsText)) ?? 0,
        "hungerLevel": entity.nutrition.hunger,
        "digestionLevel": entity.nutrition.digestion,
        "salt": double.tryParse(cleanNum(entity.nutrition.saltText)) ?? 0,
      },

      "woman": {
        "cyclePhase": entity.women.cyclePhase ?? "",
        "cycleDay":
            (entity.women.cycleDayLabel == "No" ||
                entity.women.cycleDayLabel.isEmpty)
            ? ""
            : entity.women.cycleDayLabel,
        "pmsSymptoms": entity.women.pms,
        "cramps": entity.women.cramps,
        "symptoms": entity.women.symptoms.toList(),
      },

      "ped": {
        "dailyDosage": entity.pedHealth.dosageTaken ? "Taken" : "",
        "sideEffect":
            (entity.pedHealth.sideEffects == "No" ||
                entity.pedHealth.sideEffects.isEmpty)
            ? ""
            : entity.pedHealth.sideEffects,
      },

      "dailyNotes": (entity.notes == "No" || entity.notes.isEmpty)
          ? ""
          : entity.notes,
    };

    if (entity.isSick != null) {
      data["sick"] = entity.isSick;
    }

    return data;
  }
}
