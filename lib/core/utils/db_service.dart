import 'package:andersen/core/common/models/user_model.dart';
import 'package:hive/hive.dart';

class DBService {
  static final Box _box = Hive.box('appBox');

  // 🔑 Tokenlarni saqlash
  static Future<void> saveTokens(String access, String refresh) async {
    await _box.put('accessToken', access);
    await _box.put('refreshToken', refresh);
  }

  static String? get accessToken => _box.get('accessToken');

  static String? get refreshToken => _box.get('refreshToken');

  // 🌐 Language (locale) saqlash
  static Future<void> saveLocale(String locale) async {
    await _box.put('locale', locale);
  }

// 🌐 Language (locale) olish
  static String get locale => _box.get('locale', defaultValue: 'ru');


  // 🔔 Notifications status saqlash
  static Future<void> saveNotifStatus(bool enabled) async {
    await _box.put('notifEnabled', enabled);
  }

  static bool get notifEnabled => _box.get('notifEnabled', defaultValue: true);

  // 🔑 DeviceId saqlash
  static Future<void> saveDeviceId(String deviceId) async {
    await _box.put('deviceId', deviceId);
  }

  static String? get deviceId => _box.get('deviceId');

  // 🔑 Device model saqlash
  static Future<void> saveDeviceModel(String model) async {
    await _box.put('deviceModel', model);
  }

  static String? get deviceModel => _box.get('deviceModel');

  // 🔑 Device version saqlash
  static Future<void> saveDeviceVersion(String version) async {
    await _box.put('deviceVersion', version);
  }

  static String? get deviceVersion => _box.get('deviceVersion');

  // 🔑 PIN saqlash
  static Future<void> savePin(String pin) async {
    await _box.put('pin', pin);
  }

  // 🔑 User ma'lumotlarini saqlash
  static Future<void> saveUser(UserModel user) async {
    await _box.put('user', user.toJson());
  }

  static UserModel? get user {
    final data = _box.get('user');
    if (data != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  static String? get pin => _box.get('pin');

  // 🔑 Logout (hamma narsani tozalash)
  static Future<void> clear() async {
    await _box.clear();
  }
}
