import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/timeline_entity.dart';
import '../../domain/repositories/timeline_repository.dart';
import '../datasources/timeline_remote_data_source.dart';

class TimelineRepositoryImpl implements TimelineRepository {
  final TimelineRemoteDataSource remoteDataSource;

  TimelineRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ApiException, List<TimelineEntity>>> getTimeline(String athleteId) async {
    try {
      final models = await remoteDataSource.getTimeline(athleteId);
      return Right(models.map((e) => e as TimelineEntity).toList());
    } catch (e) {
      if (e is ApiException) {
        return Left(e);
      }
      return Left(ApiException(message: e.toString()));
    }
  }
}
