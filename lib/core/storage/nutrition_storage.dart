import 'package:shared_preferences/shared_preferences.dart';

class NutritionStorage {
  static const String _planProteinKey = 'nutrition_plan_total_protein';
  static const String _planFatsKey = 'nutrition_plan_total_fats';
  static const String _planCarbsKey = 'nutrition_plan_total_carbs';
  static const String _planCaloriesKey = 'nutrition_plan_total_calories';

  static const String _trackedProteinKey = 'nutrition_tracked_total_protein';
  static const String _trackedFatsKey = 'nutrition_tracked_total_fats';
  static const String _trackedCarbsKey = 'nutrition_tracked_total_carbs';
  static const String _trackedCaloriesKey = 'nutrition_tracked_total_calories';

  final SharedPreferences _prefs;

  NutritionStorage(this._prefs);

  // Save Plan Totals
  Future<void> savePlanTotals({
    required double protein,
    required double fats,
    required double carbs,
    required int calories,
  }) async {
    await _prefs.setDouble(_planProteinKey, protein);
    await _prefs.setDouble(_planFatsKey, fats);
    await _prefs.setDouble(_planCarbsKey, carbs);
    await _prefs.setInt(_planCaloriesKey, calories);
  }

  // Get Plan Totals
  double getPlanProtein() => _prefs.getDouble(_planProteinKey) ?? 0.0;
  double getPlanFats() => _prefs.getDouble(_planFatsKey) ?? 0.0;
  double getPlanCarbs() => _prefs.getDouble(_planCarbsKey) ?? 0.0;
  int getPlanCalories() => _prefs.getInt(_planCaloriesKey) ?? 0;

  // Save Tracked Totals
  Future<void> saveTrackedTotals({
    required double protein,
    required double fats,
    required double carbs,
    required double calories,
  }) async {
    await _prefs.setDouble(_trackedProteinKey, protein);
    await _prefs.setDouble(_trackedFatsKey, fats);
    await _prefs.setDouble(_trackedCarbsKey, carbs);
    await _prefs.setDouble(_trackedCaloriesKey, calories);
  }

  // Get Tracked Totals
  double getTrackedProtein() => _prefs.getDouble(_trackedProteinKey) ?? 0.0;
  double getTrackedFats() => _prefs.getDouble(_trackedFatsKey) ?? 0.0;
  double getTrackedCarbs() => _prefs.getDouble(_trackedCarbsKey) ?? 0.0;
  double getTrackedCalories() => _prefs.getDouble(_trackedCaloriesKey) ?? 0.0;

  // Clear all nutrition data
  Future<void> clearNutritionData() async {
    await _prefs.remove(_planProteinKey);
    await _prefs.remove(_planFatsKey);
    await _prefs.remove(_planCarbsKey);
    await _prefs.remove(_planCaloriesKey);
    await _prefs.remove(_trackedProteinKey);
    await _prefs.remove(_trackedFatsKey);
    await _prefs.remove(_trackedCarbsKey);
    await _prefs.remove(_trackedCaloriesKey);
  }
}
