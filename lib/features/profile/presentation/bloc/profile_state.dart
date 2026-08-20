import 'package:equatable/equatable.dart';
import '../../../../../../domain/entities/profile_entities/profile_entity.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;
  final bool isUpdatingImage;
  final String? successMessage;
  final String? tempImagePath;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.isUpdatingImage = false,
    this.successMessage,
    this.tempImagePath,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    bool? isUpdatingImage,
    String? successMessage,
    String? tempImagePath,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdatingImage: isUpdatingImage ?? this.isUpdatingImage,
      successMessage: successMessage,
      tempImagePath: tempImagePath ?? this.tempImagePath,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    errorMessage,
    isUpdatingImage,
    successMessage,
    tempImagePath,
  ];
}
