import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_plan_repository.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_app/features/training/data/datasources/training_remote_datasource.dart';
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';

class TrainingRepositoryImpl implements TrainingPlanRepository {
  final TrainingRemoteDataSource remoteDataSource;
  final GetProfileUseCase getProfile;

  TrainingRepositoryImpl({
    required this.remoteDataSource,
    required this.getProfile,
  });

  @override
  Future<Either<ApiException, List<TrainingPlanEntity>>>
  getTrainingPlans() async {
    try {
      final profileResult = await getProfile();
      return await profileResult.fold((failure) => Left(failure), (
        profile,
      ) async {
        final result = await remoteDataSource.getTrainingPlans(
          profile.athlete.id,
        );
        return Right(result);
      });
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, TrainingPlanEntity>> getTrainingPlanById(
    String id,
  ) async {
    try {
      final result = await remoteDataSource.getTrainingPlanById(id);
      return Right(result);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, void>> saveTrainingHistory(
    TrainingHistoryRequest request,
  ) async {
    try {
      await remoteDataSource.saveTrainingHistory(request);
      return const Right(null);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
