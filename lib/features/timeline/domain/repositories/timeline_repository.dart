import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../entities/timeline_entity.dart';

abstract class TimelineRepository {
  Future<Either<ApiException, List<TimelineEntity>>> getTimeline(String athleteId);
}
