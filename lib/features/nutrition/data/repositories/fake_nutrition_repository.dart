import 'dart:async';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_dashboard_entity.dart';

class FakeNutritionRepository {
  Future<NutritionDashboardEntity> loadInitial() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const NutritionDashboardEntity(
      caloriesConsumed: 1850,
      caloriesGoal: 2500,
      proteinConsumed: 145,
      proteinGoal: 180,
      carbsConsumed: 200,
      carbsGoal: 240,
      fatConsumed: 14,
      fatGoal: 180,
    );
  }
}
