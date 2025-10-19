import 'package:andersen/core/common/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DBService {
  // Hive box instance
  static final Box _box = Hive.box('appBox');

  // ============================================================
  // 🔑 TOKENS
  // ============================================================

  /// Save access and refresh tokens
  static Future<void> saveTokens(String access, String refresh) async {
    await _box.put('accessToken', access);
    await _box.put('refreshToken', refresh);
  }

  /// Get access token
  static String? get accessToken => _box.get('accessToken');

  /// Get refresh token
  static String? get refreshToken => _box.get('refreshToken');

  // ============================================================
  // 🔐 PIN
  // ============================================================

  /// Save user PIN
  static Future<void> savePin(String pin) async {
    await _box.put('pin', pin);
  }

  /// Get user PIN
  static String? get pin => _box.get('pin');

  // ============================================================
  // 👆 BIOMETRIC
  // ============================================================

  /// Save biometric authentication status
  static Future<void> saveBiometricStatus(bool enabled) async {
    await _box.put('biometric', enabled);
  }

  /// Get biometric authentication status (default: false)
  static bool get biometricEnabled => _box.get('biometric', defaultValue: false);

  // ============================================================
  // 🌐 LANGUAGE / LOCALE
  // ============================================================

  /// Save selected language (locale)
  static Future<void> saveLocale(String locale) async {
    await _box.put('locale', locale);
  }

  /// Get saved locale (default: 'ru')
  static String get locale => _box.get('locale', defaultValue: 'ru');

  // ============================================================
  // 🔔 NOTIFICATION STATUS
  // ============================================================

  /// Save notification toggle status
  static Future<void> saveNotifStatus(bool enabled) async {
    await _box.put('notifEnabled', enabled);
  }

  /// Get notification status (default: true)
  static bool get notifEnabled => _box.get('notifEnabled', defaultValue: true);

  // ============================================================
  // 🔔 FCM TOKEN
  // ============================================================

  /// Save Firebase Cloud Messaging (FCM) token
  static Future<void> saveFCMToken(String token) async {
    await _box.put('fcmToken', token);
  }

  /// Get FCM token
  static String? get fcmToken => _box.get('fcmToken');

  // ============================================================
  // 📱 DEVICE INFO
  // ============================================================

  /// Save device ID
  static Future<void> saveDeviceId(String deviceId) async {
    await _box.put('deviceId', deviceId);
  }

  /// Get device ID
  static String? get deviceId => _box.get('deviceId');

  /// Save device model
  static Future<void> saveDeviceModel(String model) async {
    await _box.put('deviceModel', model);
  }

  /// Get device model
  static String? get deviceModel => _box.get('deviceModel');

  /// Save device version
  static Future<void> saveDeviceVersion(String version) async {
    await _box.put('deviceVersion', version);
  }

  /// Get device version
  static String? get deviceVersion => _box.get('deviceVersion');

  // ============================================================
  // 👤 USER DATA
  // ============================================================

  /// Save user information as JSON
  static Future<void> saveUser(UserModel user) async {
    await _box.put('user', user.toJson());
  }

  /// Get user information (returns null if not found)
  static UserModel? get user {
    final data = _box.get('user');
    if (data != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // ============================================================
  // 🔓 CLEAR / LOGOUT
  // ============================================================

  /// Clear all data stored in Hive (used for logout or reset)
  static Future<void> clear() async {
    await _box.clear();
  }
}
