import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';

class TrainingPlanModel extends TrainingPlanEntity {
  const TrainingPlanModel({
    required super.id,
    required super.title,
    required super.subtitle, // Generated from exercises
    required super.date,
    super.difficulty,
    super.type,
    super.comment,
    super.exercises,
  });

  factory TrainingPlanModel.fromJson(Map<String, dynamic> json) {
    // Parse exercises first to generate subtitle
    final List<TrainingPlanExerciseEntity> exercises =
        (json['exercise'] as List<dynamic>?)
            ?.map((e) => TrainingPlanExerciseModel.fromJson(e))
            .toList() ??
        [];

    // Generate subtitle: join first few exercise names
    final subtitle = exercises.isNotEmpty
        ? exercises.map((e) => e.name).take(2).join(', ')
        : 'No Exercises';

    return TrainingPlanModel(
      id: json['_id']?.toString() ?? '',
      title:
          (json['traingPlanName'] ?? json['title'])?.toString() ??
          'Untitled Plan',
      subtitle: subtitle,
      date: json['createdAt']?.toString() ?? '',
      difficulty:
          json['dificulty']?.toString() ?? json['difficulty']?.toString(),
      type: json['type']?.toString(),
      comment: json['comment']?.toString(),
      exercises: exercises,
    );
  }
}

class TrainingPlanExerciseModel extends TrainingPlanExerciseEntity {
  const TrainingPlanExerciseModel({
    required super.name,
    super.muscle,
    required super.sets,
    super.rep,
    super.range,
    super.comment,
    super.type,
    super.rir,
    super.exerciseId,
    super.exerciseSets,
  });

  factory TrainingPlanExerciseModel.fromJson(Map<String, dynamic> json) {
    // Handle exerciseSets array if present
    final List<TrainingPlanExerciseSetEntity> setsEntities =
        (json['exerciseSets'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map(TrainingPlanExerciseSetModel.fromJson)
            .toList() ??
        const [];

    String setsValue;
    String? range;
    String? rir;

    if (setsEntities.isNotEmpty) {
      final totalSets = setsEntities
          .map((e) => int.tryParse(e.sets) ?? 0)
          .fold<int>(0, (a, b) => a + b);
      setsValue = (totalSets > 0 ? totalSets : 0).toString();
      final first = setsEntities.first;
      range = first.repRange;
      rir = first.rir;
    } else {
      setsValue = json['sets']?.toString() ?? '0';
      range = (json['repRange'] ?? json['range'])?.toString();
      rir = json['rir']?.toString();
    }

    String? parsedExerciseId;
    final rawId = json['exerciseId'] ?? json['exercise'];
    if (rawId != null) {
      if (rawId is Map) {
        parsedExerciseId = (rawId['_id'] ?? rawId['id'])?.toString();
      } else {
        parsedExerciseId = rawId.toString();
      }
    }

    return TrainingPlanExerciseModel(
      name:
          (json['exerciseName'] ?? json['name'])?.toString() ??
          'Unknown Exercise',
      sets: setsValue,
      rep: (json['rep'] ?? json['reps'])?.toString(),
      range: range,
      comment: (json['excerciseNote'] ?? json['comment'])?.toString(),
      muscle: json['muscle']?.toString(),
      type: json['type']?.toString(),
      rir: rir ?? json['rir']?.toString(),
      exerciseId: parsedExerciseId,
      exerciseSets: setsEntities,
    );
  }
}

class TrainingPlanExerciseSetModel extends TrainingPlanExerciseSetEntity {
  const TrainingPlanExerciseSetModel({
    required super.sets,
    required super.repRange,
    required super.rir,
  });

  factory TrainingPlanExerciseSetModel.fromJson(Map<String, dynamic> json) {
    return TrainingPlanExerciseSetModel(
      sets: json['sets']?.toString() ?? '1',
      repRange: json['repRange']?.toString() ?? '',
      rir: json['rir']?.toString() ?? '',
    );
  }
}
