import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String notificationChannelId = 'workout_timer_channel';
const int notificationId = 888;
const String _timerKeyPrefix = 'workout_timer';

String _encodePlanId(String planId) => Uri.encodeComponent(planId);

String _startTimeKey(String planId) =>
    '${_timerKeyPrefix}_${_encodePlanId(planId)}_start_time';

String _offsetSecondsKey(String planId) =>
    '${_timerKeyPrefix}_${_encodePlanId(planId)}_offset_seconds';

String _isRunningKey(String planId) =>
    '${_timerKeyPrefix}_${_encodePlanId(planId)}_is_running';

String _planIdFromTimerKey(String key) {
  final startPrefix = '${_timerKeyPrefix}_';
  if (!key.startsWith(startPrefix) || !key.endsWith('_is_running')) {
    return '';
  }
  final encodedPlanId = key
      .substring(startPrefix.length, key.length - '_is_running'.length);
  return Uri.decodeComponent(encodedPlanId);
}

final Map<String, Timer> _planTimers = {};

Future<void> _emitTimerUpdate(
  ServiceInstance service,
  SharedPreferences prefs,
  String planId,
) async {
  final startTimeStr = prefs.getString(_startTimeKey(planId));
  final offsetSeconds = prefs.getInt(_offsetSecondsKey(planId)) ?? 0;
  final isRunning = prefs.getBool(_isRunningKey(planId)) ?? false;

  int currentSeconds = offsetSeconds;
  if (startTimeStr != null) {
    final startTime = DateTime.parse(startTimeStr);
    currentSeconds += DateTime.now().difference(startTime).inSeconds;
  }

  service.invoke('update', {
    'planId': planId,
    'seconds': currentSeconds,
    'isRunning': isRunning,
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      service.setForegroundNotificationInfo(
        title: 'Workout Running',
        content: 'Time: ${_formatDuration(currentSeconds)}',
      );
    }
  }
}

Future<void> _startPlanTimer(
  ServiceInstance service,
  SharedPreferences prefs,
  String planId,
) async {
  _planTimers[planId]?.cancel();

  _planTimers[planId] = Timer.periodic(
    const Duration(seconds: 1),
    (t) => _emitTimerUpdate(service, prefs, planId),
  );
  await _emitTimerUpdate(service, prefs, planId);
}

Future<void> _pausePlanTimer(
  ServiceInstance service,
  SharedPreferences prefs,
  String planId,
) async {
  _planTimers[planId]?.cancel();
  _planTimers.remove(planId);

  final startTimeStr = prefs.getString(_startTimeKey(planId));
  final offsetSeconds = prefs.getInt(_offsetSecondsKey(planId)) ?? 0;

  if (startTimeStr != null) {
    final startTime = DateTime.parse(startTimeStr);
    final elapsedSinceStart = DateTime.now().difference(startTime).inSeconds;
    await prefs.setInt(
      _offsetSecondsKey(planId),
      offsetSeconds + elapsedSinceStart,
    );
    await prefs.remove(_startTimeKey(planId));
  }

  await prefs.setBool(_isRunningKey(planId), false);
  await _emitTimerUpdate(service, prefs, planId);
}

Future<void> _resetPlanTimer(
  ServiceInstance service,
  SharedPreferences prefs,
  String planId,
) async {
  _planTimers[planId]?.cancel();
  _planTimers.remove(planId);
  await prefs.remove(_startTimeKey(planId));
  await prefs.setInt(_offsetSecondsKey(planId), 0);
  await prefs.setBool(_isRunningKey(planId), false);

  service.invoke('update', {
    'planId': planId,
    'seconds': 0,
    'isRunning': false,
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'Workout Timer',
    description: 'This channel is used for workout timer notifications',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Workout Session',
      initialNotificationContent: 'Stopwatch is ready',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  final prefs = await SharedPreferences.getInstance();

  service.on('startTimer').listen((event) async {
    final planId = event?['planId']?.toString();
    if (planId == null || planId.isEmpty) return;

    final now = DateTime.now();
    await prefs.setString(_startTimeKey(planId), now.toIso8601String());
    await prefs.setBool(_isRunningKey(planId), true);

    await _startPlanTimer(service, prefs, planId);
  });

  service.on('pauseTimer').listen((event) async {
    final planId = event?['planId']?.toString();
    if (planId == null || planId.isEmpty) return;

    await _pausePlanTimer(service, prefs, planId);
  });

  service.on('resetTimer').listen((event) async {
    final planId = event?['planId']?.toString();
    if (planId == null || planId.isEmpty) return;

    await _resetPlanTimer(service, prefs, planId);
  });

  service.on('requestUpdate').listen((event) async {
    final planId = event?['planId']?.toString();
    if (planId == null || planId.isEmpty) return;

    await _emitTimerUpdate(service, prefs, planId);
  });

  // Resume any plan timers that were already running before the service restarted.
  final runningPlanIds = prefs
      .getKeys()
      .where(
        (key) =>
            key.startsWith('${_timerKeyPrefix}_') &&
            key.endsWith('_is_running'),
      )
      .where((key) => prefs.getBool(key) ?? false)
      .map(_planIdFromTimerKey)
      .where((planId) => planId.isNotEmpty)
      .toList();

  for (final planId in runningPlanIds) {
    await _startPlanTimer(service, prefs, planId);
  }
}

String _formatDuration(int seconds) {
  final h = (seconds ~/ 3600).toString().padLeft(2, '0');
  final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return "$h:$m:$s";
}
