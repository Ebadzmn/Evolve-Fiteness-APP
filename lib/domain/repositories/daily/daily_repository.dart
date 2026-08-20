import '../../entities/daily_entities/daily_tracking_entity.dart';

abstract class DailyRepository {
  Future<DailyTrackingEntity> loadInitial();
  Future<DailyTrackingEntity> loadByDate(DateTime date);
  Future<void> save(DailyTrackingEntity entity);
  Future<void> update(DailyTrackingEntity entity, DateTime date);
}
