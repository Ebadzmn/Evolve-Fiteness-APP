import 'package:equatable/equatable.dart';

class MealFoodItemEntity extends Equatable {
  final String? id; // ID might be null for non-tracked plans
  final String name;
  final String quantity; // e.g., "30g" or "1 Piece"

  const MealFoodItemEntity({
    this.id,
    required this.name,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, name, quantity];
}
