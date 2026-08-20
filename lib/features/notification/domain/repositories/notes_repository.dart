import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/features/notification/domain/entities/note_entity.dart';

abstract class NotesRepository {
  Future<Either<ApiException, List<NoteEntity>>> getAthleteNotes(
    String athleteId,
  );
}

