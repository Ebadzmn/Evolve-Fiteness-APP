import 'package:equatable/equatable.dart';
import 'well_being_entity.dart';
import 'training_entity.dart';
import 'nutrition_entity.dart';
import 'ped_health_entity.dart';
import 'vital_entity.dart';
import 'sleep_entity.dart';
import 'women_entity.dart';

class DailyTrackingEntity extends Equatable {
  final VitalEntity vital;
  final bool? isSick;
  final WellBeingEntity wellBeing;
  final SleepEntity sleep;
  final TrainingEntity training;
  final NutritionEntity nutrition;
  final WomenEntity women;
  final PedHealthEntity pedHealth;
  final String notes;

  const DailyTrackingEntity({
    required this.vital,
    required this.isSick,
    required this.wellBeing,
    required this.sleep,
    required this.training,
    required this.nutrition,
    required this.women,
    required this.pedHealth,
    required this.notes,
  });

  DailyTrackingEntity copyWith({
    VitalEntity? vital,
    bool? isSick,
    WellBeingEntity? wellBeing,
    SleepEntity? sleep,
    TrainingEntity? training,
    NutritionEntity? nutrition,
    WomenEntity? women,
    PedHealthEntity? pedHealth,
    String? notes,
  }) => DailyTrackingEntity(
    vital: vital ?? this.vital,
    isSick: isSick ?? this.isSick,
    wellBeing: wellBeing ?? this.wellBeing,
    sleep: sleep ?? this.sleep,
    training: training ?? this.training,
    nutrition: nutrition ?? this.nutrition,
    women: women ?? this.women,
    pedHealth: pedHealth ?? this.pedHealth,
    notes: notes ?? this.notes,
  );

  @override
  List<Object?> get props => [
    vital,
    isSick,
    wellBeing,
    sleep,
    training,
    nutrition,
    women,
    pedHealth,
    notes,
  ];
}
