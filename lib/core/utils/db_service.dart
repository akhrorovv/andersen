import 'package:andersen/features/home/data/models/user_model.dart';
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

  // 🔑 DeviceId saqlash
  static Future<void> saveDeviceId(String deviceId) async {
    await _box.put('deviceId', deviceId);
  }

  static String? get deviceId => _box.get('deviceId');

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
