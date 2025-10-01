import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  await NotifService.instance.showNotification(message);
}

class NotifService {
  NotifService._();

  static final NotifService instance = NotifService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    // background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // permission so‘rash
    await _requestPermission();

    // local notification setup
    await setupFlutterNotifications();

    // FCM token olish
    try {
      final token = await _messaging.getToken();
      log("FCM TOKEN: $token");
      // DBService.saveFCMToken(token.toString());
    } catch (e) {
      log("FCM token olishda xatolik: $e");
    }

    // FCM token yangilanishi
    _messaging.onTokenRefresh.listen((newToken) {
      log("FCM TOKEN (onRefresh): $newToken");
      // serverga yuborish yoki localda saqlash mumkin
    });

    // foreground, background, initial handlers
    await _setupMessageHandlers();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log("Permission status: ${settings.authorizationStatus}");
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    // android channel
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
    AndroidInitializationSettings('mipmap/ic_launcher');

    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final data = jsonDecode(details.payload!);
          _handleNotificationTap(data);
        }
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    // faqat data payload ishlatamiz
    final data = message.data;
    if (data.isEmpty) return;

    final title = data['title'] ?? 'No Title';
    final body = data['body'] ?? 'No Body';

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
          'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  Future<void> _setupMessageHandlers() async {
    // foreground message
    FirebaseMessaging.onMessage.listen(showNotification);

    // notification bosilganda app backgrounddan ochilsa
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // notification bosilganda app yopiqdan ochilsa
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      _handleNotificationTap(message.data);
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    if (data['type'] == 'chat') {
      log("CHAT SCREENGA YO‘NALTIRISH: ${data['chatId']}");
      // NavigatorService.navigateToChat(data['chatId']);
    }
    // boshqa type’lar uchun ham yozish mumkin
  }
}
