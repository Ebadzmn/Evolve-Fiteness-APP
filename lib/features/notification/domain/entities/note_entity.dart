import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final String id;
  final String note;
  final String createdAt;
  final String athleteName;

  const NoteEntity({
    required this.id,
    required this.note,
    required this.createdAt,
    required this.athleteName,
  });

  @override
  List<Object?> get props => [id, note, createdAt, athleteName];
}

