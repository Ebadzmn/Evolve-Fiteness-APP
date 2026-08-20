import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/training/data/models/training_plan_model.dart';

void main() {
  group('TrainingPlanModel', () {
    const jsonMap = {
      "success": true,
      "message": "Training plans retrieved successfully",
      "data": [
        {
          "comment": "",
          "_id": "6941e4e412228f0d5d69a7bc",
          "userId": "693ddd32418ae5411e5359d4",
          "coachId": "693af88540f2f78c49bf5b8d",
          "traingPlanName": "Upper Body Strength",
          "exercise": [
            {
              "exerciseName": "Bench Press",
              "sets": "4",
              "rep": "8-10",
              "range": "70-80kg",
              "comment": "Keep elbows tucked",
              "_id": "6941e4e412228f0d5d69a7bd",
            },
            {
              "exerciseName": "Pull Ups",
              "sets": "3",
              "rep": "10-12",
              "range": "Bodyweight",
              "comment": "Full range of motion",
              "_id": "6941e4e412228f0d5d69a7be",
            },
          ],
          "dificulty": "Begineer",
          "createdAt": "2025-12-16T23:01:56.672Z",
          "updatedAt": "2025-12-16T23:01:56.672Z",
          "__v": 0,
        },
      ],
    };

    test('fromJson should return a valid model from JSON', () {
      final List<dynamic> data = jsonMap['data'] as List<dynamic>;
      final model = TrainingPlanModel.fromJson(data[0]);

      expect(model.id, "6941e4e412228f0d5d69a7bc");
      expect(model.title, "Upper Body Strength");
      expect(model.difficulty, "Begineer");
      expect(model.date, "2025-12-16T23:01:56.672Z");
      expect(model.exercises.length, 2);
      expect(model.subtitle, "Bench Press, Pull Ups");

      final exercise = model.exercises[0];
      expect(exercise.name, "Bench Press");
      expect(exercise.sets, "4");
      expect(exercise.rep, "8-10");
      expect(exercise.range, "70-80kg");
      expect(exercise.comment, "Keep elbows tucked");
    });

    test('fromJson should handle empty exercises and null values', () {
      final json = {
        "_id": "123",
        "traingPlanName": "Test Plan",
        "createdAt": "2025-01-01",
        "exercise": null,
      };

      final model = TrainingPlanModel.fromJson(json);

      expect(model.id, "123");
      expect(model.title, "Test Plan");
      expect(model.exercises, isEmpty);
      expect(model.subtitle, "No Exercises");
    });
  });
}
