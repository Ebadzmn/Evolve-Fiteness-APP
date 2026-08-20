import 'package:equatable/equatable.dart';

class MealSuggestionEntity extends Equatable {
  final String id;
  final String name;

  const MealSuggestionEntity({required this.id, required this.name});

  factory MealSuggestionEntity.fromJson(Map<String, dynamic> json) {
    return MealSuggestionEntity(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
