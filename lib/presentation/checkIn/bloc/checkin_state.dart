import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkin_entities/check_in_entity.dart';
import '../../../domain/entities/checkin_entities/check_in_date_entity.dart';
import '../../../domain/entities/checkin_entities/old_check_in_entity.dart';

enum CheckInViewTab { weekly, old }

enum CheckInStatus { initial, loading, ready, saving, saved, error }

class CheckInState extends Equatable {
  final CheckInStatus status;
  final CheckInEntity? data;
  final CheckInDateEntity? checkInDate;
  final String? errorMessage;
  final CheckInViewTab tab;
  final OldCheckInEntity? oldCheckIn;
  final int skip;
  final bool isSubmitted;

  const CheckInState({
    this.status = CheckInStatus.initial,
    this.data,
    this.checkInDate,
    this.errorMessage,
    this.tab = CheckInViewTab.weekly,
    this.oldCheckIn,
    this.skip = 0,
    this.isSubmitted = false,
  });

  CheckInState copyWith({
    CheckInStatus? status,
    CheckInEntity? data,
    CheckInDateEntity? checkInDate,
    String? errorMessage,
    CheckInViewTab? tab,
    OldCheckInEntity? oldCheckIn,
    int? skip,
    bool? isSubmitted,
  }) => CheckInState(
    status: status ?? this.status,
    data: data ?? this.data,
    checkInDate: checkInDate ?? this.checkInDate,
    errorMessage: errorMessage ?? this.errorMessage,
    tab: tab ?? this.tab,
    oldCheckIn: oldCheckIn ?? this.oldCheckIn,
    skip: skip ?? this.skip,
    isSubmitted: isSubmitted ?? this.isSubmitted,
  );

  @override
  List<Object?> get props => [
    status,
    data,
    checkInDate,
    errorMessage,
    tab,
    oldCheckIn,
    skip,
    isSubmitted,
  ];
}
