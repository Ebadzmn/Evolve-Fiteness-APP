import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/nutrition_storage.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';
import './get_nutrition_plan_usecase.dart';
import './get_track_meals_usecase.dart';

class SyncNutritionDataUseCase {
  final GetProfileUseCase getProfileUseCase;
  final GetNutritionPlanUseCase getNutritionPlanUseCase;
  final GetTrackMealsUseCase getTrackMealsUseCase;
  final NutritionStorage nutritionStorage;
  final TokenStorage tokenStorage;

  SyncNutritionDataUseCase({
    required this.getProfileUseCase,
    required this.getNutritionPlanUseCase,
    required this.getTrackMealsUseCase,
    required this.nutritionStorage,
    required this.tokenStorage,
  });

  Future<Either<ApiException, void>> call() async {
    try {
      log('SyncNutritionDataUseCase: Starting sync...');

      // 1. Get Profile to get userId
      final profileResult = await getProfileUseCase();
      return await profileResult.fold(
        (failure) {
          log(
            'SyncNutritionDataUseCase: Failed to fetch profile: ${failure.message}',
          );
          return Left(failure);
        },
        (profile) async {
          final userId = profile.athlete.id;
          log('SyncNutritionDataUseCase: Fetched userId: $userId');
          final gender = profile.athlete.gender.trim().toLowerCase();
          if (gender.isNotEmpty) {
            await tokenStorage.saveUserGender(gender);
          }

          final status = profile.athlete.status.trim();
          if (status.isNotEmpty) {
            await tokenStorage.saveUserStatus(status);
          }

          // 2. Fetch Nutrition Plan
          final planResult = await getNutritionPlanUseCase(userId);
          await planResult.fold(
            (failure) {
              log(
                'SyncNutritionDataUseCase: Failed to fetch nutrition plan: ${failure.message}',
              );
            },
            (plan) async {
              log('SyncNutritionDataUseCase: Saving plan totals...');
              await nutritionStorage.savePlanTotals(
                protein: plan.totals.totalProtein,
                fats: plan.totals.totalFats,
                carbs: plan.totals.totalCarbs,
                calories: plan.totals.totalCalories,
              );
            },
          );

          // 3. Fetch Tracked Meals for today
          final trackingResult = await getTrackMealsUseCase(DateTime.now());
          await trackingResult.fold(
            (failure) {
              log(
                'SyncNutritionDataUseCase: Failed to fetch tracked meals: ${failure.message}',
              );
            },
            (tracking) async {
              log('SyncNutritionDataUseCase: Saving tracked totals...');
              await nutritionStorage.saveTrackedTotals(
                protein: tracking.totals.totalProtein,
                fats: tracking.totals.totalFats,
                carbs: tracking.totals.totalCarbs,
                calories: tracking.totals.totalCalories.toDouble(),
              );
            },
          );

          log('SyncNutritionDataUseCase: Sync completed successfully.');
          return const Right(null);
        },
      );
    } catch (e) {
      log('SyncNutritionDataUseCase: Unexpected error: $e');
      return Left(ApiException(message: e.toString()));
    }
  }
}
