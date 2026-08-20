import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthEntity> login(
    String email,
    String password, {
    String? fcmToken,
  }) async {
    try {
      final authModel = await remoteDataSource.login(
        email,
        password,
        // fcmToken: fcmToken,
      );
      return authModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgetPassword(String email) async {
    try {
      await remoteDataSource.forgetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    try {
      final token = await remoteDataSource.verifyOtp(email, otp);
      return token;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    try {
      await remoteDataSource.resetPassword(newPassword, confirmPassword);
    } catch (e) {
      rethrow;
    }
  }
}
