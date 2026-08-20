import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String token;

  const AuthEntity({required this.token});

  @override
  List<Object?> get props => [token];
}
