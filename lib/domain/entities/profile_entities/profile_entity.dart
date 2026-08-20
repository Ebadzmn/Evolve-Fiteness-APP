import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final AthleteEntity athlete;
  final String coachName;
  final List<TimelineEntity> timeline;
  final List<ShowEntity> show;
  final int countDown;

  const ProfileEntity({
    required this.athlete,
    required this.coachName,
    required this.timeline,
    required this.show,
    required this.countDown,
  });

  @override
  List<Object?> get props => [athlete, coachName, timeline, show, countDown];
}

class AthleteEntity extends Equatable {
  final String id;
  final String name;
  final String coachId;
  final String role;
  final String email;
  final String gender;
  final String category;
  final String phase;
  final num weight;
  final num height;
  final String image;
  final bool notifiedThisWeek;
  final int age;
  final int waterQuantity;
  final String status;
  final int trainingDaySteps;
  final int restDaySteps;
  final String checkInDay;
  final String goal;
  final bool verified;
  final String isActive;
  final String createdAt;
  final String updatedAt;
  final String lastActive;

  const AthleteEntity({
    required this.id,
    required this.name,
    required this.coachId,
    required this.role,
    required this.email,
    required this.gender,
    required this.category,
    required this.phase,
    required this.weight,
    required this.height,
    required this.image,
    required this.notifiedThisWeek,
    required this.age,
    required this.waterQuantity,
    required this.status,
    required this.trainingDaySteps,
    required this.restDaySteps,
    required this.checkInDay,
    required this.goal,
    required this.verified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.lastActive,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    coachId,
    role,
    email,
    gender,
    category,
    phase,
    weight,
    height,
    image,
    notifiedThisWeek,
    age,
    waterQuantity,
    status,
    trainingDaySteps,
    restDaySteps,
    checkInDay,
    goal,
    verified,
    isActive,
    createdAt,
    updatedAt,
    lastActive,
  ];
}

class TimelineEntity extends Equatable {
  final String id;
  final String nextCheckInDate;
  final String phase;

  const TimelineEntity({
    required this.id,
    required this.nextCheckInDate,
    required this.phase,
  });

  @override
  List<Object?> get props => [id, nextCheckInDate, phase];
}

class ShowEntity extends Equatable {
  final String id;
  final String name;
  final String division;
  final String date;
  final String location;
   final int countDown;

  const ShowEntity({
    required this.id,
    required this.name,
    required this.division,
    required this.date,
    required this.location,
     required this.countDown,
  });

  @override
  List<Object?> get props => [id, name, division, date, location, countDown];
}
