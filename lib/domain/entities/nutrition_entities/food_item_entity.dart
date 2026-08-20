import 'package:equatable/equatable.dart';

enum FoodCategory {
  all,
  protein,
  carbs,
  fats,
  supplements,
  fruits,
  vegetables,
  dairy,
}

class FoodItemEntity extends Equatable {
  final String? id;
  final String name;
  final FoodCategory category;
  final String? brand;
  final String defaultQuantity;
  final num calories;
  final num protein;
  final num carbs;
  final num fats;
  final num saturatedFats;
  final num unsaturatedFats;
  final num sugar;
  final num fiber;

  const FoodItemEntity({
    this.id,
    required this.name,
    required this.category,
    this.brand,
    this.defaultQuantity = '100g',
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.saturatedFats = 0,
    this.unsaturatedFats = 0,
    this.sugar = 0,
    this.fiber = 0,
  });

  factory FoodItemEntity.fromJson(Map<String, dynamic> json) {
    return FoodItemEntity(
      id: json['_id'],
      name: json['name'] ?? '',
      brand: json['brand'],
      category: _parseCategory(json['category']),
      defaultQuantity: json['defaultQuantity'] ?? '100g',
      calories: json['caloriesQuantity'] ?? 0,
      protein: json['proteinQuantity'] ?? 0,
      carbs: json['carbsQuantity'] ?? 0,
      fats: json['fatsQuantity'] ?? 0,
      saturatedFats: json['saturatedFats'] ?? 0,
      unsaturatedFats: json['unsaturatedFats'] ?? 0,
      sugar: json['sugarQuantity'] ?? 0,
      fiber: json['fiberQuantity'] ?? 0,
    );
  }

  static FoodCategory _parseCategory(String? category) {
    if (category == null) return FoodCategory.all;
    switch (category.toLowerCase()) {
      case 'protein':
        return FoodCategory.protein;
      case 'carbs':
        return FoodCategory.carbs;
      case 'fats':
        return FoodCategory.fats;
      case 'fruits':
        return FoodCategory.fruits;
      case 'vegetables':
        return FoodCategory.vegetables;
      case 'supplements':
        return FoodCategory.supplements;
      case 'dairy':
        return FoodCategory.dairy;
      default:
        return FoodCategory.all;
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    brand,
    defaultQuantity,
    calories,
    protein,
    carbs,
    fats,
    saturatedFats,
    unsaturatedFats,
    sugar,
    fiber,
  ];
}
