import 'package:equatable/equatable.dart';

class SupplementEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String productLink;
  final String dosage;
  final String frequency;
  final String time;
  final String purpose;
  final String note;

  const SupplementEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.productLink,
    required this.dosage,
    required this.frequency,
    required this.time,
    required this.purpose,
    required this.note,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    brand,
    productLink,
    dosage,
    frequency,
    time,
    purpose,
    note,
  ];
}

class SupplementResponseEntity extends Equatable {
  final List<SupplementEntity> items;
  final int total;
  final int page;
  final int limit;

  const SupplementResponseEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [items, total, page, limit];
}
