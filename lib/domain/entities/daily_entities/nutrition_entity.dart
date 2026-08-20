import 'package:equatable/equatable.dart';

class NutritionEntity extends Equatable {
  final double dietLevel;
  final double digestion;
  final double hunger;
  final String caloriesText;
  final String carbsText;
  final String proteinText;
  final String fatsText;
  final String saltText;
  final String challenge;

  const NutritionEntity({
    required this.dietLevel,
    required this.digestion,
    required this.hunger,
    required this.caloriesText,
    required this.carbsText,
    required this.proteinText,
    required this.fatsText,
    required this.saltText,
    required this.challenge,
  });

  NutritionEntity copyWith({
    double? dietLevel,
    double? digestion,
    double? hunger,
    String? caloriesText,
    String? carbsText,
    String? proteinText,
    String? fatsText,
    String? saltText,
    String? challenge,
  }) => NutritionEntity(
    dietLevel: dietLevel ?? this.dietLevel,
    digestion: digestion ?? this.digestion,
    hunger: hunger ?? this.hunger,
    caloriesText: caloriesText ?? this.caloriesText,
    carbsText: carbsText ?? this.carbsText,
    proteinText: proteinText ?? this.proteinText,
    fatsText: fatsText ?? this.fatsText,
    saltText: saltText ?? this.saltText,
    challenge: challenge ?? this.challenge,
  );

  @override
  List<Object?> get props => [
    dietLevel,
    digestion,
    hunger,
    caloriesText,
    carbsText,
    proteinText,
    fatsText,
    saltText,
    challenge,
  ];
}
