import '../../../../domain/entities/training_entities/exercise_entity.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.id,
    required super.title,
    required super.category,
    required super.equipment,
    super.tags,
    super.description,
    super.imageUrl,
    super.videoUrl,
    super.difficulty,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['_id'] ?? '',
      title: json['name'] ?? '',
      category: json['musal'] ?? '', // Mapping 'musal' to 'category'
      equipment: json['equipment'] ?? '',
      tags: List<String>.from(json['subCategory'] ?? []),
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      videoUrl:
          (json['vedio'] ??
                  json['video'] ??
                  json['media'] ??
                  json['videoUrl'] ??
                  '')
              .toString(),
      difficulty: json['difficulty'] ?? '',
    );
  }
}
