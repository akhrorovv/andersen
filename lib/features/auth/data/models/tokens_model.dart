import 'package:andersen/features/auth/domain/entities/tokens.dart';

class TokensModel extends TokensEntity {
  const TokensModel({required super.access, required super.refresh});

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(access: json['access'], refresh: json['refresh']);
  }

  Map<String, dynamic> toJson() => {"access": access, "refresh": refresh};
}
