import '../../entities/daily_entities/daily_tracking_entity.dart';
import '../../repositories/daily/daily_repository.dart';
import '../../../usecase/usecase.dart';

class GetDailyByDateUseCase implements UseCase<DailyTrackingEntity, DateTime> {
  final DailyRepository repository;
  GetDailyByDateUseCase(this.repository);

  @override
  Future<DailyTrackingEntity> call(DateTime params) {
    return repository.loadByDate(params);
  }
}
