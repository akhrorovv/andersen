import 'package:andersen/features/auth/data/models/tokens_model.dart';
import 'package:andersen/features/auth/domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({required super.tokens, required super.deviceId});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      tokens: TokensModel.fromJson(json['tokens']),
      deviceId: json['deviceId'],
    );
  }
}
