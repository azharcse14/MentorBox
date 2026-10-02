import '../data/models.dart';

enum LessonState { locked, available, completed }

/// Everything about one category for the current learner: its content plus
/// their progress. Most "mentor decisions" are made from this object.
class CategoryOverview {
  final MentorCategory category;
  final List<Level> levels;

  /// All lessons of the category in learning order (level, then lesson).
  final List<Lesson> lessons;
  final Map<String, LessonProgress> progress;
  final CategoryState? state;

  const CategoryOverview({
    required this.category,
    required this.levels,
    required this.lessons,
    required this.progress,
    required this.state,
  });

  bool get started => state != null;
  int get total => lessons.length;
  int get completedCount => lessons.where(_isCompleted).length;
  double get ratio => total == 0 ? 0 : completedCount / total;
  bool get finished => total > 0 && completedCount == total;

  bool _isCompleted(Lesson lesson) => progress[lesson.id]?.completed ?? false;

  /// Lessons unlock one by one: a lesson opens when the one before it
  /// is completed. Finishing the last lesson of a level opens the next level.
  LessonState stateOf(Lesson lesson) {
    if (_isCompleted(lesson)) return LessonState.completed;
    final index = lessons.indexWhere((l) => l.id == lesson.id);
    if (index == 0) return LessonState.available;
    if (index < 0) return LessonState.locked;
    return _isCompleted(lessons[index - 1]) ? LessonState.available : LessonState.locked;
  }

  /// The lesson the mentor wants you to do next, or null when all are done.
  Lesson? get nextLesson {
    for (final lesson in lessons) {
      if (!_isCompleted(lesson)) return lesson;
    }
    return null;
  }

  List<Lesson> lessonsOf(Level level) =>
      lessons.where((l) => l.levelId == level.id).toList();

  bool isLevelUnlocked(Level level) {
    final levelLessons = lessonsOf(level);
    if (levelLessons.isEmpty) return false;
    return stateOf(levelLessons.first) != LessonState.locked;
  }

  int completedIn(Level level) => lessonsOf(level).where(_isCompleted).length;

  /// The lesson right after [lesson], if there is one.
  Lesson? lessonAfter(Lesson lesson) {
    final index = lessons.indexWhere((l) => l.id == lesson.id);
    if (index < 0 || index + 1 >= lessons.length) return null;
    return lessons[index + 1];
  }
}

class QuizResult {
  final int correct;
  final int total;

  const QuizResult(this.correct, this.total);

  /// You pass with two thirds of the answers right (2 of 3, 4 of 6 ...).
  int get required => total == 0 ? 0 : (total * 2 / 3).ceil();
  bool get passed => correct >= required;
  bool get perfect => total > 0 && correct == total;
}

class MentorEngine {
  MentorEngine._();

  /// How many days without activity before the mentor says "welcome back".
  static const int comebackAfterDays = 3;

  static String dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${_two(date.month)}-${_two(date.day)}';

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// Consecutive active days ending today. If today has no activity yet,
  /// the streak is still alive and is counted up to yesterday.
  static int streak(Set<String> activeDays, [DateTime? now]) {
    final today = now ?? DateTime.now();
    var cursor = DateTime(today.year, today.month, today.day);
    if (!activeDays.contains(dayKey(cursor))) {
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    var count = 0;
    while (activeDays.contains(dayKey(cursor))) {
      count++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return count;
  }

  /// The last seven calendar days, oldest first, ending today.
  static List<DateTime> lastSevenDays([DateTime? now]) {
    final today = now ?? DateTime.now();
    return [
      for (var i = 6; i >= 0; i--) DateTime(today.year, today.month, today.day - i),
    ];
  }

  /// What the mentor says when you open a category.
  static String greeting(CategoryOverview overview, [DateTime? now]) {
    final category = overview.category;
    if (overview.finished) {
      return category.message(
        'finished',
        fallback: 'You finished every lesson here. Explain one idea to a friend this week. Teaching it is the final test.',
      );
    }

    final lastActive = overview.state?.lastActiveAt;
    if (lastActive == null) {
      return category.message(
        'welcome',
        fallback: 'Let\'s start small. One short lesson, one small task. That is how every skill begins.',
      );
    }

    final daysAway = (now ?? DateTime.now()).difference(lastActive).inDays;
    if (daysAway >= comebackAfterDays) {
      return category.message(
        'comeback',
        fallback: 'Good to have you back. Skip the guilt and do one lesson today.',
      );
    }

    final next = overview.nextLesson;
    if (next == null) return category.message('welcome');
    return 'You are ${overview.completedCount} of ${overview.total} lessons in. Next up is "${next.title}".';
  }

  /// What the mentor says after a quiz.
  static String quizFeedback(MentorCategory category, QuizResult result, int attempts) {
    if (result.perfect) {
      return '${category.message('pass', fallback: 'Well done.')} And a perfect score.';
    }
    if (result.passed) {
      return category.message('pass', fallback: 'Well done, you passed this lesson.');
    }
    if (attempts >= 3) {
      return 'This one is tricky, and that is normal. Read only the key points again, then try once more. Slow progress is still progress.';
    }
    return category.message(
      'fail',
      fallback: 'Not yet. Read the explanations above, review the lesson, and try again.',
    );
  }
}
