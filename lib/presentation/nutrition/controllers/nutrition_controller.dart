import 'package:fitness_app/core/storage/nutrition_storage.dart';
import 'package:fitness_app/core/storage/token_storage.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_dashboard_entity.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:get/get.dart';

class NutritionController extends GetxController {
  final GetProfileUseCase getProfile;
  final GetNutritionPlanUseCase getPlan;
  final GetTrackMealsUseCase getTrackMeals;
  final NutritionStorage nutritionStorage;
  final TokenStorage tokenStorage;

  NutritionController({
    required this.getProfile,
    required this.getPlan,
    required this.getTrackMeals,
    required this.nutritionStorage,
    required this.tokenStorage,
  });

  var isLoading = false.obs;
  var nutritionData = Rxn<NutritionDashboardEntity>();
  var athleteStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
    fetchNutritionData();
  }

  void _loadStoredData() {
    nutritionData.value = NutritionDashboardEntity(
      caloriesConsumed: nutritionStorage.getTrackedCalories().toInt(),
      caloriesGoal: nutritionStorage.getPlanCalories(),
      proteinConsumed: nutritionStorage.getTrackedProtein().toInt(),
      proteinGoal: nutritionStorage.getPlanProtein().toInt(),
      carbsConsumed: nutritionStorage.getTrackedCarbs().toInt(),
      carbsGoal: nutritionStorage.getPlanCarbs().toInt(),
      fatConsumed: nutritionStorage.getTrackedFats().toInt(),
      fatGoal: nutritionStorage.getPlanFats().toInt(),
    );
    athleteStatus.value = tokenStorage.getUserStatus() ?? '';
  }

  Future<void> fetchNutritionData() async {
    isLoading.value = true;
    try {
      final profileResult = await getProfile();
      await profileResult.fold(
        (failure) async {
          isLoading.value = false;
        },
        (profile) async {
          final userId = profile.athlete.id;
          athleteStatus.value = profile.athlete.status;
          
          // Save status to token storage for persistence/other parts of app
          await tokenStorage.saveUserStatus(profile.athlete.status);

          final results = await Future.wait([
            getPlan(userId),
            getTrackMeals(DateTime.now()),
          ]);

          final planResult = results[0] as dynamic;
          final trackMealsResult = results[1] as dynamic;

          int? caloriesGoal;
          int? proteinGoal;
          int? carbsGoal;
          int? fatGoal;

          int? caloriesConsumed;
          int? proteinConsumed;
          int? carbsConsumed;
          int? fatConsumed;

          planResult.fold((failure) {}, (plan) {
            caloriesGoal = plan.totals.totalCalories;
            proteinGoal = plan.totals.totalProtein.toInt();
            carbsGoal = plan.totals.totalCarbs.toInt();
            fatGoal = plan.totals.totalFats.toInt();

            nutritionStorage.savePlanTotals(
              protein: plan.totals.totalProtein,
              fats: plan.totals.totalFats,
              carbs: plan.totals.totalCarbs,
              calories: plan.totals.totalCalories,
            );
          });

          trackMealsResult.fold((failure) {}, (trackingData) {
            caloriesConsumed = trackingData.totals.totalCalories.toInt();
            proteinConsumed = trackingData.totals.totalProtein.toInt();
            carbsConsumed = trackingData.totals.totalCarbs.toInt();
            fatConsumed = trackingData.totals.totalFats.toInt();

            nutritionStorage.saveTrackedTotals(
              protein: trackingData.totals.totalProtein,
              fats: trackingData.totals.totalFats,
              carbs: trackingData.totals.totalCarbs,
              calories: trackingData.totals.totalCalories.toDouble(),
            );
          });

          nutritionData.value = NutritionDashboardEntity(
            caloriesConsumed: caloriesConsumed ?? nutritionData.value!.caloriesConsumed,
            caloriesGoal: caloriesGoal ?? nutritionData.value!.caloriesGoal,
            proteinConsumed: proteinConsumed ?? nutritionData.value!.proteinConsumed,
            proteinGoal: proteinGoal ?? nutritionData.value!.proteinGoal,
            carbsConsumed: carbsConsumed ?? nutritionData.value!.carbsConsumed,
            carbsGoal: carbsGoal ?? nutritionData.value!.carbsGoal,
            fatConsumed: fatConsumed ?? nutritionData.value!.fatConsumed,
            fatGoal: fatGoal ?? nutritionData.value!.fatGoal,
          );
        },
      );
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
