import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthCheckRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class ForgetPasswordRequested extends AuthEvent {
  final String email;

  const ForgetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpRequested({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String newPassword;
  final String confirmPassword;

  const AuthResetPasswordRequested({
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [newPassword, confirmPassword];
}
