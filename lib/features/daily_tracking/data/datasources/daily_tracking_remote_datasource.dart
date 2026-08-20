import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/daily_tracking_request_model.dart';
import '../../../../domain/entities/daily_entities/daily_tracking_entity.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/daily_entities/nutrition_entity.dart';
import '../../../../domain/entities/daily_entities/ped_health_entity.dart';
import '../../../../domain/entities/daily_entities/sleep_entity.dart';
import '../../../../domain/entities/daily_entities/training_entity.dart';
import '../../../../domain/entities/daily_entities/vital_entity.dart';
import '../../../../domain/entities/daily_entities/well_being_entity.dart';
import '../../../../domain/entities/daily_entities/women_entity.dart';

abstract class DailyTrackingRemoteDataSource {
  Future<void> submitDailyTracking(DailyTrackingEntity entity);
  Future<void> updateDailyTracking(DailyTrackingEntity entity, String date);
  Future<DailyTrackingEntity> fetchDailyTrackingByDate(String date);
}

class DailyTrackingRemoteDataSourceImpl
    implements DailyTrackingRemoteDataSource {
  final ApiClient apiClient;

  DailyTrackingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> submitDailyTracking(DailyTrackingEntity entity) async {
    final model = DailyTrackingRequestModel(entity);
    await apiClient.post(ApiUrls.dailyTrackingPost, data: model.toJson());
  }

  @override
  Future<void> updateDailyTracking(
    DailyTrackingEntity entity,
    String date,
  ) async {
    final model = DailyTrackingRequestModel(entity);
    await apiClient.put(
      ApiUrls.dailyTrackingPut,
      queryParameters: {'date': date},
      data: model.toJson(),
    );
  }

  @override
  Future<DailyTrackingEntity> fetchDailyTrackingByDate(String date) async {
    final response = await apiClient.get(
      ApiUrls.dailyTrackingByDate,
      queryParameters: {'date': date},
    );

    final raw = response.data;
    Map<String, dynamic>? payload;
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is Map<String, dynamic>) {
        payload = data;
      } else {
        payload = raw;
      }
    }

    if (payload == null) {
      throw ApiException(message: 'Invalid daily tracking response');
    }

    String dateLabelFromApi(Object? v) {
      final s = v?.toString().trim();
      if (s == null || s.isEmpty) return '';
      if (s.contains('-')) return s.replaceAll('-', '.');
      return s;
    }

    String str(Object? v) {
      final s = (v ?? '').toString().trim();
      if (s == '0' || s == '0.0' || s == 'No') return '';
      return s;
    }

    double dbl(Object? v, {double fallback = 0}) {
      if (v is num) return v.toDouble();
      return double.tryParse(v?.toString() ?? '') ?? fallback;
    }

    double scale1to10(Object? v, {double fallback = 1}) {
      return dbl(v, fallback: fallback).clamp(1.0, 10.0).toDouble();
    }

    bool? boolVal(Object? v) {
      if (v == null) return null;
      if (v is bool) return v;
      final s = v.toString().toLowerCase();
      if (s.isEmpty) return null;
      return s == 'true' || s == '1' || s == 'yes';
    }

    Set<String> setOfStrings(Object? v) {
      if (v is List) return v.map((e) => e.toString()).toSet();
      if (v is Set) return v.map((e) => e.toString()).toSet();
      return <String>{};
    }

    final dateLabel = dateLabelFromApi(payload['date']);
    final bloodPressure = payload['bloodPressure'];
    final energy = payload['energyAndWellBeing'];
    final training = payload['training'];
    final nutrition = payload['nutrition'];
    final woman = payload['woman'];
    final ped = payload['ped'];

    final cyclePhaseRaw = woman is Map<String, dynamic>
        ? woman['cyclePhase']
        : null;
    final cyclePhaseText = str(cyclePhaseRaw).trim();

    return DailyTrackingEntity(
      vital: VitalEntity(
        dateLabel: dateLabel,
        weightText: str(payload['weight']),
        waterText: str(payload['water']),
        bodyTempText: str(
          energy is Map<String, dynamic> ? energy['bodyTemperature'] : '',
        ),
        activityStepCount: str(payload['activityStep']),
      ),
      isSick: boolVal(payload['sick']),
      wellBeing: WellBeingEntity(
        energy: scale1to10(
          energy is Map<String, dynamic> ? energy['energyLevel'] : null,
        ),
        stress: scale1to10(
          energy is Map<String, dynamic> ? energy['stressLevel'] : null,
        ),
        muscleSoreness: scale1to10(
          energy is Map<String, dynamic> ? energy['muscelLevel'] : null,
        ),
        mood: scale1to10(
          energy is Map<String, dynamic> ? energy['mood'] : null,
        ),
        motivation: scale1to10(
          energy is Map<String, dynamic> ? energy['motivation'] : null,
        ),
      ),
      sleep: SleepEntity(
        durationText: str(payload['sleepHour']),
        quality: scale1to10(payload['sleepQuality']),
      ),
      training: TrainingEntity(
        trainingCompleted:
            boolVal(
              training is Map<String, dynamic>
                  ? training['trainingCompleted']
                  : '',
            ) ??
            false,
        cardioCompleted:
            boolVal(
              training is Map<String, dynamic>
                  ? training['cardioCompleted']
                  : '',
            ) ??
            false,
        feedback: str(payload['trainingFeedback']),
        plans: setOfStrings(
          training is Map<String, dynamic> ? training['trainingPlan'] : null,
        ),
        cardioType: str(
          training is Map<String, dynamic> ? training['cardioType'] : '',
        ),
        duration: str(
          training is Map<String, dynamic> ? training['duration'] : '',
        ),
        intensity: scale1to10(
          training is Map<String, dynamic> ? training['intensity'] : null,
        ),
      ),
      nutrition: NutritionEntity(
        dietLevel: dbl(
          nutrition is Map<String, dynamic> ? nutrition['dietLevel'] : null,
          fallback: 1,
        ),
        digestion: dbl(
          nutrition is Map<String, dynamic>
              ? nutrition['digestionLevel']
              : null,
          fallback: 1,
        ),
        hunger: dbl(
          nutrition is Map<String, dynamic> ? nutrition['hungerLevel'] : null,
          fallback: 1,
        ),
        caloriesText: str(
          nutrition is Map<String, dynamic> ? nutrition['calories'] : '',
        ),
        carbsText: str(
          nutrition is Map<String, dynamic> ? nutrition['carbs'] : '',
        ),
        proteinText: str(
          nutrition is Map<String, dynamic> ? nutrition['protein'] : '',
        ),
        fatsText: str(
          nutrition is Map<String, dynamic> ? nutrition['fats'] : '',
        ),
        saltText: str(
          nutrition is Map<String, dynamic> ? nutrition['salt'] : '',
        ),
        challenge: str(
          nutrition is Map<String, dynamic> ? nutrition['challengeDiet'] : '',
        ),
      ),
      women: WomenEntity(
        cyclePhase: cyclePhaseText.isEmpty ? null : cyclePhaseText,
        cycleDayLabel: str(
          woman is Map<String, dynamic> ? woman['cycleDay'] : '',
        ),
        pms: scale1to10(
          woman is Map<String, dynamic> ? woman['pmsSymptoms'] : null,
        ),
        cramps: scale1to10(
          woman is Map<String, dynamic> ? woman['cramps'] : null,
        ),
        symptoms: setOfStrings(
          woman is Map<String, dynamic> ? woman['symptoms'] : null,
        ),
      ),
      pedHealth: PedHealthEntity(
        dosageTaken: str(
          ped is Map<String, dynamic> ? ped['dailyDosage'] : '',
        ).toLowerCase().contains('taken'),
        sideEffects: str(ped is Map<String, dynamic> ? ped['sideEffect'] : ''),
        systolicText: str(
          bloodPressure is Map<String, dynamic>
              ? bloodPressure['systolic']
              : '',
        ),
        diastolicText: str(
          bloodPressure is Map<String, dynamic>
              ? bloodPressure['diastolic']
              : '',
        ),
        restingHrText: str(
          bloodPressure is Map<String, dynamic>
              ? bloodPressure['restingHeartRate']
              : '',
        ),
        glucoseText: str(
          bloodPressure is Map<String, dynamic>
              ? bloodPressure['bloodGlucose']
              : '',
        ),
      ),
      notes: str(payload['dailyNotes']),
    );
  }
}
