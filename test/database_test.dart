import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/data/app_database.dart';
import 'package:mentor_app_flutter/data/mentor_repository.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Seeds the real bundled content into a desktop SQLite file.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repo = MentorRepository.instance;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final file = File(p.join(await getDatabasesPath(), 'mentor_app.db'));
    if (file.existsSync()) file.deleteSync();
  });

  test('a failed first open is retried instead of failing forever', () async {
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMessageHandler('flutter/assets', (_) async => null);
    await expectLater(AppDatabase.instance.database, throwsA(anything));
    messenger.setMockMessageHandler('flutter/assets', null);
    expect(await AppDatabase.instance.database, isNotNull);
  });

  test('lessons without text are not seeded', () async {
    final overviews = await repo.getAllOverviews();
    expect(overviews.where((o) => o.total > 0), isNotEmpty);
    for (final o in overviews) {
      for (final level in o.levels) {
        expect(o.lessonsOf(level), isNotEmpty, reason: '${level.id} has no lessons');
      }
      for (final lesson in o.lessons) {
        expect((await repo.getLesson(lesson.id))!.content.trim(), isNotEmpty, reason: lesson.id);
      }
    }
  });

  test('saved lessons come in learning order, not id order', () async {
    final cse = (await repo.getOverview('cse-courses'))!;
    final firsts = [for (final level in cse.levels) cse.lessonsOf(level).first.id];
    // Bookmarked backwards, so insertion order cannot hide a wrong sort.
    for (final id in firsts.reversed) {
      await repo.setBookmarked(id, true);
    }
    expect([for (final l in await repo.getBookmarkedLessons()) l.id], firsts);
  });
}
