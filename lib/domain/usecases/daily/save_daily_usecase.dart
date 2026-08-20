import 'package:fitness_app/usecase/usecase.dart';
import '../../entities/daily_entities/daily_tracking_entity.dart';
import '../../repositories/daily/daily_repository.dart';

class SaveDailyUseCase implements UseCase<void, DailyTrackingEntity> {
  final DailyRepository repository;
  SaveDailyUseCase(this.repository);

  @override
  Future<void> call(DailyTrackingEntity params) {
    return repository.save(params);
  }
}
