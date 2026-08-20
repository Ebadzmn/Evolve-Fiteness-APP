import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';

class FakeTrackMealsRepository {
  Future<List<NutritionMealEntity>> loadMealsForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      NutritionMealEntity(
        id: 'default_1',
        timeLabel: '7:00',
        title: 'Meals 1',
        calories: 520,
        proteinG: 32,
        carbsG: 70,
        fatsG: 6,
        items: [
          MealFoodItemEntity(name: 'Oats', quantity: '30g'),
          MealFoodItemEntity(name: 'Milk', quantity: '200ml'),
          MealFoodItemEntity(name: 'Banana', quantity: '1 Piece'),
        ],
        trainingDay: 'training day',
      ),
      NutritionMealEntity(
        id: 'default_2',
        timeLabel: '10:00',
        title: 'Meals 2',
        calories: 300,
        proteinG: 20,
        carbsG: 30,
        fatsG: 5,
        items: [
          MealFoodItemEntity(name: 'Greek Yogurt', quantity: '150g'),
          MealFoodItemEntity(name: 'Honey', quantity: '10g'),
        ],
        trainingDay: 'training day',
      ),
      NutritionMealEntity(
        id: 'default_3',
        timeLabel: '13:00',
        title: 'Meals 3',
        calories: 650,
        proteinG: 40,
        carbsG: 80,
        fatsG: 8,
        items: [
          MealFoodItemEntity(name: 'Chicken Breast', quantity: '200g'),
          MealFoodItemEntity(name: 'Rice', quantity: '100g'),
          MealFoodItemEntity(name: 'Broccoli', quantity: '50g'),
        ],
        trainingDay: 'training day',
      ),
    ];
  }

  Future<void> saveMealForDate(DateTime date, NutritionMealEntity meal) async {
    // Fake save
  }
}
