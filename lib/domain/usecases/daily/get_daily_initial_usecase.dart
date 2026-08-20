import 'package:fitness_app/usecase/usecase.dart';
import '../../entities/daily_entities/daily_tracking_entity.dart';
import '../../repositories/daily/daily_repository.dart';

class GetDailyInitialUseCase implements UseCase<DailyTrackingEntity, NoParams> {
  final DailyRepository repository;
  GetDailyInitialUseCase(this.repository);

  @override
  Future<DailyTrackingEntity> call(NoParams params) {
    return repository.loadInitial();
  }
}
