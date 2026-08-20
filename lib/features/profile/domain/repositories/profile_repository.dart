import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/profile_entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<ApiException, ProfileEntity>> getProfile();
  Future<Either<ApiException, ProfileEntity>> updateProfileImage(File image);
}
