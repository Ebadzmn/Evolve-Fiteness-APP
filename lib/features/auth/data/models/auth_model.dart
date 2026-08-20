import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({required String token}) : super(token: token);

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(token: json['data']['token'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'token': token},
    };
  }
}
