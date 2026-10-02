import 'package:flutter/material.dart';

import '../components/widgets.dart';
import '../data/mentor_repository.dart';
import '../data/models.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'quiz_page.dart';

class LessonPage extends StatefulWidget {
  final String lessonId;

  const LessonPage({super.key, required this.lessonId});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final _repo = MentorRepository.instance;
  final _notesController = TextEditingController();

  Lesson? _lesson;
  MentorCategory? _category;
  LessonProgress? _progress;
  Lesson? _nextLesson;
  int _quizCount = 0;
  bool _notesDirty = false;
  bool _missing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    // Never lose a note: save unsaved text when leaving the page.
    final lesson = _lesson;
    if (_notesDirty && lesson != null) {
      _repo.saveNotes(lesson.id, _notesController.text.trim());
    }
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final lesson = await _repo.getLesson(widget.lessonId);
    if (lesson == null) {
      if (mounted) setState(() => _missing = true);
      return;
    }
    await _repo.touchCategory(lesson.categoryId);
    final category = await _repo.getCategory(lesson.categoryId);
    final progress = await _repo.getProgress(lesson.id);
    final quiz = await _repo.getQuiz(lesson.id);
    final overview = await _repo.getOverview(lesson.categoryId);
    if (!mounted) return;
    setState(() {
      _lesson = lesson;
      _category = category;
      _progress = progress;
      _quizCount = quiz.length;
      _nextLesson = overview?.lessonAfter(lesson);
      if (!_notesDirty) _notesController.text = progress.notes;
    });
  }

  Future<void> _refreshProgress() async {
    final progress = await _repo.getProgress(widget.lessonId);
    if (!mounted) return;
    setState(() => _progress = progress);
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  Future<void> _toggleBookmark() async {
    final progress = _progress;
    if (progress == null) return;
    final value = !progress.bookmarked;
    await _repo.setBookmarked(progress.lessonId, value);
    await _refreshProgress();
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    _toast(value ? l.lessonSaved : l.lessonUnsaved);
  }

  Future<void> _setTaskDone(bool? value) async {
    final lesson = _lesson;
    if (lesson == null) return;
    await _repo.setTaskDone(lesson.id, lesson.categoryId, value ?? false);
    await _refreshProgress();
  }

  Future<void> _saveNotes() async {
    final lesson = _lesson;
    if (lesson == null) return;
    FocusScope.of(context).unfocus();
    await _repo.saveNotes(lesson.id, _notesController.text.trim());
    _notesDirty = false;
    await _refreshProgress();
    if (!mounted) return;
    _toast(AppLocalizations.of(context).noteSaved);
  }

  Future<void> _openQuiz() async {
    final lesson = _lesson;
    if (lesson == null) return;
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => QuizPage(lessonId: lesson.id)),
    );
    await _load();
  }

  Future<void> _markComplete() async {
    final lesson = _lesson;
    if (lesson == null) return;
    await _repo.markCompleted(lesson.id, lesson.categoryId);
    await _load();
  }

  void _goToNext() {
    final next = _nextLesson;
    if (next == null) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LessonPage(lessonId: next.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_missing) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(l.lessonMissing, style: AppTheme.body(15)),
        ),
      );
    }

    final lesson = _lesson;
    final category = _category;
    final progress = _progress;
    if (lesson == null || category == null || progress == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.kPrimaryColor)),
      );
    }
    final accent = category.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.mentorName, style: AppTheme.mono(22, weight: FontWeight.w700)),
        actions: [
          IconButton(
            tooltip: progress.bookmarked ? l.removeFromSaved : l.saveLesson,
            onPressed: _toggleBookmark,
            icon: Icon(
              progress.bookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: AppTheme.kPrimaryColor,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Tag(text: category.name, color: accent),
              _Tag(text: l.minutesRead(lesson.durationMin), color: AppTheme.kSubheadingColor),
              if (progress.completed) _Tag(text: l.completed, color: AppTheme.kSuccess),
            ],
          ),
          const SizedBox(height: 14),
          Text(lesson.title, style: AppTheme.display(38)),
          const SizedBox(height: 16),
          for (final paragraph in lesson.paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(paragraph, style: AppTheme.body(15, height: 1.65)),
            ),
          const SizedBox(height: 8),
          if (lesson.keyPoints.isNotEmpty)
            SectionCard(
              title: l.keyPoints,
              icon: Icons.check,
              color: accent,
              child: Column(
                children: [
                  for (final point in lesson.keyPoints)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                            ),
                          ),
                          Expanded(child: Text(point, style: AppTheme.body(14, height: 1.5))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          if (lesson.mentorTip.isNotEmpty)
            SectionCard(
              title: l.mentorTip,
              icon: Icons.lightbulb_outline,
              color: accent,
              child: Text(
                lesson.mentorTip,
                style: AppTheme.body(14, height: 1.55, style: FontStyle.italic),
              ),
            ),
          if (lesson.task.isNotEmpty)
            SectionCard(
              title: l.yourTask,
              icon: Icons.task_alt,
              color: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.task, style: AppTheme.body(14, height: 1.55)),
                  const SizedBox(height: 6),
                  CheckboxListTile(
                    value: progress.taskDone,
                    onChanged: _setTaskDone,
                    activeColor: accent,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(l.iDidTask, style: AppTheme.body(14, weight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          SectionCard(
            title: l.myNotes,
            icon: Icons.notes,
            color: accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: 6,
                  onChanged: (_) => _notesDirty = true,
                  style: AppTheme.body(14),
                  decoration: InputDecoration(
                    hintText: l.notesHint,
                    hintStyle: AppTheme.body(14, color: AppTheme.kSubheadingColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(onPressed: _saveNotes, child: Text(l.saveNote)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: _bottomAction(progress),
        ),
      ),
    );
  }

  Widget _bottomAction(LessonProgress progress) {
    final l = AppLocalizations.of(context);
    if (!progress.completed) {
      if (_quizCount == 0) {
        return PrimaryButton(label: l.markComplete, onTap: _markComplete);
      }
      return PrimaryButton(
        label: progress.attempts == 0 ? l.takeQuiz : l.retakeQuiz,
        onTap: _openQuiz,
      );
    }

    final next = _nextLesson;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (next != null)
          PrimaryButton(label: l.nextLesson(next.title), onTap: _goToNext)
        else
          PrimaryButton(label: l.backToMentor, onTap: () => Navigator.of(context).pop()),
        if (_quizCount > 0) TextButton(onPressed: _openQuiz, child: Text(l.practiceQuizAgain)),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;

  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: AppTheme.mono(14, color: color)),
    );
  }
}
