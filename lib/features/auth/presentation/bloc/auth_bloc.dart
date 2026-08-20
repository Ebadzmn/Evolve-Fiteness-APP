import 'package:fitness_app/core/storage/token_storage.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/sync_nutrition_data_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_pkg;
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/forget_password_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final TokenStorage tokenStorage;
  final SyncNutritionDataUseCase syncNutritionDataUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.forgetPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.tokenStorage,
    required this.syncNutritionDataUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgetPasswordRequested>(_onForgetPasswordRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase(
        ResetPasswordParams(
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword,
        ),
      );
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await verifyOtpUseCase(
        VerifyOtpParams(email: event.email, otp: event.otp),
      );
      await tokenStorage.saveResetToken(token);
      emit(OtpVerificationSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onForgetPasswordRequested(
    ForgetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await forgetPasswordUseCase(ForgetPasswordParams(email: event.email));
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await tokenStorage.clearTokens();
    get_pkg.Get.deleteAll(force: true);
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      await syncNutritionDataUseCase();
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // final fcmToken = tokenStorage.getFcmToken();
      final result = await loginUseCase(
        LoginParams(
          email: event.email,
          password: event.password,
          // fcmToken: fcmToken,
        ),
      );
      await tokenStorage.saveAccessToken(result.token);

      await syncNutritionDataUseCase();

      emit(AuthSuccess(result));
    } catch (e) {
      String message = 'Login failed';

      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data['message'] is String) {
          final serverMessage = (data['message'] as String).trim();
          if (serverMessage.toLowerCase() ==
              'email already exists!'.toLowerCase()) {
            message = 'Invalid email or password';
          } else {
            message = serverMessage;
          }
        }
      } else {
        message = e.toString();
      }

      emit(AuthFailure(message));
    }
  }
}
