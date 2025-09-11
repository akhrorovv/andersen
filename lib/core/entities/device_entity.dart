class DeviceEntity {
  final String? model;
  final String? version;
  final String? locale;
  final String? fcmToken;

  DeviceEntity({
    required this.model,
    required this.version,
    required this.locale,
    required this.fcmToken,
  });
}
