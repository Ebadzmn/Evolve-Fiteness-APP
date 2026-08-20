import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/api_client.dart';
import '../apiUrls/api_urls.dart';
import '../storage/token_storage.dart';
import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class FcmService {
  final TokenStorage tokenStorage;
  final ApiClient apiClient;
  final FlutterLocalNotificationsPlugin _localNotifications;

  bool _initialized = false;

  FcmService({
    required this.tokenStorage,
    required this.apiClient,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (_initialized) return;

    await _initLocalNotifications();

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _getFcmToken(messaging);
    print("----------------------------------------------------------------");
    print("FCM Token: $token");
    print("----------------------------------------------------------------");
    await _saveAndSyncToken(token);

    messaging.onTokenRefresh.listen((token) async {
      print("FCM Token Refreshed: $token");
      await _saveAndSyncToken(token);
    });

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }

    await checkLatestNoteNotification();

    _initialized = true;
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();

    const settings = InitializationSettings(android: androidInit, iOS: iOSInit);

    await _localNotifications.initialize(settings: settings);

    if (defaultTargetPlatform == TargetPlatform.android) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Used for important notifications.',
        importance: Importance.high,
      );

      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.createNotificationChannel(channel);
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final payload = message.data.isEmpty ? null : jsonEncode(message.data);

    await _localNotifications.show(
      id: id,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {}
  Future<void> checkLatestNoteNotification() async {
    try {
      final accessToken = tokenStorage.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) return;

      final profileResponse = await apiClient.get('${ApiUrls.baseUrl}/profile');
      if (profileResponse.data['success'] != true) return;

      final profileData =
          profileResponse.data['data'] as Map<String, dynamic>? ?? {};
      final athlete = profileData['athlete'] as Map<String, dynamic>? ?? {};
      final athleteId = athlete['_id'] as String? ?? '';
      if (athleteId.isEmpty) return;

      final notesResponse =
          await apiClient.get(ApiUrls.athleteNotes(athleteId));
      if (notesResponse.data['success'] != true) return;

      final List<dynamic> data =
          notesResponse.data['data'] as List<dynamic>? ?? [];
      if (data.isEmpty) return;

      final latest =
          data.first as Map<String, dynamic>; // API already sorted by time
      final latestCreatedAt = latest['createdAt'] as String? ?? '';
      if (latestCreatedAt.isEmpty) return;

      final lastNotified = tokenStorage.getLastNotifiedNoteTime();
      if (lastNotified != null && lastNotified == latestCreatedAt) {
        return;
      }

      final noteText = latest['note'] as String? ?? '';
      if (noteText.isEmpty) return;

      final preview =
          noteText.length <= 100 ? noteText : '${noteText.substring(0, 100)}...';

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _localNotifications.show(
        id: id,
        title: 'New Note',
        body: preview,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'Used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );

      await tokenStorage.saveLastNotifiedNoteTime(latestCreatedAt);
    } catch (_) {}
  }

  Future<String?> _getFcmToken(FirebaseMessaging messaging) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      for (var attempt = 0; attempt < 10; attempt++) {
        try {
          final apnsToken = await messaging.getAPNSToken();
          if (apnsToken != null && apnsToken.isNotEmpty) {
            break;
          }
        } catch (_) {}
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    try {
      return await messaging.getToken();
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }

  Future<void> _saveAndSyncToken(String? token) async {
    if (token == null || token.isEmpty) return;

    final existing = tokenStorage.getFcmToken();
    if (existing == token) return;

    await tokenStorage.saveFcmToken(token);

    final accessToken = tokenStorage.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) return;

    await _syncTokenToBackend(token);
  }

  Future<void> _syncTokenToBackend(String token) async {
    try {
      await apiClient.post(
        ApiUrls.updateFcmTokenUrl,
        data: {'fcmToken': token},
      );
    } catch (_) {}
  }
}
