import 'package:fitness_app/domain/entities/daily_entities/daily_tracking_entity.dart';
import 'package:fitness_app/domain/repositories/daily/daily_repository.dart';
import 'package:fitness_app/usecase/usecase.dart';

class UpdateDailyUseCase implements UseCase<void, UpdateDailyParams> {
  final DailyRepository repository;

  UpdateDailyUseCase(this.repository);

  @override
  Future<void> call(UpdateDailyParams params) async {
    return await repository.update(params.entity, params.date);
  }
}

class UpdateDailyParams {
  final DailyTrackingEntity entity;
  final DateTime date;

  UpdateDailyParams({required this.entity, required this.date});
}
