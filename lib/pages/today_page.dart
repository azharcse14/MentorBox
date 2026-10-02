import 'package:flutter/material.dart';

import '../components/widgets.dart';
import '../data/mentor_repository.dart';
import '../logic/mentor_engine.dart';
import '../theme.dart';
import 'lesson_page.dart';
import 'mentor_page.dart';

/// Today's missions (bell icon): your streak for the week and the next
/// lesson from every mentor you have started.
class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final _repo = MentorRepository.instance;

  bool _loading = true;
  List<CategoryOverview> _overviews = [];
  Set<String> _days = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final overviews = await _repo.getAllOverviews();
    final days = await _repo.getActivityDays();
    if (!mounted) return;
    setState(() {
      _overviews = overviews;
      _days = days;
      _loading = false;
    });
  }

  Future<void> _push(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Today', style: AppTheme.display(32))),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.kPrimaryColor))
          : _content(),
    );
  }

  Widget _content() {
    final missions = _overviews
        .where((o) => o.started && !o.finished && o.nextLesson != null)
        .toList()
      ..sort((a, b) => b.state!.lastActiveAt.compareTo(a.state!.lastActiveAt));
    final notStarted = _overviews.where((o) => !o.started).take(2).toList();
    final todayDone = _days.contains(MentorEngine.dayKey(DateTime.now()));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        _WeekCard(days: _days, streak: MentorEngine.streak(_days), todayDone: todayDone),
        const SizedBox(height: 24),
        Text(
          "Today's missions",
          style: AppTheme.mono(20, color: AppTheme.kSubheadingColor, weight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        if (missions.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.kSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'You have no missions yet. Pick a mentor below or on the home screen and start the first lesson.',
              style: AppTheme.body(14, color: AppTheme.kSubheadingColor),
            ),
          ),
        for (final overview in missions)
          LessonRow(
            lesson: overview.nextLesson!,
            category: overview.category,
            subtitle: overview.nextLesson!.task.isEmpty
                ? '${overview.completedCount} of ${overview.total} lessons done'
                : 'Task: ${overview.nextLesson!.task}',
            onTap: () => _push(LessonPage(lessonId: overview.nextLesson!.id)),
          ),
        if (notStarted.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Try a new mentor',
            style: AppTheme.mono(20, color: AppTheme.kSubheadingColor, weight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          for (final overview in notStarted)
            if (overview.lessons.isNotEmpty)
              LessonRow(
                lesson: overview.lessons.first,
                category: overview.category,
                subtitle: overview.category.tagline,
                onTap: () => _push(MentorPage(categoryId: overview.category.id)),
              ),
        ],
      ],
    );
  }
}

class _WeekCard extends StatelessWidget {
  final Set<String> days;
  final int streak;
  final bool todayDone;

  const _WeekCard({required this.days, required this.streak, required this.todayDone});

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final week = MentorEngine.lastSevenDays();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.kGreyShade800,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: AppTheme.kPrimaryColor, size: 34),
              const SizedBox(width: 8),
              Text(
                streak == 1 ? '1 day streak' : '$streak day streak',
                style: AppTheme.display(32, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            todayDone
                ? 'You learned something today. See you tomorrow.'
                : 'Finish a task or a quiz today to keep your streak going.',
            style: AppTheme.body(13, color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final day in week)
                Column(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: days.contains(MentorEngine.dayKey(day))
                            ? AppTheme.kPrimaryColor
                            : const Color(0x22FFFFFF),
                      ),
                      child: days.contains(MentorEngine.dayKey(day))
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(_letters[day.weekday - 1], style: AppTheme.mono(13, color: Colors.white54)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
