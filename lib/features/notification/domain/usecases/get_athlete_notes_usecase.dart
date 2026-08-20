import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/features/notification/domain/entities/note_entity.dart';
import 'package:fitness_app/features/notification/domain/repositories/notes_repository.dart';

class GetAthleteNotesUseCase {
  final NotesRepository repository;

  GetAthleteNotesUseCase(this.repository);

  Future<Either<ApiException, List<NoteEntity>>> call(String athleteId) {
    return repository.getAthleteNotes(athleteId);
  }
}

