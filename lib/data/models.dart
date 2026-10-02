import 'dart:convert';
import 'dart:math' show Random;
import 'dart:ui' show Color;

/// One mentoring category, e.g. Programming or Personal Finance.
/// Each category behaves like its own mentor with a name and a voice.
class MentorCategory {
  final String id;
  final String name;
  final String mentorName;
  final String tagline;
  final String description;
  final String image;
  final Color color;
  final int sortOrder;
  final Map<String, String> messages;

  const MentorCategory({
    required this.id,
    required this.name,
    required this.mentorName,
    required this.tagline,
    required this.description,
    required this.image,
    required this.color,
    required this.sortOrder,
    required this.messages,
  });

  factory MentorCategory.fromRow(Map<String, Object?> row) {
    final decoded = jsonDecode(row['messages'] as String) as Map<String, dynamic>;
    return MentorCategory(
      id: row['id'] as String,
      name: row['name'] as String,
      mentorName: row['mentor_name'] as String,
      tagline: row['tagline'] as String,
      description: row['description'] as String,
      image: row['image'] as String,
      color: Color(row['color'] as int),
      sortOrder: row['sort_order'] as int,
      messages: decoded.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  /// A line in this mentor's voice, such as 'welcome' or 'pass'.
  String message(String key, {String fallback = ''}) {
    final value = messages[key];
    if (value == null || value.trim().isEmpty) return fallback;
    return value;
  }
}

class Level {
  final String id;
  final String categoryId;
  final String title;
  final int sortOrder;

  const Level({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.sortOrder,
  });

  factory Level.fromRow(Map<String, Object?> row) => Level(
        id: row['id'] as String,
        categoryId: row['category_id'] as String,
        title: row['title'] as String,
        sortOrder: row['sort_order'] as int,
      );
}

class Lesson {
  final String id;
  final String levelId;
  final String categoryId;
  final String title;
  final int durationMin;
  final String content;
  final List<String> keyPoints;
  final String mentorTip;
  final String task;
  final int sortOrder;

  const Lesson({
    required this.id,
    required this.levelId,
    required this.categoryId,
    required this.title,
    required this.durationMin,
    required this.content,
    required this.keyPoints,
    required this.mentorTip,
    required this.task,
    required this.sortOrder,
  });

  /// Lesson text is stored with blank lines between paragraphs.
  List<String> get paragraphs => content
      .split('\n\n')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();

  factory Lesson.fromRow(Map<String, Object?> row) => Lesson(
        id: row['id'] as String,
        levelId: row['level_id'] as String,
        categoryId: row['category_id'] as String,
        title: row['title'] as String,
        durationMin: row['duration_min'] as int,
        content: row['content'] as String,
        keyPoints: (jsonDecode(row['key_points'] as String) as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        mentorTip: row['mentor_tip'] as String,
        task: row['task'] as String,
        sortOrder: row['sort_order'] as int,
      );
}

class QuizQuestion {
  final int id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  /// The same question with its options in a random order, so the right
  /// answer is not always in the same position.
  QuizQuestion shuffled(Random random) {
    final order = List<int>.generate(options.length, (i) => i)..shuffle(random);
    return QuizQuestion(
      id: id,
      lessonId: lessonId,
      question: question,
      options: [for (final i in order) options[i]],
      answerIndex: order.indexOf(answerIndex),
      explanation: explanation,
    );
  }

  factory QuizQuestion.fromRow(Map<String, Object?> row) => QuizQuestion(
        id: row['id'] as int,
        lessonId: row['lesson_id'] as String,
        question: row['question'] as String,
        options: (jsonDecode(row['options'] as String) as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        answerIndex: row['answer_index'] as int,
        explanation: row['explanation'] as String,
      );
}

/// What the learner has done in one lesson. Stored separately from the
/// lesson content, so content updates never erase progress.
class LessonProgress {
  final String lessonId;
  final bool completed;
  final bool taskDone;
  final int bestScore;
  final int attempts;
  final String notes;
  final bool bookmarked;
  final DateTime? completedAt;

  const LessonProgress({
    required this.lessonId,
    this.completed = false,
    this.taskDone = false,
    this.bestScore = 0,
    this.attempts = 0,
    this.notes = '',
    this.bookmarked = false,
    this.completedAt,
  });

  factory LessonProgress.empty(String lessonId) => LessonProgress(lessonId: lessonId);

  factory LessonProgress.fromRow(Map<String, Object?> row) {
    final completedAt = row['completed_at'] as String?;
    return LessonProgress(
      lessonId: row['lesson_id'] as String,
      completed: (row['completed'] as int) == 1,
      taskDone: (row['task_done'] as int) == 1,
      bestScore: row['best_score'] as int,
      attempts: row['attempts'] as int,
      notes: row['notes'] as String,
      bookmarked: (row['bookmarked'] as int) == 1,
      completedAt: completedAt == null ? null : DateTime.tryParse(completedAt),
    );
  }
}

/// When the learner started a category and when they last worked in it.
class CategoryState {
  final String categoryId;
  final DateTime startedAt;
  final DateTime lastActiveAt;

  const CategoryState({
    required this.categoryId,
    required this.startedAt,
    required this.lastActiveAt,
  });

  factory CategoryState.fromRow(Map<String, Object?> row) => CategoryState(
        categoryId: row['category_id'] as String,
        startedAt: DateTime.parse(row['started_at'] as String),
        lastActiveAt: DateTime.parse(row['last_active_at'] as String),
      );
}
