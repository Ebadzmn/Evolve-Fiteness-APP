import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';

class FakeNutritionPlanRepository {
  Future<NutritionPlanEntity> loadPlan() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return NutritionPlanEntity(
      title: 'DEVELOPMENT PLAN',
      mealsCount: 7,
      waterLiters: 4.0,
      calories: 3200,
      proteinG: 200,
      carbsG: 200,
      fatsG: 80,
      meals: [
        NutritionMealEntity(
          id: '1',
          timeLabel: '7:00',
          title: 'BREAKFAST',
          calories: 550,
          proteinG: 35,
          carbsG: 75,
          fatsG: 5,
          items: [
            MealFoodItemEntity(name: 'Oatmeal', quantity: '50g'),
            MealFoodItemEntity(name: 'Protein Powder', quantity: '30g'),
            MealFoodItemEntity(name: 'Banana', quantity: '1 Piece'),
            MealFoodItemEntity(name: 'Almonds', quantity: '20g'),
          ],
          trainingDay: 'training day',
        ),
        NutritionMealEntity(
          id: '2',
          timeLabel: '10:00',
          title: 'SNACK 1',
          calories: 550,
          proteinG: 35,
          carbsG: 75,
          fatsG: 5,
          items: [
            MealFoodItemEntity(name: 'Protein', quantity: '40g'),
            MealFoodItemEntity(name: 'Apple', quantity: '1 Piece'),
          ],
          trainingDay: 'training day',
        ),
        NutritionMealEntity(
          id: '3',
          timeLabel: '13:00',
          title: 'LUNCH',
          calories: 550,
          proteinG: 35,
          carbsG: 75,
          fatsG: 5,
          items: [
            MealFoodItemEntity(name: 'Chicken breast', quantity: '200g'),
            MealFoodItemEntity(name: 'Rice', quantity: '150g'),
            MealFoodItemEntity(name: 'Mixed Vegetables', quantity: '200g'),
            MealFoodItemEntity(name: 'Olive oil', quantity: '10ml'),
          ],
          trainingDay: 'training day',
        ),
      ],
    );
  }
}
