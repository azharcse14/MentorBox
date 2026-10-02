import 'package:flutter/material.dart';

import '../components/widgets.dart';
import '../data/mentor_repository.dart';
import '../data/models.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'lesson_page.dart';

/// Saved lessons (heart icon) and every lesson where you wrote notes.
class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final _repo = MentorRepository.instance;

  bool _loading = true;
  List<Lesson> _saved = [];
  List<Lesson> _withNotes = [];
  Map<String, MentorCategory> _categories = {};
  Map<String, String> _notes = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await _repo.getBookmarkedLessons();
    final withNotes = await _repo.getLessonsWithNotes();
    final categories = await _repo.getCategories();
    final notes = <String, String>{};
    for (final lesson in withNotes) {
      notes[lesson.id] = (await _repo.getProgress(lesson.id)).notes;
    }
    if (!mounted) return;
    setState(() {
      _saved = saved;
      _withNotes = withNotes;
      _categories = {for (final c in categories) c.id: c};
      _notes = notes;
      _loading = false;
    });
  }

  Future<void> _open(Lesson lesson) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LessonPage(lessonId: lesson.id)),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.savedTitle, style: AppTheme.display(32))),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.kPrimaryColor))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                _Heading(l.savedLessons),
                if (_saved.isEmpty) _Empty(l.savedEmpty),
                for (final lesson in _saved)
                  LessonRow(
                    lesson: lesson,
                    category: _categories[lesson.categoryId],
                    onTap: () => _open(lesson),
                  ),
                const SizedBox(height: 20),
                _Heading(l.yourNotes),
                if (_withNotes.isEmpty) _Empty(l.notesEmpty),
                for (final lesson in _withNotes)
                  LessonRow(
                    lesson: lesson,
                    category: _categories[lesson.categoryId],
                    subtitle: _notes[lesson.id],
                    onTap: () => _open(lesson),
                  ),
              ],
            ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;

  const _Heading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: AppTheme.mono(20, color: AppTheme.kSubheadingColor, weight: FontWeight.w600)),
    );
  }
}

class _Empty extends StatelessWidget {
  final String text;

  const _Empty(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text, style: AppTheme.body(14, color: AppTheme.kSubheadingColor)),
    );
  }
}
