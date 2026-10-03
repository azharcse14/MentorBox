import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// The daily streak reminder: one local notification at 8 PM on the next
/// day the learner has not studied yet. Rescheduled every time the home
/// screen loads, so studying today pushes it to tomorrow.
class Reminder {
  Reminder._();

  static const int _id = 1;
  static const int hour = 20;
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  /// Only phones get reminders.
  static bool get supported =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  static Future<void> _init() async {
    if (_ready) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  /// Asks the system for permission. False when the user said no.
  static Future<bool> requestPermission() async {
    if (!supported) return false;
    await _init();
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final granted =
        await android?.requestNotificationsPermission() ?? await ios?.requestPermissions(alert: true, sound: true);
    return granted ?? false;
  }

  static Future<void> schedule({
    required bool studiedToday,
    required String title,
    required String body,
  }) async {
    if (!supported) return;
    await _init();
    final now = DateTime.now();
    var at = DateTime(now.year, now.month, now.day, hour);
    if (studiedToday || !now.isBefore(at)) at = DateTime(now.year, now.month, now.day + 1, hour);
    // Local 8 PM converted to UTC, so no time zone database is needed.
    // ponytail: a time zone change before it fires shifts it; use
    // flutter_timezone + tz.local if that matters.
    await _plugin.zonedSchedule(
      id: _id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('daily_reminder', 'Daily reminder'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancel() async {
    if (!supported) return;
    await _init();
    await _plugin.cancel(id: _id);
  }
}
