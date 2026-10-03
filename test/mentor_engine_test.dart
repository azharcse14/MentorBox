import 'dart:math' show Random;
import 'dart:ui' show Color, Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/data/models.dart';
import 'package:mentor_app_flutter/l10n/app_localizations.dart';
import 'package:mentor_app_flutter/logic/mentor_engine.dart';

const _category = MentorCategory(
  id: 'cat',
  name: 'Test',
  mentorName: 'Test Mentor',
  tagline: '',
  description: '',
  image: '',
  color: Color(0xFF000000),
  sortOrder: 0,
  messages: {'pass': 'Nice.', 'fail': 'Again.'},
);

Lesson _lesson(String id, String levelId, int order) => Lesson(
      id: id,
      levelId: levelId,
      categoryId: 'cat',
      title: id,
      durationMin: 5,
      content: 'One.\n\nTwo.',
      keyPoints: const [],
      mentorTip: '',
      task: '',
      sortOrder: order,
    );

CategoryOverview _overview(Set<String> completed) {
  return CategoryOverview(
    category: _category,
    levels: const [
      Level(id: 'l1', categoryId: 'cat', title: 'One', sortOrder: 0),
      Level(id: 'l2', categoryId: 'cat', title: 'Two', sortOrder: 1),
    ],
    lessons: [_lesson('a', 'l1', 0), _lesson('b', 'l1', 1), _lesson('c', 'l2', 0)],
    progress: {
      for (final id in completed) id: LessonProgress(lessonId: id, completed: true),
    },
    state: null,
  );
}

void main() {
  group('lesson unlocking', () {
    test('only the first lesson is open at the start', () {
      final o = _overview({});
      expect(o.stateOf(o.lessons[0]), LessonState.available);
      expect(o.stateOf(o.lessons[1]), LessonState.locked);
      expect(o.isLevelUnlocked(o.levels[1]), isFalse);
      expect(o.nextLesson?.id, 'a');
    });

    test('finishing a level opens the next level', () {
      final o = _overview({'a', 'b'});
      expect(o.isLevelUnlocked(o.levels[1]), isTrue);
      expect(o.stateOf(o.lessons[2]), LessonState.available);
      expect(o.ratio, closeTo(2 / 3, 0.001));
    });

    test('everything done', () {
      final o = _overview({'a', 'b', 'c'});
      expect(o.finished, isTrue);
      expect(o.nextLesson, isNull);
      expect(o.lessonAfter(o.lessons[2]), isNull);
    });

    test('paragraphs split on blank lines', () {
      expect(_lesson('x', 'l1', 0).paragraphs, ['One.', 'Two.']);
    });
  });

  group('quiz', () {
    test('two of three passes, one of three fails', () {
      expect(const QuizResult(2, 3).passed, isTrue);
      expect(const QuizResult(1, 3).passed, isFalse);
      expect(const QuizResult(3, 3).perfect, isTrue);
      expect(const QuizResult(0, 6).required, 4);
    });

    test('feedback uses the mentor voice', () {
      final l = lookupAppLocalizations(const Locale('en'));
      expect(MentorEngine.quizFeedback(_category, const QuizResult(2, 3), 1, l), 'Nice.');
      expect(MentorEngine.quizFeedback(_category, const QuizResult(0, 3), 1, l), 'Again.');
    });

    test('bangla fallbacks and digits', () {
      final l = lookupAppLocalizations(const Locale('bn'));
      expect(MentorEngine.quizFeedback(_category, const QuizResult(3, 3), 1, l), 'Nice. আর একদম পুরো নম্বর!');
      expect(l.streakDays(3), '৩ দিনের স্ট্রিক');
    });

    test('shuffling keeps the right answer', () {
      const q = QuizQuestion(
        id: 1,
        lessonId: 'a',
        question: 'Q',
        options: ['w', 'right', 'x', 'y'],
        answerIndex: 1,
        explanation: '',
      );
      final random = Random(7);
      for (var i = 0; i < 20; i++) {
        final s = q.shuffled(random);
        expect(s.options[s.answerIndex], 'right');
        expect(s.options.toSet(), q.options.toSet());
      }
    });
  });

  group('streak', () {
    final now = DateTime(2026, 3, 10, 15);

    test('counts consecutive days ending today', () {
      final days = {'2026-03-10', '2026-03-09', '2026-03-08', '2026-03-06'};
      expect(MentorEngine.streak(days, now), 3);
    });

    test('stays alive when only yesterday is done', () {
      expect(MentorEngine.streak({'2026-03-09', '2026-03-08'}, now), 2);
    });

    test('breaks after a missed day', () {
      expect(MentorEngine.streak({'2026-03-07'}, now), 0);
    });

    test('works across a month boundary', () {
      expect(MentorEngine.streak({'2026-03-01', '2026-02-28'}, DateTime(2026, 3, 1)), 2);
    });

    test('last seven days end today', () {
      final week = MentorEngine.lastSevenDays(now);
      expect(week.length, 7);
      expect(MentorEngine.dayKey(week.last), '2026-03-10');
      expect(MentorEngine.dayKey(week.first), '2026-03-04');
    });
  });
}
