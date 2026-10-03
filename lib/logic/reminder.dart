import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/content_seeder.dart';
import '../data/mentor_repository.dart';
import '../l10n/app_localizations.dart';
import 'mentor_engine.dart';

/// The kinds of nudges, roughly like Duolingo's.
enum Nudge {
  /// "Time for today's lesson", at the learner's reminder time.
  practice,

  /// "Your streak ends at midnight", late on a day the streak could break.
  streakRisk,

  /// "Your streak ended", the day after it broke.
  streakLost,

  /// "Your mentors miss you", after a few days away.
  comeback,

  /// "We'll pause your reminders", the last one after a month away.
  lastCall,
}

typedef PlannedNudge = ({DateTime at, Nudge kind});

/// Streak reminders as local notifications. The system shows them on time
/// even when the app is closed, because the next 30 days are scheduled up
/// front. They are rescheduled whenever the app opens or the learner
/// studies, so a day with a lesson never gets a "come back" message.
class Reminder {
  Reminder._();

  /// Late check for a streak that would break at midnight.
  static const int riskHour = 22;

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;
  static Future<void> _queue = Future.value();

  /// Only phones get reminders.
  static bool get supported =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  /// What to send and when, if the learner does not study again.
  /// [streak] counts today when [studiedToday], else ends yesterday.
  static List<PlannedNudge> plan({
    required DateTime now,
    required bool studiedToday,
    required int streak,
    int hour = 20,
    int minute = 0,
  }) {
    DateTime on(int day, int h, int m) => DateTime(now.year, now.month, now.day + day, h, m);
    final list = <PlannedNudge>[];
    void add(int day, Nudge kind, [int? h]) =>
        list.add((at: h == null ? on(day, hour, minute) : on(day, h, 0), kind: kind));

    // The day the streak breaks at midnight if nothing happens: today when
    // it is alive from yesterday, tomorrow when today already counts.
    final riskDay = streak == 0 ? null : (studiedToday ? 1 : 0);
    // Days since the last lesson, counted on day d.
    int away(int d) => studiedToday ? d : (streak > 0 ? d + 1 : d + 2);

    for (var d = studiedToday ? 1 : 0; d <= 30; d++) {
      if (d == riskDay) {
        add(d, Nudge.practice);
        if (hour < riskHour) add(d, Nudge.streakRisk, riskHour);
      } else if (riskDay != null && d == riskDay + 1) {
        add(d, Nudge.streakLost);
      } else if (d == 30) {
        add(d, Nudge.lastCall);
      } else if (d <= 7 || d == 10 || d == 14 || d == 21) {
        // Daily for a week, then thinning out, like Duolingo.
        final a = away(d);
        add(d, a == 3 || a == 7 || d >= 10 ? Nudge.comeback : Nudge.practice);
      }
    }
    return list.where((n) => n.at.isAfter(now)).toList();
  }

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

  /// Replaces all scheduled reminders with a fresh plan. Safe to call often;
  /// calls run one after another so they never mix their schedules.
  static Future<void> refresh() => _queue = _queue.then((_) => _refresh());

  static Future<void> _refresh() async {
    if (!supported) return;
    try {
      await _init();
      await _plugin.cancelAll();
      final repo = MentorRepository.instance;
      if (!await repo.getReminderOn()) return;

      final (hour, minute) = await repo.getReminderTime();
      final days = await repo.getActivityDays();
      final now = DateTime.now();
      final nudges = plan(
        now: now,
        studiedToday: days.contains(MentorEngine.dayKey(now)),
        streak: MentorEngine.streak(days, now),
        hour: hour,
        minute: minute,
      );

      // The mentor you worked with last, and where you stopped.
      final current = (await repo.getAllOverviews())
          .where((o) => o.started && !o.finished && o.nextLesson != null)
          .fold<CategoryOverview?>(
              null, (best, o) => best == null || o.state!.lastActiveAt.isAfter(best.state!.lastActiveAt) ? o : best);
      final mentor = current?.category.mentorName;
      final lesson = current?.nextLesson;

      final l = lookupAppLocalizations(ContentSeeder.appLocale.value ?? Locale(ContentSeeder.deviceLanguage()));
      final streak = MentorEngine.streak(days, now);
      final details = NotificationDetails(
        android: AndroidNotificationDetails('daily_reminder', l.dailyReminder),
        iOS: const DarwinNotificationDetails(),
      );

      for (var i = 0; i < nudges.length; i++) {
        final n = nudges[i];
        final (title, body) = switch (n.kind) {
          Nudge.practice => (
              l.notifPracticeTitle,
              lesson == null ? l.notifGenericBody : l.notifPracticeBody(mentor!, lesson.title, lesson.durationMin),
            ),
          // On the risk day the streak still counts what was done so far.
          Nudge.streakRisk => (l.notifStreakRiskTitle(streak), l.notifStreakRiskBody),
          Nudge.streakLost => (l.notifStreakLostTitle(streak), l.notifStreakLostBody),
          Nudge.comeback => (
              l.notifComebackTitle,
              lesson == null ? l.notifGenericBody : l.notifComebackBody(mentor!, lesson.title),
            ),
          Nudge.lastCall => (l.notifLastCallTitle, l.notifLastCallBody),
        };
        // Local time converted to UTC, so no time zone database is needed.
        // ponytail: a time zone change shifts pending ones until the next
        // app open; use flutter_timezone + tz.local if that matters.
        await _plugin.zonedSchedule(
          id: i + 1,
          title: title,
          body: body,
          scheduledDate: tz.TZDateTime.from(n.at.toUtc(), tz.UTC),
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (e) {
      // Reminders must never break learning.
      debugPrint('Reminder refresh failed: $e');
    }
  }
}
