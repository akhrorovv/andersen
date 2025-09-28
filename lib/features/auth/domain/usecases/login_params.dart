import 'package:andersen/core/common/entities/device_entity.dart';

class LoginParams {
  final String phone;
  final String password;
  final DeviceEntity? device;

  const LoginParams({
    required this.phone,
    required this.password,
    this.device,
  });
}