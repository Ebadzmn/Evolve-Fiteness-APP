import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/features/notification/data/datasources/notes_remote_data_source.dart';
import 'package:fitness_app/features/notification/domain/entities/note_entity.dart';
import 'package:fitness_app/features/notification/domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;

  NotesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ApiException, List<NoteEntity>>> getAthleteNotes(
    String athleteId,
  ) async {
    try {
      final result = await remoteDataSource.getAthleteNotes(athleteId);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiException(message: e.message ?? 'Failed to fetch notes'),
      );
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}

