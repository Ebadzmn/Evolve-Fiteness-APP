import 'package:fitness_app/domain/entities/profile_entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.athlete,
    required super.coachName,
    required super.timeline,
    required super.show,
    required super.countDown,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      athlete: AthleteModel.fromJson(json['athlete'] ?? {}),
      coachName: json['coachName'] as String? ?? '',
      timeline:
          (json['timeline'] as List<dynamic>?)
              ?.map((e) => TimelineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      show: () {
        final showData = json['show'] ?? json['shows'];
        if (showData is List) {
          return showData
              .map((e) => ShowModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (showData is Map<String, dynamic>) {
          return [ShowModel.fromJson(showData)];
        }

        final nestedAthlete = json['athlete'];
        if (nestedAthlete is Map<String, dynamic>) {
          final shows = nestedAthlete['shows'];
          if (shows is List) {
            return shows
                .map((e) => ShowModel.fromJson(e as Map<String, dynamic>))
                .toList();
          } else if (shows is Map<String, dynamic>) {
            return [ShowModel.fromJson(shows)];
          }
        }

        return const <ShowModel>[];
      }(),
      countDown: (json['countDown'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'athlete': (athlete as AthleteModel).toJson(),
      'coachName': coachName,
      'timeline': timeline.map((e) => (e as TimelineModel).toJson()).toList(),
      'show': show.map((e) => (e as ShowModel).toJson()).toList(),
      'countDown': countDown,
    };
  }
}

class AthleteModel extends AthleteEntity {
  const AthleteModel({
    required super.id,
    required super.name,
    required super.coachId,
    required super.role,
    required super.email,
    required super.gender,
    required super.category,
    required super.phase,
    required super.weight,
    required super.height,
    required super.image,
    required super.notifiedThisWeek,
    required super.age,
    required super.waterQuantity,
    required super.status,
    required super.trainingDaySteps,
    required super.restDaySteps,
    required super.checkInDay,
    required super.goal,
    required super.verified,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    required super.lastActive,
  });

  factory AthleteModel.fromJson(Map<String, dynamic> json) {
    return AthleteModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      coachId: json['coachId'] as String? ?? '',
      role: json['role'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      category: json['category'] as String? ?? '',
      phase: json['phase'] as String? ?? '',
      weight: json['weight'] as num? ?? 0,
      height: json['height'] as num? ?? 0,
      image: json['image'] as String? ?? '',
      notifiedThisWeek: json['notifiedThisWeek'] as bool? ?? false,
      age: (json['age'] as num?)?.toInt() ?? 0,
      waterQuantity: (json['waterQuantity'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      trainingDaySteps: (json['trainingDaySteps'] as num?)?.toInt() ?? 0,
      restDaySteps: (json['restDaySteps'] as num?)?.toInt() ?? 0,
      checkInDay: json['checkInDay'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
      isActive: json['isActive'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      lastActive: json['lastActive'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'coachId': coachId,
      'role': role,
      'email': email,
      'gender': gender,
      'category': category,
      'phase': phase,
      'weight': weight,
      'height': height,
      'image': image,
      'notifiedThisWeek': notifiedThisWeek,
      'age': age,
      'waterQuantity': waterQuantity,
      'status': status,
      'trainingDaySteps': trainingDaySteps,
      'restDaySteps': restDaySteps,
      'checkInDay': checkInDay,
      'goal': goal,
      'verified': verified,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastActive': lastActive,
    };
  }
}

class TimelineModel extends TimelineEntity {
  const TimelineModel({
    required super.id,
    required super.nextCheckInDate,
    required super.phase,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      id: json['_id'] as String? ?? '',
      nextCheckInDate: json['nextCheckInDate'] as String? ?? '',
      phase: json['phase'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'nextCheckInDate': nextCheckInDate, 'phase': phase};
  }
}

class ShowModel extends ShowEntity {
  const ShowModel({
    required super.id,
    required super.name,
    required super.division,
    required super.date,
    required super.location,
    required super.countDown,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      division: json['division'] as String? ?? '',
      date: json['date'] as String? ?? '',
      location: json['location'] as String? ?? '',
      countDown: (json['countDown'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'division': division,
      'date': date,
      'location': location,
      'countDown': countDown,
    };
  }
}
