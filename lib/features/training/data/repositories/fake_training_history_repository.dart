import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_history_repository.dart';

class FakeTrainingHistoryRepository implements TrainingHistoryRepository {
  @override
  Future<Either<ApiException, TrainingHistoryResponseEntity>>
  getHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      TrainingHistoryResponseEntity(
        pr: const PREntity(volumePR: false),
        history: [
          TrainingHistoryEntity(
            id: '69602faa26e8ec314aa09503',
            userId: '694af4853dd5d5e3ce5852f2',
            trainingName: 'Bench Press(seated Row) machin',
            time: const TrainingTimeEntity(hour: '1', minute: '30'),
            pushData: const [
              PushDataEntity(
                weight: 70,
                repRange: '55',
                rir: '2',
                sets: 4,
                exerciseName: 'Seated Row (Machine)',
                oneRM: null,
              ),
              PushDataEntity(
                weight: 70,
                repRange: '55',
                rir: '2',
                sets: 4,
                exerciseName: 'Seated Row (Machine)',
                oneRM: null,
              ),
              PushDataEntity(
                weight: 65,
                repRange: '7',
                rir: '2',
                sets: 1,
                exerciseName: 'Wide Row Machine',
                oneRM: null,
              ),
              PushDataEntity(
                weight: 65,
                repRange: '7',
                rir: '2',
                sets: 2,
                exerciseName: 'Wide Row Machine',
                oneRM: null,
              ),
            ],
            note: 'Focus on proper form and full range of motion',
            dateTime: DateTime.parse('2025-11-18T16:52:00Z'),
            updatedAt: DateTime.parse('2025-11-18T16:52:00Z'),
            totalWeight: 5000,
          ),
          TrainingHistoryEntity(
            id: '69603a9e86856f9ab27aa4c0',
            userId: '694af4853dd5d5e3ce5852f2',
            trainingName: 'push body',
            time: const TrainingTimeEntity(hour: '0', minute: '0'),
            pushData: const [
              PushDataEntity(
                weight: 0,
                repRange: '8-10',
                rir: '70-80kg',
                sets: 4,
                exerciseName: 'Bench Press',
              ),
              PushDataEntity(
                weight: 70,
                repRange: '8-10',
                rir: '70-80kg',
                sets: 1,
                exerciseName: 'Pull Ups',
              ),
            ],
            note: 'Mock Note',
            dateTime: DateTime.now(),
            updatedAt: DateTime.now(),
            totalWeight: null,
          ),
        ],
      ),
    );
  }
}
