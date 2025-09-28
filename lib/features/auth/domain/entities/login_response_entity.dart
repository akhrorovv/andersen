import 'package:andersen/features/auth/domain/entities/tokens.dart';

class LoginResponseEntity {
  final TokensEntity tokens;
  final String deviceId;

  const LoginResponseEntity({required this.tokens, required this.deviceId});
}
