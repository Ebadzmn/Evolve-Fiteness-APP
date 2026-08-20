import 'package:equatable/equatable.dart';

/// Entity for a single question-answer pair from old check-in data.
class OldCheckInQA extends Equatable {
  final String question;
  final String answer;
  final bool status;

  const OldCheckInQA({
    this.question = '',
    this.answer = '',
    this.status = false,
  });

  factory OldCheckInQA.fromMap(Map<String, dynamic> map) => OldCheckInQA(
    question: map['question'] ?? '',
    answer: map['answer'] ?? '',
    status: map['status'] ?? false,
  );

  @override
  List<Object?> get props => [question, answer, status];
}

/// Entity for well-being data from old check-in.
class OldCheckInWellBeing extends Equatable {
  final Map<String, int> metrics;

  const OldCheckInWellBeing({
    this.metrics = const {},
  });

  // Getters for backward compatibility
  int get energyLevel => metrics['energyLevel'] ?? 0;
  int get stressLevel => metrics['stressLevel'] ?? 0;
  int get moodLevel => metrics['moodLevel'] ?? 0;
  int get sleepQuality => metrics['sleepQuality'] ?? 0;
  int get hungerLevel => metrics['hungerLevel'] ?? 0;

  factory OldCheckInWellBeing.fromMap(Map<String, dynamic> map) {
    final Map<String, int> result = {};
    map.forEach((key, value) {
      if (key != '_id' &&
          key != 'id' &&
          key != 'userId' &&
          key != 'coachId' &&
          key != 'createdAt' &&
          key != 'updatedAt' &&
          key != '__v') {
        result[key] = num.tryParse(value?.toString() ?? '')?.toInt() ?? 0;
      }
    });

    return OldCheckInWellBeing(metrics: result);
  }

  @override
  List<Object?> get props => [metrics];
}

/// Entity for nutrition data from old check-in.
class OldCheckInNutrition extends Equatable {
  final int dietLevel;
  final int digestionLevel;
  final String challengeDiet;

  const OldCheckInNutrition({
    this.dietLevel = 0,
    this.digestionLevel = 0,
    this.challengeDiet = '',
  });

  factory OldCheckInNutrition.fromMap(Map<String, dynamic> map) =>
      OldCheckInNutrition(
        dietLevel: num.tryParse(
                (map['dietLevel'] ?? map['nutritionPlanAdherence'])?.toString() ??
                    '',
              )?.toInt() ??
            0,
        digestionLevel:
            num.tryParse(map['digestionLevel']?.toString() ?? '')?.toInt() ?? 0,
        challengeDiet: map['challengeDiet'] ?? '',
      );

  @override
  List<Object?> get props => [dietLevel, digestionLevel, challengeDiet];
}

/// Entity for training data from old check-in.
class OldCheckInTraining extends Equatable {
  final int feelStrength;
  final int pumps;
  final bool cardioCompleted;
  final bool trainingCompleted;

  const OldCheckInTraining({
    this.feelStrength = 0,
    this.pumps = 0,
    this.cardioCompleted = false,
    this.trainingCompleted = false,
  });

  factory OldCheckInTraining.fromMap(Map<String, dynamic> map) =>
      OldCheckInTraining(
        feelStrength:
            num.tryParse(map['feelStrength']?.toString() ?? '')?.toInt() ?? 0,
        pumps: num.tryParse(map['pumps']?.toString() ?? '')?.toInt() ?? 0,
        cardioCompleted: map['cardioCompleted'] ?? false,
        trainingCompleted: map['trainingCompleted'] ?? false,
      );

  @override
  List<Object?> get props => [
    feelStrength,
    pumps,
    cardioCompleted,
    trainingCompleted,
  ];
}

/// Entity representing old check-in data from API.
/// Matches the response structure from /check-in/old-data?skip={n}
class OldCheckInEntity extends Equatable {
  final String id;
  final String odId;
  final String odaId;
  final double currentWeight;
  final double averageWeight;
  final List<OldCheckInQA> questionAndAnswer;
  final OldCheckInWellBeing wellBeing;
  final OldCheckInNutrition nutrition;
  final OldCheckInTraining training;
  final String trainingFeedback;
  final String dailyNote;
  final List<String> image;
  final List<String> media;
  final String checkinCompleted;
  final String coachNote;
  final String createdAt;
  final String updatedAt;

  const OldCheckInEntity({
    this.id = '',
    this.odId = '',
    this.odaId = '',
    this.currentWeight = 0,
    this.averageWeight = 0,
    this.questionAndAnswer = const [],
    this.wellBeing = const OldCheckInWellBeing(),
    this.nutrition = const OldCheckInNutrition(),
    this.training = const OldCheckInTraining(),
    this.trainingFeedback = '',
    this.dailyNote = '',
    this.image = const [],
    this.media = const [],
    this.checkinCompleted = '',
    this.coachNote = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory OldCheckInEntity.fromMap(Map<String, dynamic> map) {
    final qaList =
        (map['questionAndAnswer'] as List<dynamic>?)
            ?.map((e) => OldCheckInQA.fromMap(Map<String, dynamic>.from(e)))
            .toList() ??
        [];

    return OldCheckInEntity(
      id: map['_id'] ?? map['id'] ?? '',
      odId: map['userId'] ?? '',
      odaId: map['coachId'] ?? '',
      currentWeight:
          num.tryParse(map['currentWeight']?.toString() ?? '')?.toDouble() ?? 0,
      averageWeight:
          num.tryParse(map['averageWeight']?.toString() ?? '')?.toDouble() ?? 0,
      questionAndAnswer: qaList,
      wellBeing: OldCheckInWellBeing.fromMap(
        Map<String, dynamic>.from(map['wellBeing'] ?? {}),
      ),
      nutrition: OldCheckInNutrition.fromMap(
        Map<String, dynamic>.from(map['nutrition'] ?? {}),
      ),
      training: OldCheckInTraining.fromMap(
        Map<String, dynamic>.from(map['training'] ?? {}),
      ),
      trainingFeedback: map['trainingFeedback'] ?? '',
      dailyNote: map['dailyNote'] ?? map['athleteNote'] ?? '',
      image: List<String>.from(map['image'] ?? []),
      media: List<String>.from(map['media'] ?? []),
      checkinCompleted: map['checkinCompleted'] ?? '',
      coachNote: map['coachNote'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  /// Get formatted date string from createdAt
  String get formattedDate {
    if (createdAt.isEmpty) return '-';
    try {
      final dt = DateTime.parse(createdAt);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return createdAt;
    }
  }

  @override
  List<Object?> get props => [
    id,
    odId,
    odaId,
    currentWeight,
    averageWeight,
    questionAndAnswer,
    wellBeing,
    nutrition,
    training,
    trainingFeedback,
    dailyNote,
    image,
    media,
    checkinCompleted,
    coachNote,
    createdAt,
    updatedAt,
  ];
}
