import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'content_seeder.dart';

/// Opens the local SQLite database once and shares it across the app.
///
/// Two kinds of tables live here:
/// - content tables (categories, levels, lessons, quiz_questions), filled
///   from assets/content/ and refreshed when its version changes
/// - learner tables (lesson_progress, category_state, activity_days, meta),
///   which are never touched by a content refresh
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const String _fileName = 'mentor_app.db';
  static const int _schemaVersion = 2;

  Future<Database>? _database;

  Future<Database> get database => _database ??= _open();

  Future<Database> _open() async {
    final directory = await getDatabasesPath();
    final db = await openDatabase(
      p.join(directory, _fileName),
      version: _schemaVersion,
      onCreate: (db, version) async {
        for (final statement in _schema) {
          await db.execute(statement);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // 2: levels can be grouped into sections inside a category.
        if (oldVersion < 2) await db.execute("ALTER TABLE levels ADD COLUMN section TEXT NOT NULL DEFAULT ''");
      },
    );
    await ContentSeeder.seedIfNeeded(db);
    return db;
  }

  static const List<String> _schema = [
    '''
    CREATE TABLE categories (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      mentor_name TEXT NOT NULL,
      tagline TEXT NOT NULL,
      description TEXT NOT NULL,
      image TEXT NOT NULL,
      color INTEGER NOT NULL,
      sort_order INTEGER NOT NULL,
      messages TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE levels (
      id TEXT PRIMARY KEY,
      category_id TEXT NOT NULL,
      title TEXT NOT NULL,
      section TEXT NOT NULL DEFAULT '',
      sort_order INTEGER NOT NULL
    )
    ''',
    '''
    CREATE TABLE lessons (
      id TEXT PRIMARY KEY,
      level_id TEXT NOT NULL,
      category_id TEXT NOT NULL,
      title TEXT NOT NULL,
      duration_min INTEGER NOT NULL,
      content TEXT NOT NULL,
      key_points TEXT NOT NULL,
      mentor_tip TEXT NOT NULL,
      task TEXT NOT NULL,
      sort_order INTEGER NOT NULL
    )
    ''',
    '''
    CREATE TABLE quiz_questions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      lesson_id TEXT NOT NULL,
      question TEXT NOT NULL,
      options TEXT NOT NULL,
      answer_index INTEGER NOT NULL,
      explanation TEXT NOT NULL,
      sort_order INTEGER NOT NULL
    )
    ''',
    '''
    CREATE TABLE lesson_progress (
      lesson_id TEXT PRIMARY KEY,
      completed INTEGER NOT NULL DEFAULT 0,
      task_done INTEGER NOT NULL DEFAULT 0,
      best_score INTEGER NOT NULL DEFAULT 0,
      attempts INTEGER NOT NULL DEFAULT 0,
      notes TEXT NOT NULL DEFAULT '',
      bookmarked INTEGER NOT NULL DEFAULT 0,
      completed_at TEXT
    )
    ''',
    '''
    CREATE TABLE category_state (
      category_id TEXT PRIMARY KEY,
      started_at TEXT NOT NULL,
      last_active_at TEXT NOT NULL
    )
    ''',
    'CREATE TABLE activity_days (day TEXT PRIMARY KEY)',
    'CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
    'CREATE INDEX idx_levels_category ON levels(category_id)',
    'CREATE INDEX idx_lessons_category ON lessons(category_id)',
    'CREATE INDEX idx_quiz_lesson ON quiz_questions(lesson_id)',
  ];
}
