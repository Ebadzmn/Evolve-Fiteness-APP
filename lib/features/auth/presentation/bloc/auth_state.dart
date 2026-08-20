import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthEntity authEntity;

  const AuthSuccess(this.authEntity);

  @override
  List<Object> get props => [authEntity];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class ForgetPasswordSuccess extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class OtpVerificationSuccess extends AuthState {}
