import 'dart:convert';
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

/// Copies the mentoring content from assets/content/mentors.json into SQLite.
///
/// It runs on every app start but only writes when the JSON's
/// "content_version" is higher than the version already stored, or when the
/// app language changed. To ship new lessons, edit both JSON files
/// (English and Bangla, same ids) and increase content_version by one.
class ContentSeeder {
  static const Map<String, String> contentAssets = {
    'en': 'assets/content/mentors.json',
    'bn': 'assets/content/mentors_bn.json',
  };
  static const String _versionKey = 'content_version';
  static const String _languageKey = 'content_language';
  /// The language picked in the app; missing means "follow the device".
  static const String appLanguageKey = 'app_language';

  /// The language picked in the app (null = device language). Set on every
  /// seed so MaterialApp switches before the home screen shows content.
  static final ValueNotifier<Locale?> appLocale = ValueNotifier(null);

  /// 'light' or 'dark' picked in the app; missing means "follow the device".
  static const String appThemeKey = 'app_theme';
  static final ValueNotifier<String?> appTheme = ValueNotifier(null);

  /// The first device language we have content for, like MaterialApp does.
  // ponytail: read once at startup; a language change while the app is
  // running shows up after the next restart.
  static String deviceLanguage() {
    for (final locale in PlatformDispatcher.instance.locales) {
      if (contentAssets.containsKey(locale.languageCode)) return locale.languageCode;
    }
    return 'en';
  }

  static Future<void> seedIfNeeded(Database db) async {
    final meta = {
      for (final row in await db.query('meta')) row['key'] as String: row['value'] as String,
    };
    final picked = contentAssets.containsKey(meta[appLanguageKey]) ? meta[appLanguageKey] : null;
    appLocale.value = picked == null ? null : Locale(picked);
    appTheme.value = meta[appThemeKey];
    final language = picked ?? deviceLanguage();

    final raw = await rootBundle.loadString(contentAssets[language]!);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final newVersion = json['content_version'] as int;

    final currentVersion = int.tryParse(meta[_versionKey] ?? '') ?? 0;
    if (currentVersion >= newVersion && meta[_languageKey] == language) return;

    await db.transaction((txn) async {
      // Only content tables are cleared. Learner progress is keyed by lesson
      // id, so it survives as long as lesson ids stay the same.
      await txn.delete('quiz_questions');
      await txn.delete('lessons');
      await txn.delete('levels');
      await txn.delete('categories');

      final batch = txn.batch();
      final categories = json['categories'] as List<dynamic>;

      for (var ci = 0; ci < categories.length; ci++) {
        final category = categories[ci] as Map<String, dynamic>;
        final categoryId = category['id'] as String;

        batch.insert('categories', {
          'id': categoryId,
          'name': category['name'],
          'mentor_name': category['mentor'],
          'tagline': category['tagline'],
          'description': category['description'],
          'image': category['image'],
          'color': _parseColor(category['color'] as String),
          'sort_order': ci,
          'messages': jsonEncode(category['messages'] ?? <String, String>{}),
        });

        final levels = category['levels'] as List<dynamic>;
        for (var li = 0; li < levels.length; li++) {
          final level = levels[li] as Map<String, dynamic>;
          final levelId = level['id'] as String;

          batch.insert('levels', {
            'id': levelId,
            'category_id': categoryId,
            'title': level['title'],
            'sort_order': li,
          });

          final lessons = level['lessons'] as List<dynamic>;
          for (var si = 0; si < lessons.length; si++) {
            final lesson = lessons[si] as Map<String, dynamic>;
            final lessonId = lesson['id'] as String;

            batch.insert('lessons', {
              'id': lessonId,
              'level_id': levelId,
              'category_id': categoryId,
              'title': lesson['title'],
              'duration_min': lesson['minutes'] ?? 5,
              'content': lesson['content'],
              'key_points': jsonEncode(lesson['key_points'] ?? <String>[]),
              'mentor_tip': lesson['tip'] ?? '',
              'task': lesson['task'] ?? '',
              'sort_order': si,
            });

            final quiz = (lesson['quiz'] as List<dynamic>?) ?? <dynamic>[];
            for (var qi = 0; qi < quiz.length; qi++) {
              final question = quiz[qi] as Map<String, dynamic>;
              batch.insert('quiz_questions', {
                'lesson_id': lessonId,
                'question': question['q'],
                'options': jsonEncode(question['options']),
                'answer_index': question['answer'],
                'explanation': question['explain'] ?? '',
                'sort_order': qi,
              });
            }
          }
        }
      }

      batch.insert(
        'meta',
        {'key': _versionKey, 'value': '$newVersion'},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      batch.insert(
        'meta',
        {'key': _languageKey, 'value': language},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await batch.commit(noResult: true);
    });
  }

  /// "#5E8C8A" -> 0xFF5E8C8A
  static int _parseColor(String hex) {
    final value = int.parse(hex.replaceFirst('#', ''), radix: 16);
    return hex.length <= 7 ? (0xFF000000 | value) : value;
  }
}
