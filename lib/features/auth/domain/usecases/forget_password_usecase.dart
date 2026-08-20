import '../../../../usecase/usecase.dart';
import '../repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class ForgetPasswordParams extends Equatable {
  final String email;

  const ForgetPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}

class ForgetPasswordUseCase extends UseCase<void, ForgetPasswordParams> {
  final AuthRepository repository;

  ForgetPasswordUseCase(this.repository);

  @override
  Future<void> call(ForgetPasswordParams params) async {
    return await repository.forgetPassword(params.email);
  }
}
