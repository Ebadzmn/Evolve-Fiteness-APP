import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/profile_entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<ApiException, ProfileEntity>> call() async {
    return await repository.getProfile();
  }

  Future<Either<ApiException, ProfileEntity>> updateProfileImage(
    File image,
  ) async {
    return await repository.updateProfileImage(image);
  }
}
