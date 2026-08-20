import 'package:equatable/equatable.dart';
import 'dart:convert';

class CheckInEntity extends Equatable {
  final int step;
  final String answer1;
  final String answer2;
  final CheckInWellBeing wellBeing;
  final CheckInNutrition nutrition;
  final CheckInTraining training;
  final CheckInUploads uploads;
  final String athleteNote;
  final String? weekId;
  final double currentWeight;
  final double averageWeight;

  const CheckInEntity({
    this.step = 0,
    this.answer1 = '',
    this.answer2 = '',
    this.wellBeing = const CheckInWellBeing(),
    this.nutrition = const CheckInNutrition(),
    this.training = const CheckInTraining(),
    this.uploads = const CheckInUploads(),
    this.athleteNote = '',
    this.weekId,
    this.currentWeight = 0,
    this.averageWeight = 0,
  });

  CheckInEntity copyWith({
    int? step,
    String? answer1,
    String? answer2,
    CheckInWellBeing? wellBeing,
    CheckInNutrition? nutrition,
    CheckInTraining? training,
    CheckInUploads? uploads,
    String? athleteNote,
    String? weekId,
    double? currentWeight,
    double? averageWeight,
  }) {
    return CheckInEntity(
      step: step ?? this.step,
      answer1: answer1 ?? this.answer1,
      answer2: answer2 ?? this.answer2,
      wellBeing: wellBeing ?? this.wellBeing,
      nutrition: nutrition ?? this.nutrition,
      training: training ?? this.training,
      uploads: uploads ?? this.uploads,
      athleteNote: athleteNote ?? this.athleteNote,
      weekId: weekId ?? this.weekId,
      currentWeight: currentWeight ?? this.currentWeight,
      averageWeight: averageWeight ?? this.averageWeight,
    );
  }

  Map<String, dynamic> toMap() => {
    'step': step,
    'answer1': answer1,
    'answer2': answer2,
    'wellBeing': wellBeing.toMap(),
    'nutrition': nutrition.toMap(),
    'training': training.toMap(),
    'uploads': uploads.toMap(),
    'athleteNote': athleteNote,
    'weekId': weekId,
    'currentWeight': currentWeight,
    'averageWeight': averageWeight,
  };
  factory CheckInEntity.fromMap(Map<String, dynamic> map) => CheckInEntity(
    step: map['step'] ?? 0,
    answer1: map['answer1'] ?? '',
    answer2: map['answer2'] ?? '',
    wellBeing: CheckInWellBeing.fromMap(
      Map<String, dynamic>.from(map['wellBeing'] ?? {}),
    ),
    nutrition: CheckInNutrition.fromMap(
      Map<String, dynamic>.from(map['nutrition'] ?? {}),
    ),
    training: CheckInTraining.fromMap(
      Map<String, dynamic>.from(map['training'] ?? {}),
    ),
    uploads: CheckInUploads.fromMap(
      Map<String, dynamic>.from(map['uploads'] ?? {}),
    ),
    athleteNote: map['athleteNote'] ?? '',
    weekId: map['weekId'],
    currentWeight: (map['currentWeight'] ?? 0).toDouble(),
    averageWeight: (map['averageWeight'] ?? 0).toDouble(),
  );
  String toJson() => jsonEncode(toMap());
  factory CheckInEntity.fromJson(String source) =>
      CheckInEntity.fromMap(jsonDecode(source));

  @override
  List<Object?> get props => [
    step,
    answer1,
    answer2,
    wellBeing,
    nutrition,
    training,
    uploads,
    athleteNote,
    weekId,
    currentWeight,
    averageWeight,
  ];
}

class CheckInWellBeing extends Equatable {
  final Map<String, double> metrics;

  const CheckInWellBeing({
    this.metrics = const {},
  });

  CheckInWellBeing copyWith({
    Map<String, double>? metrics,
  }) =>
      CheckInWellBeing(
        metrics: metrics ?? this.metrics,
      );

  Map<String, dynamic> toMap() => metrics;

  factory CheckInWellBeing.fromMap(Map<String, dynamic> map) {
    final Map<String, double> result = {};
    map.forEach((key, value) {
      if (key != '_id' &&
          key != 'id' &&
          key != 'userId' &&
          key != 'coachId' &&
          key != 'createdAt' &&
          key != 'updatedAt' &&
          key != '__v') {
        result[key] = (value ?? 0).toDouble();
      }
    });
    return CheckInWellBeing(metrics: result);
  }

  @override
  List<Object?> get props => [metrics];
}

class CheckInNutrition extends Equatable {
  final double dietLevel;
  final double digestion;
  final String challenge;

  const CheckInNutrition({
    this.dietLevel = 1,
    this.digestion = 1,
    this.challenge = '',
  });

  CheckInNutrition copyWith({
    double? dietLevel,
    double? digestion,
    String? challenge,
  }) => CheckInNutrition(
    dietLevel: dietLevel ?? this.dietLevel,
    digestion: digestion ?? this.digestion,
    challenge: challenge ?? this.challenge,
  );

  Map<String, dynamic> toMap() => {
    'dietLevel': dietLevel,
    'digestion': digestion,
    'challenge': challenge,
  };
  factory CheckInNutrition.fromMap(Map<String, dynamic> map) =>
      CheckInNutrition(
        dietLevel: (map['dietLevel'] ?? 1).toDouble(),
        digestion: (map['digestion'] ?? 1).toDouble(),
        challenge: map['challenge'] ?? '',
      );

  @override
  List<Object?> get props => [dietLevel, digestion, challenge];
}

class CheckInTraining extends Equatable {
  final double feelStrength;
  final double pumps;
  final bool trainingCompleted;
  final bool cardioCompleted;
  final String feedback;
  final String cardioType;
  final String cardioDuration;

  const CheckInTraining({
    this.feelStrength = 1,
    this.pumps = 1,
    this.trainingCompleted = true,
    this.cardioCompleted = true,
    this.feedback = '',
    this.cardioType = '',
    this.cardioDuration = '',
  });

  CheckInTraining copyWith({
    double? feelStrength,
    double? pumps,
    bool? trainingCompleted,
    bool? cardioCompleted,
    String? feedback,
    String? cardioType,
    String? cardioDuration,
  }) => CheckInTraining(
    feelStrength: feelStrength ?? this.feelStrength,
    pumps: pumps ?? this.pumps,
    trainingCompleted: trainingCompleted ?? this.trainingCompleted,
    cardioCompleted: cardioCompleted ?? this.cardioCompleted,
    feedback: feedback ?? this.feedback,
    cardioType: cardioType ?? this.cardioType,
    cardioDuration: cardioDuration ?? this.cardioDuration,
  );

  Map<String, dynamic> toMap() => {
    'feelStrength': feelStrength,
    'pumps': pumps,
    'trainingCompleted': trainingCompleted,
    'cardioCompleted': cardioCompleted,
    'feedback': feedback,
    'cardioType': cardioType,
    'cardioDuration': cardioDuration,
  };
  factory CheckInTraining.fromMap(Map<String, dynamic> map) => CheckInTraining(
    feelStrength: (map['feelStrength'] ?? 1).toDouble(),
    pumps: (map['pumps'] ?? 1).toDouble(),
    trainingCompleted: map['trainingCompleted'] ?? true,
    cardioCompleted: map['cardioCompleted'] ?? true,
    feedback: map['feedback'] ?? '',
    cardioType: map['cardioType'] ?? '',
    cardioDuration: map['cardioDuration'] ?? '',
  );

  @override
  List<Object?> get props => [
    feelStrength,
    pumps,
    trainingCompleted,
    cardioCompleted,
    feedback,
    cardioType,
    cardioDuration,
  ];
}

class CheckInUploads extends Equatable {
  final bool picturesUploaded;
  final bool videoUploaded;
  final List<String> picturePaths;
  final String? videoPath;

  const CheckInUploads({
    this.picturesUploaded = true,
    this.videoUploaded = true,
    this.picturePaths = const [],
    this.videoPath,
  });

  CheckInUploads copyWith({
    bool? picturesUploaded,
    bool? videoUploaded,
    List<String>? picturePaths,
    String? videoPath,
  }) => CheckInUploads(
    picturesUploaded: picturesUploaded ?? this.picturesUploaded,
    videoUploaded: videoUploaded ?? this.videoUploaded,
    picturePaths: picturePaths ?? this.picturePaths,
    videoPath: videoPath ?? this.videoPath,
  );

  Map<String, dynamic> toMap() => {
    'picturesUploaded': picturesUploaded,
    'videoUploaded': videoUploaded,
    'picturePaths': picturePaths,
    'videoPath': videoPath,
  };
  factory CheckInUploads.fromMap(Map<String, dynamic> map) => CheckInUploads(
    picturesUploaded: map['picturesUploaded'] ?? true,
    videoUploaded: map['videoUploaded'] ?? true,
    picturePaths: List<String>.from(map['picturePaths'] ?? []),
    videoPath: map['videoPath'],
  );

  @override
  List<Object?> get props => [
    picturesUploaded,
    videoUploaded,
    picturePaths,
    videoPath,
  ];
}
