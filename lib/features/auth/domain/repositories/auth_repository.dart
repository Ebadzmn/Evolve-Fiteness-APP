import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(String email, String password, {String? fcmToken});
  Future<void> forgetPassword(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<void> resetPassword(String newPassword, String confirmPassword);
}
