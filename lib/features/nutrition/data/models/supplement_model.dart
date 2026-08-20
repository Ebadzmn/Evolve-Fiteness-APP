import 'package:fitness_app/domain/entities/nutrition_entities/supplement_entity.dart';

class SupplementModel extends SupplementEntity {
  const SupplementModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.productLink,
    required super.dosage,
    required super.frequency,
    required super.time,
    required super.purpose,
    required super.note,
  });

  factory SupplementModel.fromJson(Map<String, dynamic> json) {
    return SupplementModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      productLink: json['productLink'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      time: json['time'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'brand': brand,
      'productLink': productLink,
      'dosage': dosage,
      'frequency': frequency,
      'time': time,
      'purpose': purpose,
      'note': note,
    };
  }
}

class SupplementResponseModel extends SupplementResponseEntity {
  const SupplementResponseModel({
    required super.items,
    required super.total,
    required super.page,
    required super.limit,
  });

  factory SupplementResponseModel.fromJson(Map<String, dynamic> json) {
    return SupplementResponseModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => SupplementModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }
}
