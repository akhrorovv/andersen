import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration wrapper.
///
/// Usage:
/// - Development: `flutter run --dart-define=ENV=dev`
/// - Production: `flutter run --dart-define=ENV=prod`
/// - Default (no flag): uses `.env` file
class EnvConfig {
  static String get fileName {
    const env = String.fromEnvironment('ENV', defaultValue: '');
    switch (env) {
      case 'dev':
        return '.env.dev';
      case 'prod':
        return '.env.prod';
      default:
        return '.env';
    }
  }

  /// Initialize environment variables. Call this in main() before runApp().
  static Future<void> init() async {
    await dotenv.load(fileName: fileName);
  }

  /// Base URL for API requests
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// API version path
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'api/v1/mobile/';

  /// Check if we're in development mode
  static bool get isDev => fileName == '.env.dev';

  /// Check if we're in production mode
  static bool get isProd => fileName == '.env.prod' || fileName == '.env';
}
