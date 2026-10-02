import 'package:sqflite/sqflite.dart';

import '../logic/mentor_engine.dart';
import 'app_database.dart';
import 'models.dart';

/// The only place the UI talks to the database.
/// If you move to a backend later, only this class has to change.
class MentorRepository {
  MentorRepository._();
  static final MentorRepository instance = MentorRepository._();

  Future<Database> get _db => AppDatabase.instance.database;

  // ---------------------------------------------------------------- profile

  Future<String?> getUserName() async {
    final db = await _db;
    final rows = await db.query('meta', where: 'key = ?', whereArgs: ['user_name']);
    if (rows.isEmpty) return null;
    final name = (rows.first['value'] as String).trim();
    return name.isEmpty ? null : name;
  }

  Future<void> setUserName(String name) async {
    final db = await _db;
    await db.insert(
      'meta',
      {'key': 'user_name', 'value': name.trim()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ---------------------------------------------------------------- content

  Future<List<MentorCategory>> getCategories() async {
    final db = await _db;
    final rows = await db.query('categories', orderBy: 'sort_order');
    return rows.map((r) => MentorCategory.fromRow(r)).toList();
  }

  Future<MentorCategory?> getCategory(String id) async {
    final db = await _db;
    final rows = await db.query('categories', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : MentorCategory.fromRow(rows.first);
  }

  Future<Lesson?> getLesson(String id) async {
    final db = await _db;
    final rows = await db.query('lessons', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Lesson.fromRow(rows.first);
  }

  Future<List<QuizQuestion>> getQuiz(String lessonId) async {
    final db = await _db;
    final rows = await db.query(
      'quiz_questions',
      where: 'lesson_id = ?',
      whereArgs: [lessonId],
      orderBy: 'sort_order',
    );
    return rows.map((r) => QuizQuestion.fromRow(r)).toList();
  }

  /// Every category with its levels, lessons and the learner's progress.
  Future<List<CategoryOverview>> getAllOverviews() async {
    final db = await _db;
    final categories = await getCategories();
    final levelRows = await db.query('levels', orderBy: 'sort_order');
    final lessonRows = await db.rawQuery('''
      SELECT l.* FROM lessons l
      JOIN levels v ON v.id = l.level_id
      ORDER BY v.sort_order, l.sort_order
    ''');
    final progress = await _progressMap(db);
    final states = await _categoryStates(db);

    final levels = levelRows.map((r) => Level.fromRow(r)).toList();
    final lessons = lessonRows.map((r) => Lesson.fromRow(r)).toList();

    return [
      for (final category in categories)
        CategoryOverview(
          category: category,
          levels: levels.where((v) => v.categoryId == category.id).toList(),
          lessons: lessons.where((l) => l.categoryId == category.id).toList(),
          progress: progress,
          state: states[category.id],
        ),
    ];
  }

  Future<CategoryOverview?> getOverview(String categoryId) async {
    final all = await getAllOverviews();
    for (final overview in all) {
      if (overview.category.id == categoryId) return overview;
    }
    return null;
  }

  Future<List<Lesson>> getBookmarkedLessons() async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT l.* FROM lessons l
      JOIN lesson_progress p ON p.lesson_id = l.id
      WHERE p.bookmarked = 1
      ORDER BY l.category_id, l.level_id, l.sort_order
    ''');
    return rows.map((r) => Lesson.fromRow(r)).toList();
  }

  Future<List<Lesson>> getLessonsWithNotes() async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT l.* FROM lessons l
      JOIN lesson_progress p ON p.lesson_id = l.id
      WHERE p.notes <> ''
      ORDER BY l.category_id, l.level_id, l.sort_order
    ''');
    return rows.map((r) => Lesson.fromRow(r)).toList();
  }

  // --------------------------------------------------------------- progress

  Future<LessonProgress> getProgress(String lessonId) async {
    final db = await _db;
    final rows = await db.query('lesson_progress', where: 'lesson_id = ?', whereArgs: [lessonId]);
    return rows.isEmpty ? LessonProgress.empty(lessonId) : LessonProgress.fromRow(rows.first);
  }

  Future<void> setTaskDone(String lessonId, String categoryId, bool done) async {
    final db = await _db;
    await db.transaction((txn) async {
      await _ensureProgressRow(txn, lessonId);
      await txn.update(
        'lesson_progress',
        {'task_done': done ? 1 : 0},
        where: 'lesson_id = ?',
        whereArgs: [lessonId],
      );
      if (done) await _recordActivity(txn, categoryId);
    });
  }

  Future<void> setBookmarked(String lessonId, bool bookmarked) async {
    final db = await _db;
    await _ensureProgressRow(db, lessonId);
    await db.update(
      'lesson_progress',
      {'bookmarked': bookmarked ? 1 : 0},
      where: 'lesson_id = ?',
      whereArgs: [lessonId],
    );
  }

  Future<void> saveNotes(String lessonId, String notes) async {
    final db = await _db;
    await _ensureProgressRow(db, lessonId);
    await db.update(
      'lesson_progress',
      {'notes': notes},
      where: 'lesson_id = ?',
      whereArgs: [lessonId],
    );
  }

  /// Saves a quiz attempt. A passed quiz completes the lesson; a failed one
  /// never un-completes a lesson that was already passed before.
  Future<LessonProgress> recordQuizAttempt({
    required String lessonId,
    required String categoryId,
    required int score,
    required bool passed,
  }) async {
    final db = await _db;
    final passedFlag = passed ? 1 : 0;
    await db.transaction((txn) async {
      await _ensureProgressRow(txn, lessonId);
      await txn.rawUpdate('''
        UPDATE lesson_progress
        SET attempts = attempts + 1,
            best_score = MAX(best_score, ?),
            completed = CASE WHEN ? = 1 THEN 1 ELSE completed END,
            completed_at = CASE WHEN ? = 1 AND completed_at IS NULL THEN ? ELSE completed_at END
        WHERE lesson_id = ?
      ''', [score, passedFlag, passedFlag, DateTime.now().toIso8601String(), lessonId]);
      await _recordActivity(txn, categoryId);
    });
    return getProgress(lessonId);
  }

  /// For lessons that have no quiz.
  Future<void> markCompleted(String lessonId, String categoryId) async {
    final db = await _db;
    await db.transaction((txn) async {
      await _ensureProgressRow(txn, lessonId);
      await txn.rawUpdate('''
        UPDATE lesson_progress
        SET completed = 1,
            completed_at = COALESCE(completed_at, ?)
        WHERE lesson_id = ?
      ''', [DateTime.now().toIso8601String(), lessonId]);
      await _recordActivity(txn, categoryId);
    });
  }

  /// Marks a category as started (first time) and as active now.
  Future<void> touchCategory(String categoryId) async {
    final db = await _db;
    await _touchCategory(db, categoryId);
  }

  Future<Set<String>> getActivityDays() async {
    final db = await _db;
    final rows = await db.query('activity_days');
    return rows.map((r) => r['day'] as String).toSet();
  }

  /// Clears all learner data but keeps the lessons.
  Future<void> resetProgress() async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete('lesson_progress');
      await txn.delete('category_state');
      await txn.delete('activity_days');
    });
  }

  // ---------------------------------------------------------------- helpers

  Future<Map<String, LessonProgress>> _progressMap(DatabaseExecutor db) async {
    final rows = await db.query('lesson_progress');
    return {
      for (final row in rows) row['lesson_id'] as String: LessonProgress.fromRow(row),
    };
  }

  Future<Map<String, CategoryState>> _categoryStates(DatabaseExecutor db) async {
    final rows = await db.query('category_state');
    return {
      for (final row in rows) row['category_id'] as String: CategoryState.fromRow(row),
    };
  }

  Future<void> _ensureProgressRow(DatabaseExecutor db, String lessonId) async {
    await db.insert(
      'lesson_progress',
      {'lesson_id': lessonId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> _touchCategory(DatabaseExecutor db, String categoryId) async {
    final now = DateTime.now().toIso8601String();
    await db.insert(
      'category_state',
      {'category_id': categoryId, 'started_at': now, 'last_active_at': now},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    await db.update(
      'category_state',
      {'last_active_at': now},
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  /// A real learning action (task done, quiz taken) counts toward the streak.
  Future<void> _recordActivity(DatabaseExecutor db, String categoryId) async {
    await db.insert(
      'activity_days',
      {'day': MentorEngine.dayKey(DateTime.now())},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    await _touchCategory(db, categoryId);
  }
}
