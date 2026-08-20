import 'package:equatable/equatable.dart';
import '../../../../usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<void> call(ResetPasswordParams params) async {
    return await repository.resetPassword(
      params.newPassword,
      params.confirmPassword,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordParams({
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [newPassword, confirmPassword];
}
