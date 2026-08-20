import '../../../../usecase/usecase.dart';
import '../repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class VerifyOtpParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class VerifyOtpUseCase extends UseCase<void, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<String> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.email, params.otp);
  }
}
