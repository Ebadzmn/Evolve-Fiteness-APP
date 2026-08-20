import 'package:fitness_app/features/notification/domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  const NoteModel({
    required super.id,
    required super.note,
    required super.createdAt,
    required super.athleteName,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    final athlete = json['athleteId'] as Map<String, dynamic>?;
    return NoteModel(
      id: json['_id'] as String? ?? '',
      note: json['note'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      athleteName: athlete?['name'] as String? ?? '',
    );
  }
}

