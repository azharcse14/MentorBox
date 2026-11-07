import 'package:flutter/material.dart';

import '../components/widgets.dart';
import '../data/mentor_repository.dart';
import '../data/models.dart';
import '../l10n/app_localizations.dart';
import '../logic/mentor_engine.dart';
import '../theme.dart';
import 'lesson_page.dart';

/// One mentor's page: what it teaches, how far you are, and the roadmap of
/// levels and lessons, over the slowly zooming photo of the original detail
/// page. Follows the light/dark theme like the rest of the app.
///
/// Categories listed together in [tabGroups] share one page with a tab per
/// category; only the first of each group gets a card on the home screen.
class MentorPage extends StatefulWidget {
  final String categoryId;

  const MentorPage({super.key, required this.categoryId});

  static const tabGroups = [
    ['cse-courses', 'cse'],
  ];

  static List<String> groupOf(String id) => tabGroups.firstWhere((g) => g.contains(id), orElse: () => [id]);

  static bool isTabOnly(String id) => groupOf(id).first != id;

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> with TickerProviderStateMixin {
  final _repo = MentorRepository.instance;
  late final AnimationController _zoom;
  late final Animation<double> _scale;
  CategoryOverview? _overview;
  bool _failed = false;
  late final List<String> _group = MentorPage.groupOf(widget.categoryId);
  late String _categoryId = widget.categoryId;
  late final TabController? _tabs = _group.length < 2
      ? null
      : (TabController(length: _group.length, vsync: this, initialIndex: _group.indexOf(widget.categoryId))
        ..addListener(_onTab));

  @override
  void initState() {
    super.initState();
    _zoom = AnimationController(vsync: this, duration: const Duration(seconds: 6));
    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _zoom, curve: Curves.easeInOut),
    );
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // "Remove animations" in the phone settings stops the endless zoom.
    if (MediaQuery.disableAnimationsOf(context)) {
      _zoom.stop();
    } else if (!_zoom.isAnimating) {
      _zoom.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _zoom.dispose();
    _tabs?.dispose();
    super.dispose();
  }

  void _onTab() {
    final id = _group[_tabs!.index];
    if (id == _categoryId) return;
    _categoryId = id;
    _load();
  }

  Future<void> _load() async {
    final id = _categoryId;
    CategoryOverview? overview;
    try {
      overview = await _repo.getOverview(id);
    } catch (e) {
      debugPrint('Mentor load failed: $e');
    }
    // Ignore a slow load for a tab the user already left.
    if (!mounted || id != _categoryId) return;
    setState(() {
      _failed = overview == null;
      // A failed reload keeps this category's page, never another tab's.
      if (overview != null || _overview?.category.id != id) _overview = overview;
    });
  }

  String _tabLabel(String id, AppLocalizations l) => switch (id) {
        'cse-courses' => l.tabCseCourses,
        'cse' => l.tabCseRoadmap,
        _ => id,
      };

  Future<void> _openLesson(Lesson lesson) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LessonPage(lessonId: lesson.id)),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final overview = _overview;
    return Scaffold(
      backgroundColor: AppTheme.kBackground,
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
        bottom: _tabs == null
            ? null
            : TabBar(
                controller: _tabs,
                indicatorColor: AppTheme.kPrimaryColor,
                labelColor: AppTheme.kPrimaryColor,
                unselectedLabelColor: AppTheme.kSubheadingColor,
                dividerColor: Colors.transparent,
                labelStyle: AppTheme.mono(15, weight: FontWeight.w700),
                tabs: [for (final id in _group) Tab(text: _tabLabel(id, AppLocalizations.of(context)))],
              ),
      ),
      body: overview == null
          ? Center(
              child:
                  _failed ? LoadError(onRetry: _load) : const CircularProgressIndicator(color: AppTheme.kPrimaryColor),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: ScaleTransition(
                    scale: _scale,
                    child: Opacity(
                      opacity: AppTheme.isDark ? 0.3 : 0.15,
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
    final l = AppLocalizations.of(context);

    final header = <Widget>[
      Text(category.name, style: AppTheme.display(44)),
      const SizedBox(height: 6),
      Text(category.tagline, style: AppTheme.body(16, height: 1.4)),
      const SizedBox(height: 20),
      MentorBubble(category: category, message: MentorEngine.greeting(overview, l), dark: AppTheme.isDark),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.kSurface.withAlpha(0xCC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  l.progressLabel,
                  style: AppTheme.mono(20, color: AppTheme.kSubheadingColor, weight: FontWeight.w700),
                ),
                // Counts up once, like the price animation in the original design.
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: percent.toDouble()),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOut,
                  builder: (context, value, _) => Text(
                    l.percent(value.round()),
                    style: AppTheme.display(35),
                  ),
                ),
                const Spacer(),
                Text(
                  l.lessonsOf(overview.completedCount, overview.total),
                  style: AppTheme.mono(15, color: AppTheme.kSubheadingColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ProgressBar(value: overview.ratio, color: category.color),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Text(category.description, style: AppTheme.body(15, height: 1.6)),
      const SizedBox(height: 28),
    ];
    final levels = overview.levels;

    // Built lazily: the CSE courses have 50+ levels.
    return ListView.builder(
      // New key per category: scroll position and open levels reset on tab switch.
      key: ValueKey(category.id),
      padding: EdgeInsets.fromLTRB(20,
          kToolbarHeight + (_tabs == null ? 0 : kTextTabBarHeight) + MediaQuery.of(context).size.height * 0.12, 20, 24),
      itemCount: header.length + levels.length,
      itemBuilder: (context, index) {
        if (index < header.length) return header[index];
        final i = index - header.length;
        final newSection = levels[i].section.isNotEmpty && (i == 0 || levels[i - 1].section != levels[i].section);
        final level = _LevelSection(number: i + 1, level: levels[i], overview: overview, onOpen: _openLesson);
        if (!newSection) return level;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 20, bottom: 8),
              child: Text(levels[i].section.toUpperCase(), style: AppTheme.mono(14, color: category.color)),
            ),
            level,
          ],
        );
      },
    );
  }

  Widget _bottomAction(CategoryOverview overview) {
    if (overview.lessons.isEmpty) return const SizedBox.shrink();

    final l = AppLocalizations.of(context);
    final String label;
    final Lesson target;
    if (overview.finished) {
      label = l.reviewFromFirst;
      target = overview.lessons.first;
    } else if (overview.completedCount == 0) {
      label = l.startMentoring;
      target = overview.nextLesson!;
    } else {
      label = l.continueLesson(overview.nextLesson!.title);
      target = overview.nextLesson!;
    }

    return Container(
      color: AppTheme.kBackground,
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

  const _LevelSection({
    required this.number,
    required this.level,
    required this.overview,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = overview.lessonsOf(level);
    final unlocked = overview.isLevelUnlocked(level);
    final done = overview.completedIn(level);
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      // Only the level you are working on starts open, so the current
      // lesson is near the top instead of at the end of a long list.
      child: ExpansionTile(
        initiallyExpanded: lessons.contains(overview.nextLesson),
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(top: 4),
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppTheme.kSubheadingColor,
        collapsedIconColor: AppTheme.kSubheadingColor,
        title: Row(
          children: [
            Text(
              l.levelNumber(number),
              style: AppTheme.display(24, color: unlocked ? AppTheme.kPrimaryColor : AppTheme.kSubheadingColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                level.title,
                style: AppTheme.body(15,
                    color: unlocked ? AppTheme.kText : AppTheme.kSubheadingColor, weight: FontWeight.w600),
              ),
            ),
            Text(
              unlocked ? l.fraction(done, lessons.length) : l.preview,
              style: AppTheme.mono(14, color: AppTheme.kSubheadingColor),
            ),
          ],
        ),
        children: [
          for (final lesson in lessons)
            _LessonTile(
              lesson: lesson,
              state: overview.stateOf(lesson),
              progress: overview.progress[lesson.id],
              accent: overview.category.color,
              // Locked lessons open as a read-only preview; the quiz stays locked.
              onTap: () => onOpen(lesson),
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
      iconColor = AppTheme.kSubheadingColor;
    }

    final locked = state == LessonState.locked;
    final p = progress;
    final l = AppLocalizations.of(context);
    final String detail;
    if (state == LessonState.completed && p != null) {
      detail = l.minutesWithScore(lesson.durationMin, p.bestScore);
    } else {
      detail = l.minutes(lesson.durationMin);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppTheme.kCard.withAlpha(locked ? 0x66 : 0xCC),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 28, semanticLabel: locked ? l.preview : null),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: AppTheme.body(
                          15,
                          color: locked ? AppTheme.kSubheadingColor : AppTheme.kText,
                          weight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(detail, style: AppTheme.mono(13, color: AppTheme.kSubheadingColor)),
                    ],
                  ),
                ),
                if (p != null && p.bookmarked) const Icon(Icons.bookmark, color: AppTheme.kPrimaryColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
