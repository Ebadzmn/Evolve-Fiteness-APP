import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/notification/domain/entities/note_entity.dart';

enum NotesStatus { initial, loading, loaded, empty, error }

class NotificationState extends Equatable {
  final NotesStatus status;
  final List<NoteEntity> notes;
  final String? errorMessage;

  const NotificationState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.errorMessage,
  });

  NotificationState copyWith({
    NotesStatus? status,
    List<NoteEntity>? notes,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notes, errorMessage];
}

