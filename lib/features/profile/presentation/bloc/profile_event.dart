import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileImageUpdateRequested extends ProfileEvent {
  final File image;

  const ProfileImageUpdateRequested(this.image);

  @override
  List<Object?> get props => [image];
}
