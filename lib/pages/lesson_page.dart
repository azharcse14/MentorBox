import 'dart:async';

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
  // ponytail: in memory only, so reading spots reset when the app restarts.
  static final Map<String, double> _scrollMemory = {};

  /// Most paragraphs start with a short "Heading: " label; it is shown bold.
  static final _label = RegExp(r'^([^:\n.?!]{2,40}):\s');

  final _repo = MentorRepository.instance;
  final _notesController = TextEditingController();
  final _scroll = ScrollController();

  Lesson? _lesson;
  MentorCategory? _category;
  LessonProgress? _progress;
  Lesson? _nextLesson;
  int _quizCount = 0;
  bool _notesDirty = false;
  bool _notesSaved = false;
  Timer? _notesTimer;
  bool _missing = false;
  bool _failed = false;

  /// The lesson before this one, to jump back to when this one is locked.
  Lesson? _previous;

  /// The lesson before this one is not done: readable, but no quiz yet.
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    // Never lose a note: save unsaved text when leaving the page.
    _notesTimer?.cancel();
    final lesson = _lesson;
    if (_notesDirty && lesson != null) {
      _repo.saveNotes(lesson.id, _notesController.text.trim());
    }
    _notesController.dispose();
    if (_scroll.hasClients) _scrollMemory[widget.lessonId] = _scroll.offset;
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      await _loadData();
    } catch (e) {
      debugPrint('Lesson load failed: $e');
      // Keep showing the lesson if it was already loaded once.
      if (mounted && _lesson == null) setState(() => _failed = true);
    }
  }

  void _retry() {
    setState(() => _failed = false);
    _load();
  }

  Future<void> _loadData() async {
    final lesson = await _repo.getLesson(widget.lessonId);
    if (lesson == null) {
      if (mounted) setState(() => _missing = true);
      return;
    }
    await _repo.touchCategory(lesson.categoryId);
    final category = await _repo.getCategory(lesson.categoryId);
    final progress = await _repo.getProgress(lesson.id);
    final quiz = await _repo.getQuiz(lesson.id);
    final next = await _repo.getLessonAfter(lesson.id);
    final before = await _repo.getLessonBefore(lesson.id);
    final locked = !progress.completed && before != null && !(await _repo.getProgress(before.id)).completed;
    if (!mounted) return;
    final firstLoad = _lesson == null;
    setState(() {
      _locked = locked;
      _previous = before;
      _lesson = lesson;
      _category = category;
      _progress = progress;
      _quizCount = quiz.length;
      _nextLesson = next;
      if (!_notesDirty) _notesController.text = progress.notes;
    });
    // Come back to where you stopped reading.
    final offset = _scrollMemory[widget.lessonId];
    if (firstLoad && offset != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) _scroll.jumpTo(offset.clamp(0, _scroll.position.maxScrollExtent));
      });
    }
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

  /// Notes save themselves a moment after you stop typing.
  void _onNotesChanged(String _) {
    _notesDirty = true;
    if (_notesSaved) setState(() => _notesSaved = false);
    _notesTimer?.cancel();
    _notesTimer = Timer(const Duration(milliseconds: 800), _saveNotes);
  }

  Future<void> _saveNotes() async {
    final lesson = _lesson;
    if (lesson == null) return;
    await _repo.saveNotes(lesson.id, _notesController.text.trim());
    _notesDirty = false;
    if (!mounted) return;
    setState(() => _notesSaved = true);
  }

  Future<void> _openQuiz() async {
    final lesson = _lesson;
    if (lesson == null) return;
    final passed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => QuizPage(lessonId: lesson.id, nextLesson: _nextLesson)),
    );
    // The quiz result screen already offered "Next lesson", so go there.
    if (passed == true && _nextLesson != null) return _goToNext();
    await _load();
  }

  Future<void> _markComplete() async {
    final lesson = _lesson;
    if (lesson == null) return;
    await _repo.markCompleted(lesson.id, lesson.categoryId);
    await _load();
    if (!mounted) return;
    _toast(AppLocalizations.of(context).lessonCompleted);
  }

  void _goToNext() => _replaceWith(_nextLesson);

  void _replaceWith(Lesson? lesson) {
    if (lesson == null) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LessonPage(lessonId: lesson.id)),
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

    if (_failed) {
      return Scaffold(appBar: AppBar(), body: LoadError(onRetry: _retry));
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
        // How far through the lesson you have read.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: ListenableBuilder(
            listenable: _scroll,
            builder: (context, _) {
              final max = _scroll.hasClients ? _scroll.position.maxScrollExtent : 0.0;
              return LinearProgressIndicator(
                value: max <= 0 ? 0 : _scroll.offset / max,
                minHeight: 3,
                color: accent,
                backgroundColor: Colors.transparent,
              );
            },
          ),
        ),
      ),
      body: ListView(
        controller: _scroll,
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
              if (_locked) _Tag(text: l.preview, color: AppTheme.kSubheadingColor),
            ],
          ),
          const SizedBox(height: 14),
          Text(lesson.title, style: AppTheme.body(26, weight: FontWeight.w600, height: 1.25)),
          const SizedBox(height: 16),
          for (final paragraph in lesson.paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _paragraph(paragraph),
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
                  Material(
                    type: MaterialType.transparency,
                    child: CheckboxListTile(
                      value: progress.taskDone,
                      onChanged: _locked ? null : _setTaskDone,
                      activeColor: accent,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l.iDidTask, style: AppTheme.body(14, weight: FontWeight.w600)),
                    ),
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
                  onChanged: _onNotesChanged,
                  style: AppTheme.body(14),
                  decoration: InputDecoration(
                    hintText: l.notesHint,
                    hintStyle: AppTheme.body(14, color: AppTheme.kSubheadingColor),
                    filled: true,
                    fillColor: AppTheme.kCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedOpacity(
                  opacity: _notesSaved ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Text('✓ ${l.noteSaved}', style: AppTheme.mono(13, color: AppTheme.kSuccess)),
                ),
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

  Widget _paragraph(String text) {
    final style = AppTheme.body(15, height: 1.65);
    final label = _label.firstMatch(text);
    if (label == null) return Text(text, style: style);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: label.group(0), style: const TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: text.substring(label.end)),
        ],
      ),
    );
  }

  Widget _bottomAction(LessonProgress progress) {
    final l = AppLocalizations.of(context);
    if (_locked) {
      // Say why it is locked, and give a way forward instead of a dead button.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.lockedLessonHint,
                textAlign: TextAlign.center, style: AppTheme.body(13, color: AppTheme.kSubheadingColor)),
          ),
          PrimaryButton(label: l.openPreviousLesson, onTap: () => _replaceWith(_previous)),
        ],
      );
    }
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
