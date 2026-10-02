import 'package:flutter/material.dart';

import '../components/widgets.dart';
import '../data/mentor_repository.dart';
import '../data/models.dart';
import '../logic/mentor_engine.dart';
import '../theme.dart';
import 'lesson_page.dart';

/// One mentor's page: what it teaches, how far you are, and the roadmap of
/// levels and lessons. Keeps the dark, slowly zooming photo of the original
/// detail page.
class MentorPage extends StatefulWidget {
  final String categoryId;

  const MentorPage({super.key, required this.categoryId});

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> with SingleTickerProviderStateMixin {
  final _repo = MentorRepository.instance;
  late final AnimationController _zoom;
  late final Animation<double> _scale;
  CategoryOverview? _overview;

  @override
  void initState() {
    super.initState();
    _zoom = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _zoom, curve: Curves.easeInOut),
    );
    _load();
  }

  @override
  void dispose() {
    _zoom.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final overview = await _repo.getOverview(widget.categoryId);
    if (!mounted) return;
    setState(() => _overview = overview);
  }

  Future<void> _openLesson(Lesson lesson) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LessonPage(lessonId: lesson.id)),
    );
    await _load();
  }

  void _showLocked() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Finish the lesson before this one to unlock it.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final overview = _overview;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.kPrimaryColor,
        iconTheme: const IconThemeData(color: AppTheme.kPrimaryColor),
        centerTitle: true,
        title: Text(
          overview?.category.mentorName ?? '',
          style: AppTheme.mono(24, color: AppTheme.kPrimaryColor, weight: FontWeight.w700),
        ),
      ),
      body: overview == null
          ? const Center(child: CircularProgressIndicator(color: AppTheme.kPrimaryColor))
          : Stack(
              children: [
                Positioned.fill(
                  child: ScaleTransition(
                    scale: _scale,
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(overview.category.image, fit: BoxFit.cover),
                    ),
                  ),
                ),
                SafeArea(child: _content(overview)),
              ],
            ),
      bottomNavigationBar: overview == null ? null : _bottomAction(overview),
    );
  }

  Widget _content(CategoryOverview overview) {
    final category = overview.category;
    final percent = (overview.ratio * 100).round();

    return ListView(
      padding: EdgeInsets.fromLTRB(20, kToolbarHeight + MediaQuery.of(context).size.height * 0.12, 20, 24),
      children: [
        Text(category.name, style: AppTheme.display(44, color: AppTheme.kScaffoldBackgroundColor)),
        const SizedBox(height: 6),
        Text(category.tagline, style: AppTheme.body(16, color: AppTheme.kScaffoldBackgroundColor, height: 1.4)),
        const SizedBox(height: 20),
        MentorBubble(category: category, message: MentorEngine.greeting(overview), dark: true),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0x33DEDDD2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Progress : ',
                    style: AppTheme.mono(20, color: Colors.grey.shade500, weight: FontWeight.w700),
                  ),
                  // Counts up once, like the price animation in the original design.
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: percent.toDouble()),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOut,
                    builder: (context, value, _) => Text(
                      '${value.round()}%',
                      style: AppTheme.display(35, color: Colors.white70),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${overview.completedCount} of ${overview.total} lessons',
                    style: AppTheme.mono(15, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ProgressBar(value: overview.ratio, color: category.color),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(category.description, style: AppTheme.body(15, color: Colors.grey, height: 1.6)),
        const SizedBox(height: 28),
        for (var i = 0; i < overview.levels.length; i++)
          _LevelSection(
            number: i + 1,
            level: overview.levels[i],
            overview: overview,
            onOpen: _openLesson,
            onLocked: _showLocked,
          ),
      ],
    );
  }

  Widget _bottomAction(CategoryOverview overview) {
    if (overview.lessons.isEmpty) return const SizedBox.shrink();

    final String label;
    final Lesson target;
    if (overview.finished) {
      label = 'Review from the first lesson';
      target = overview.lessons.first;
    } else if (overview.completedCount == 0) {
      label = 'Start mentoring';
      target = overview.nextLesson!;
    } else {
      label = 'Continue: ${overview.nextLesson!.title}';
      target = overview.nextLesson!;
    }

    return Container(
      color: Colors.black,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: PrimaryButton(label: label, onTap: () => _openLesson(target)),
        ),
      ),
    );
  }
}

class _LevelSection extends StatelessWidget {
  final int number;
  final Level level;
  final CategoryOverview overview;
  final void Function(Lesson lesson) onOpen;
  final VoidCallback onLocked;

  const _LevelSection({
    required this.number,
    required this.level,
    required this.overview,
    required this.onOpen,
    required this.onLocked,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = overview.lessonsOf(level);
    final unlocked = overview.isLevelUnlocked(level);
    final done = overview.completedIn(level);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Level $number',
                style: AppTheme.display(24, color: unlocked ? AppTheme.kPrimaryColor : Colors.white38),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  level.title,
                  style: AppTheme.body(15, color: unlocked ? Colors.white : Colors.white38, weight: FontWeight.w600),
                ),
              ),
              Text(
                unlocked ? '$done/${lessons.length}' : 'Locked',
                style: AppTheme.mono(14, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final lesson in lessons)
            _LessonTile(
              lesson: lesson,
              state: overview.stateOf(lesson),
              progress: overview.progress[lesson.id],
              accent: overview.category.color,
              onTap: () => overview.stateOf(lesson) == LessonState.locked ? onLocked() : onOpen(lesson),
            ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final LessonState state;
  final LessonProgress? progress;
  final Color accent;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.state,
    required this.progress,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final Color iconColor;
    if (state == LessonState.completed) {
      icon = Icons.check_circle;
      iconColor = AppTheme.kSuccess;
    } else if (state == LessonState.available) {
      icon = Icons.play_circle_fill;
      iconColor = accent;
    } else {
      icon = Icons.lock_outline;
      iconColor = Colors.white38;
    }

    final locked = state == LessonState.locked;
    final p = progress;
    final String detail;
    if (state == LessonState.completed && p != null) {
      detail = '${lesson.durationMin} min, best quiz score ${p.bestScore}';
    } else {
      detail = '${lesson.durationMin} min';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: locked ? const Color(0x0FFFFFFF) : const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: AppTheme.body(
                          15,
                          color: locked ? Colors.white38 : Colors.white,
                          weight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(detail, style: AppTheme.mono(13, color: Colors.white54)),
                    ],
                  ),
                ),
                if (p != null && p.bookmarked)
                  const Icon(Icons.bookmark, color: AppTheme.kPrimaryColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
