import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../entities/timeline_entity.dart';
import '../repositories/timeline_repository.dart';

class GetTimelineUseCase {
  final TimelineRepository repository;

  GetTimelineUseCase(this.repository);

  Future<Either<ApiException, List<TimelineEntity>>> call(String athleteId) {
    return repository.getTimeline(athleteId);
  }
}
