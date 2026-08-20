class TrainingPlanExerciseSetEntity {
  final String sets;
  final String repRange;
  final String rir;

  const TrainingPlanExerciseSetEntity({
    required this.sets,
    required this.repRange,
    required this.rir,
  });
}

class TrainingPlanExerciseEntity {
  final String name;
  final String? muscle;
  final String sets;
  final String? rep;
  final String? range;
  final String? comment;
  final String? type; // e.g., "Machine", "Cable"
  final String? rir;
  final String? exerciseId;
  final List<TrainingPlanExerciseSetEntity> exerciseSets;

  const TrainingPlanExerciseEntity({
    required this.name,
    this.muscle,
    required this.sets,
    this.rep,
    this.range,
    this.comment,
    this.type,
    this.rir,
    this.exerciseId,
    this.exerciseSets = const [],
  });
}

class TrainingPlanEntity {
  final String id;
  final String title; // traingPlanName
  final String subtitle;
  final String date; // createdAt
  final String? difficulty; // dificulty
  final String? type;
  final String? comment;
  final List<TrainingPlanExerciseEntity> exercises;

  const TrainingPlanEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    this.difficulty,
    this.type,
    this.comment,
    this.exercises = const [],
  });
}
