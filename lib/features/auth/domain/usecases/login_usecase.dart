import '../../../../usecase/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase extends UseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<AuthEntity> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}
