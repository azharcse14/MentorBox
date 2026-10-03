import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/logic/reminder.dart';

void main() {
  // 3 PM on a Monday.
  final now = DateTime(2026, 10, 5, 15);
  List<(int, int, Nudge)> plan({required bool studiedToday, required int streak, int hour = 20}) =>
      Reminder.plan(now: now, studiedToday: studiedToday, streak: streak, hour: hour)
          .map((n) => (n.at.difference(DateTime(2026, 10, 5)).inDays, n.at.hour, n.kind))
          .toList();

  test('studied today: nothing today, streak at risk tomorrow, lost the day after', () {
    final p = plan(studiedToday: true, streak: 5);
    expect(p.where((n) => n.$1 == 0), isEmpty);
    expect(p.take(3), [(1, 20, Nudge.practice), (1, 22, Nudge.streakRisk), (2, 20, Nudge.streakLost)]);
  });

  test('streak alive from yesterday: practice and risk today, lost tomorrow', () {
    final p = plan(studiedToday: false, streak: 3);
    expect(p.take(3), [(0, 20, Nudge.practice), (0, 22, Nudge.streakRisk), (1, 20, Nudge.streakLost)]);
  });

  test('no streak: daily for a week, then thinning out, last call on day 30', () {
    final p = plan(studiedToday: false, streak: 0);
    expect(p.any((n) => n.$3 == Nudge.streakRisk || n.$3 == Nudge.streakLost), isFalse);
    expect(p.map((n) => n.$1), [0, 1, 2, 3, 4, 5, 6, 7, 10, 14, 21, 30]);
    expect(p.last.$3, Nudge.lastCall);
    expect(p.where((n) => n.$3 == Nudge.comeback).map((n) => n.$1), [1, 5, 10, 14, 21]);
  });

  test('times already past today are skipped', () {
    final p = Reminder.plan(now: DateTime(2026, 10, 5, 23), studiedToday: false, streak: 2);
    expect(p.first.at.isAfter(DateTime(2026, 10, 5, 23)), isTrue);
    expect(p.first.kind, Nudge.streakLost);
  });

  test('a late reminder time skips the separate risk nudge', () {
    final p = plan(studiedToday: false, streak: 3, hour: 22);
    expect(p.where((n) => n.$3 == Nudge.streakRisk), isEmpty);
  });
}
