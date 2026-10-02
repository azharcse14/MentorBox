import 'dart:math' show Random;

import 'package:flutter/material.dart';

import '../components/widgets.dart';
import '../data/mentor_repository.dart';
import '../data/models.dart';
import '../logic/mentor_engine.dart';
import '../theme.dart';

/// One question at a time. After each answer the mentor explains why it is
/// right or wrong, so the quiz teaches instead of only testing.
/// Pops with true when the quiz was passed.
class QuizPage extends StatefulWidget {
  final String lessonId;

  const QuizPage({super.key, required this.lessonId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _repo = MentorRepository.instance;
  final _random = Random();

  Lesson? _lesson;
  MentorCategory? _category;
  List<QuizQuestion> _original = [];
  List<QuizQuestion> _questions = [];

  int _index = 0;
  int? _selected;
  bool _checked = false;
  int _correct = 0;
  bool _saving = false;
  QuizResult? _result;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lesson = await _repo.getLesson(widget.lessonId);
    if (lesson == null) return;
    final category = await _repo.getCategory(lesson.categoryId);
    final questions = await _repo.getQuiz(lesson.id);
    if (!mounted) return;
    setState(() {
      _lesson = lesson;
      _category = category;
      _original = questions;
      _questions = _shuffle(questions);
    });
  }

  List<QuizQuestion> _shuffle(List<QuizQuestion> questions) =>
      questions.map((q) => q.shuffled(_random)).toList();

  void _select(int option) {
    if (_checked) return;
    setState(() => _selected = option);
  }

  void _check() {
    final selected = _selected;
    if (selected == null) return;
    setState(() {
      _checked = true;
      if (selected == _questions[_index].answerIndex) _correct++;
    });
  }

  Future<void> _next() async {
    if (_index + 1 < _questions.length) {
      setState(() {
        _index++;
        _selected = null;
        _checked = false;
      });
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    final lesson = _lesson;
    final category = _category;
    if (_saving || lesson == null || category == null) return;
    setState(() => _saving = true);

    final result = QuizResult(_correct, _questions.length);
    final progress = await _repo.recordQuizAttempt(
      lessonId: lesson.id,
      categoryId: lesson.categoryId,
      score: _correct,
      passed: result.passed,
    );
    if (!mounted) return;
    setState(() {
      _result = result;
      _feedback = MentorEngine.quizFeedback(category, result, progress.attempts);
      _saving = false;
    });
  }

  void _restart() {
    setState(() {
      _questions = _shuffle(_original);
      _index = 0;
      _selected = null;
      _checked = false;
      _correct = 0;
      _result = null;
      _feedback = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _lesson;
    final category = _category;
    if (lesson == null || category == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.kPrimaryColor)),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('This lesson has no quiz.', style: AppTheme.body(15))),
      );
    }

    final result = _result;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz', style: AppTheme.mono(22, weight: FontWeight.w700)),
      ),
      body: result == null
          ? _questionView(category)
          : _resultView(category, lesson, result),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: result == null ? _questionAction() : _resultAction(result),
        ),
      ),
    );
  }

  Widget _questionView(MentorCategory category) {
    final question = _questions[_index];
    final answeredCount = _index + (_checked ? 1 : 0);
    final wasRight = _selected == question.answerIndex;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
      children: [
        Text(
          'Question ${_index + 1} of ${_questions.length}',
          style: AppTheme.mono(16, color: AppTheme.kSubheadingColor),
        ),
        const SizedBox(height: 8),
        ProgressBar(
          value: answeredCount / _questions.length,
          color: category.color,
          background: const Color(0x22000000),
        ),
        const SizedBox(height: 24),
        Text(question.question, style: AppTheme.body(19, weight: FontWeight.w600, height: 1.4)),
        const SizedBox(height: 20),
        for (var i = 0; i < question.options.length; i++)
          _OptionTile(
            text: question.options[i],
            look: _lookFor(i, question),
            onTap: () => _select(i),
          ),
        if (_checked) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: wasRight ? const Color(0x225FA97A) : const Color(0x22D9645F),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wasRight ? 'Correct' : 'Not quite',
                  style: AppTheme.mono(
                    18,
                    color: wasRight ? AppTheme.kSuccess : AppTheme.kDanger,
                    weight: FontWeight.w700,
                  ),
                ),
                if (question.explanation.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(question.explanation, style: AppTheme.body(14, height: 1.5)),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  _OptionLook _lookFor(int option, QuizQuestion question) {
    if (!_checked) {
      return option == _selected ? _OptionLook.selected : _OptionLook.idle;
    }
    if (option == question.answerIndex) return _OptionLook.correct;
    if (option == _selected) return _OptionLook.wrong;
    return _OptionLook.faded;
  }

  Widget _questionAction() {
    if (!_checked) {
      return PrimaryButton(label: 'Check answer', onTap: _selected == null ? null : _check);
    }
    final last = _index + 1 >= _questions.length;
    return PrimaryButton(
      label: last ? 'See my result' : 'Next question',
      onTap: _saving ? null : _next,
    );
  }

  Widget _resultView(MentorCategory category, Lesson lesson, QuizResult result) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Icon(
          result.passed ? Icons.emoji_events : Icons.replay,
          size: 72,
          color: result.passed ? category.color : AppTheme.kSubheadingColor,
        ),
        const SizedBox(height: 8),
        Center(
          child: Text('${result.correct} / ${result.total}', style: AppTheme.display(68)),
        ),
        Center(
          child: Text(
            result.passed
                ? 'You completed "${lesson.title}"'
                : 'You need ${result.required} right answers to pass',
            textAlign: TextAlign.center,
            style: AppTheme.mono(18, color: AppTheme.kGreyShade800),
          ),
        ),
        const SizedBox(height: 28),
        MentorBubble(category: category, message: _feedback),
      ],
    );
  }

  Widget _resultAction(QuizResult result) {
    if (result.passed) {
      return PrimaryButton(label: 'Continue', onTap: () => Navigator.of(context).pop(true));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(label: 'Review the lesson', onTap: () => Navigator.of(context).pop(false)),
        TextButton(onPressed: _restart, child: const Text('Try the quiz again')),
      ],
    );
  }
}

enum _OptionLook { idle, selected, correct, wrong, faded }

class _OptionTile extends StatelessWidget {
  final String text;
  final _OptionLook look;
  final VoidCallback onTap;

  const _OptionTile({required this.text, required this.look, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color border = Colors.transparent;
    Color background = Colors.white;
    Color textColor = AppTheme.kGreyShade800;
    IconData? icon;

    switch (look) {
      case _OptionLook.idle:
        break;
      case _OptionLook.selected:
        border = AppTheme.kPrimaryColor;
        break;
      case _OptionLook.correct:
        border = AppTheme.kSuccess;
        background = const Color(0x1A5FA97A);
        icon = Icons.check_circle;
        break;
      case _OptionLook.wrong:
        border = AppTheme.kDanger;
        background = const Color(0x1AD9645F);
        icon = Icons.cancel;
        break;
      case _OptionLook.faded:
        textColor = AppTheme.kSubheadingColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: border, width: 2),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(child: Text(text, style: AppTheme.body(15, color: textColor, height: 1.4))),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: border),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
