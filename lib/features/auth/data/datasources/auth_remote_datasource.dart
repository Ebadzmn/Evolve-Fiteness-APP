import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/auth_model.dart';
import '../../../../core/storage/token_storage.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
  Future<void> forgetPassword(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<void> resetPassword(String newPassword, String confirmPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.tokenStorage,
  });

  @override
  Future<AuthModel> login(
    String email,
    String password, {
    String? fcmToken,
  }) async {
    final response = await apiClient.post(
      ApiUrls.loginUrl,
      data: {
        'email': email,
        'password': password,
        if (fcmToken != null && fcmToken.isNotEmpty) 'fcmToken': fcmToken,
      },
    );

    return AuthModel.fromJson(response.data);
  }

  @override
  Future<void> forgetPassword(String email) async {
    await apiClient.post(ApiUrls.forgetPasswordUrl, data: {'email': email});
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    final response = await apiClient.post(
      ApiUrls.verifyEmailUrl,
      data: {'email': email, 'oneTimeCode': otp},
    );
    return response.data['data'];
  }

  @override
  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    final token = tokenStorage.getResetToken();
    await apiClient.post(
      ApiUrls.resetPasswordUrl,
      data: {'newPassword': newPassword, 'confirmPassword': confirmPassword},
      options: Options(headers: {'Authorization': '$token'}),
    );
  }
}
