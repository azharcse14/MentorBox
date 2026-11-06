import 'package:flutter/material.dart';

import '../components/appbar.dart';
import '../components/mentor_card.dart';
import '../components/switch_animation.dart';
import '../data/content_seeder.dart';
import '../components/widgets.dart';
import '../data/mentor_repository.dart';
import '../l10n/app_localizations.dart';
import '../logic/mentor_engine.dart';
import '../logic/reminder.dart';
import '../theme.dart';
import 'lesson_page.dart';
import 'mentor_page.dart';
import 'saved_page.dart';
import 'today_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = MentorRepository.instance;

  bool _loading = true;
  String? _error;
  String? _userName;
  bool _hasName = true;
  bool _askedForName = false;
  List<CategoryOverview> _overviews = [];
  int _streak = 0;
  bool _todayDone = false;
  bool _reminderOn = false;
  String _layout = 'grid';
  String _query = '';
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final name = await _repo.getUserName();
      final overviews = await _repo.getAllOverviews();
      final days = await _repo.getActivityDays();
      final reminderOn = await _repo.getReminderOn();
      final layout = await _repo.getHomeLayout();
      final (hour, minute) = await _repo.getReminderTime();
      if (!mounted) return;
      setState(() {
        _userName = name;
        _hasName = name != null;
        _overviews = overviews;
        _streak = MentorEngine.streak(days);
        _todayDone = days.contains(MentorEngine.dayKey(DateTime.now()));
        _reminderOn = reminderOn;
        _layout = layout == 'list' ? 'list' : 'grid';
        _reminderTime = TimeOfDay(hour: hour, minute: minute);
        _loading = false;
        _error = null;
      });
      // Opening the app reschedules, so the plan always starts from today.
      Reminder.refresh();
      if (name == null && !_askedForName) {
        _askedForName = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => _editName());
      }
    } catch (e) {
      // The learner sees a plain message; the details go to the log.
      debugPrint('Home load failed: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '$e';
      });
    }
  }

  void _setLayout(String layout) {
    setState(() => _layout = layout);
    _repo.setHomeLayout(layout);
  }

  void _retry() {
    setState(() {
      _loading = true;
      _error = null;
    });
    _load();
  }

  Future<void> _toggleReminder() async {
    final on = !_reminderOn;
    if (on && !await Reminder.requestPermission()) return;
    await _repo.setReminderOn(on);
    await Reminder.refresh();
    if (!mounted) return;
    setState(() => _reminderOn = on);
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(context: context, initialTime: _reminderTime);
    if (picked == null) return;
    await _repo.setReminderTime(picked.hour, picked.minute);
    await Reminder.refresh();
    if (!mounted) return;
    setState(() => _reminderTime = picked);
  }

  /// Theme, language and the daily reminder, in one sheet.
  Future<void> _openSettings() async {
    final l = AppLocalizations.of(context);
    // Theme and language repaint the whole app, so picking one closes the
    // sheet first. The reminder settings change in place.
    final picked = await showModalBottomSheet<({String kind, String? value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.kSurface,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheet) {
          void refreshSheet() {
            if (sheetContext.mounted) setSheet(() {});
          }

          Widget choices(String kind, String? current, List<(String?, String)> options) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (value, label) in options)
                      ChoiceChip(
                        label: Text(label, style: AppTheme.body(14, height: 1.2)),
                        selected: value == current,
                        onSelected: (_) => Navigator.of(sheetContext).pop((kind: kind, value: value)),
                      ),
                  ],
                ),
              );

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    child: Text(l.settings, style: AppTheme.mono(22, weight: FontWeight.w700)),
                  ),
                  ListTile(
                    leading: Icon(AppTheme.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
                    title: Text(l.theme, style: AppTheme.body(16)),
                  ),
                  choices(
                      'theme', _repo.theme, [(null, l.deviceTheme), ('light', l.lightTheme), ('dark', l.darkTheme)]),
                  ListTile(
                    leading: const Icon(Icons.translate),
                    title: Text(l.language, style: AppTheme.body(16)),
                  ),
                  choices('language', _repo.language, [(null, l.deviceLanguage), ('en', 'English'), ('bn', 'বাংলা')]),
                  if (Reminder.supported)
                    SwitchListTile(
                      secondary: const Icon(Icons.alarm),
                      title: Text(l.dailyReminder, style: AppTheme.body(16)),
                      subtitle: Text(l.dailyReminderHint, style: AppTheme.body(13, color: AppTheme.kSubheadingColor)),
                      value: _reminderOn,
                      activeThumbColor: AppTheme.kPrimaryColor,
                      onChanged: (_) async {
                        await _toggleReminder();
                        refreshSheet();
                      },
                    ),
                  if (Reminder.supported && _reminderOn)
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(l.reminderTime, style: AppTheme.body(16)),
                      trailing: Text(_reminderTime.format(context), style: AppTheme.mono(16)),
                      onTap: () async {
                        await _pickReminderTime();
                        refreshSheet();
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
    switch (picked) {
      case (kind: 'theme', :final value):
        await _setTheme(value);
      case (kind: 'language', :final value):
        await _setLanguage(value);
    }
  }

  Future<void> _editName() async {
    final name = await showDialog<String>(
      context: context,
      barrierDismissible: _hasName,
      builder: (_) => _NameDialog(initial: _hasName ? _userName ?? '' : '', firstTime: !_hasName),
    );
    if (!mounted) return;
    // Skipping on first launch keeps the default name, so we don't ask again.
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty && _hasName) return;
    final saved = trimmed.isEmpty ? AppLocalizations.of(context).defaultName : trimmed;
    await _repo.setUserName(saved);
    if (!mounted) return;
    setState(() {
      _userName = saved;
      _hasName = true;
    });
  }

  Future<void> _setLanguage(String? code) async {
    final current = _repo.language;
    if (!mounted || code == current) return;
    final fromCode = current ?? ContentSeeder.deviceLanguage();
    final toCode = code ?? ContentSeeder.deviceLanguage();
    try {
      if (fromCode == toCode) {
        await _repo.setLanguage(code);
      } else {
        // The reseed runs while the letter flips, behind the overlay.
        await playLanguageSwitch(context, fromCode: fromCode, toCode: toCode, change: () async {
          await _repo.setLanguage(code);
          await _load();
        });
        return;
      }
    } catch (e) {
      // The reseed runs in one transaction, so the old content is still intact.
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '$e';
      });
      return;
    }
    await _load();
  }

  Future<void> _setTheme(String? mode) async {
    final current = _repo.theme;
    if (!mounted || mode == current) return;
    final toDark = switch (mode) {
      'dark' => true,
      'light' => false,
      _ => MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    if (toDark == AppTheme.isDark) return _repo.setTheme(mode);
    await playThemeSwitch(context, toDark: toDark, change: () => _repo.setTheme(mode));
  }

  Future<void> _push(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    await _load();
  }

  /// Categories the learner has started and not finished, most recent first.
  List<CategoryOverview> get _inProgress {
    final list = _overviews.where((o) => o.started && !o.finished && o.nextLesson != null).toList();
    list.sort((a, b) => b.state!.lastActiveAt.compareTo(a.state!.lastActiveAt));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final inProgress = _inProgress;
    return Scaffold(
      appBar: CustomAppBar(
        userName: _userName ?? AppLocalizations.of(context).defaultName,
        hasMissions: inProgress.isNotEmpty && !_todayDone,
        onNameTap: _editName,
        onSavedTap: () => _push(const SavedPage()),
        onTodayTap: () => _push(const TodayPage()),
        onSettingsTap: _openSettings,
      ),
      body: SafeArea(top: false, child: _buildBody(inProgress)),
    );
  }

  Widget _buildBody(List<CategoryOverview> inProgress) {
    final l = AppLocalizations.of(context);
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.kPrimaryColor));
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.loadError,
                textAlign: TextAlign.center,
                style: AppTheme.body(14),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _retry, child: Text(l.retry)),
            ],
          ),
        ),
      );
    }

    final current = inProgress.isEmpty ? null : inProgress.first;

    return RefreshIndicator(
      color: AppTheme.kPrimaryColor,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _Hero(
              avatars: _overviews.map((o) => o.category.image).toList(),
              streak: _streak,
            ),
          ),
          const SizedBox(height: 24),
          if (current != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: _ContinueCard(
                overview: current,
                onTap: () => _push(LessonPage(lessonId: current.nextLesson!.id)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.exploreLabel,
                        style: AppTheme.mono(20, color: AppTheme.kSubheadingColor, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.exploreTagline,
                        style: AppTheme.body(13, color: AppTheme.kSubheadingColor, height: 1.35),
                      ),
                    ],
                  ),
                ),
                for (final (layout, icon, tooltip) in [
                  ('grid', Icons.grid_view, l.layoutGrid),
                  ('list', Icons.view_list, l.layoutList),
                ])
                  IconButton(
                    icon: Icon(icon),
                    tooltip: tooltip,
                    isSelected: _layout == layout,
                    visualDensity: VisualDensity.compact,
                    color: AppTheme.kSubheadingColor,
                    selectedIcon: Icon(icon, color: AppTheme.kPrimaryColor),
                    onPressed: () => _setLayout(layout),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: TextField(
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
              style: AppTheme.body(15, height: 1.3),
              decoration: InputDecoration(
                hintText: l.searchMentors,
                hintStyle: AppTheme.body(15, color: AppTheme.kSubheadingColor, height: 1.3),
                prefixIcon: Icon(Icons.search, color: AppTheme.kSubheadingColor),
                filled: true,
                fillColor: AppTheme.kSurface,
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ),
          ..._buildSections(l),
        ],
      ),
    );
  }

  /// Mentors split into life skills and tech courses, filtered by search.
  List<Widget> _buildSections(AppLocalizations l) {
    // Tab-only categories (e.g. the CSE roadmap) open from their host card.
    final cards = _overviews.where((o) {
      if (MentorPage.isTabOnly(o.category.id)) return false;
      if (_query.isEmpty) return true;
      final c = o.category;
      return '${c.name} ${c.mentorName} ${c.tagline}'.toLowerCase().contains(_query);
    }).toList();
    if (cards.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Text(l.noMentorFound, style: AppTheme.body(14, color: AppTheme.kSubheadingColor)),
        ),
      ];
    }
    final life = cards.where((o) => _lifeSkills.contains(o.category.id)).toList();
    final courses = cards.where((o) => !_lifeSkills.contains(o.category.id)).toList();
    return [
      for (final (title, list) in [(l.sectionLifeSkills, life), (l.sectionCourses, courses)])
        if (list.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: Text(title.toUpperCase(),
                style: AppTheme.mono(15, color: AppTheme.kPrimaryColor, weight: FontWeight.w700)),
          ),
          _buildMentors(list),
        ],
    ];
  }

  // ponytail: hardcoded split; move to a "group" field in index.json if more groups come.
  static const _lifeSkills = {
    'programming',
    'career',
    'communication',
    'productivity',
    'finance',
    'mindset',
    'health',
    'leadership',
    'study',
    'creativity',
  };

  Widget _buildMentors(List<CategoryOverview> cards) {
    void open(CategoryOverview o) => _push(MentorPage(categoryId: o.category.id));
    if (_layout == 'list') {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => MentorListTile(
          overview: cards[index],
          onTap: () => open(cards[index]),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        // Photo plus a text block that grows with the phone's text size.
        mainAxisExtent: 130 + MediaQuery.textScalerOf(context).scale(100),
      ),
      itemBuilder: (context, index) => MentorCard(
        overview: cards[index],
        onTap: () => open(cards[index]),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final List<String> avatars;
  final int streak;

  const _Hero({required this.avatars, required this.streak});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTheme.mono(35, weight: FontWeight.w600),
            children: [
              TextSpan(text: l.heroBefore),
              TextSpan(
                text: l.heroHighlight,
                style: AppTheme.display(42, color: AppTheme.kPrimaryColor),
              ),
              TextSpan(text: l.heroAfter),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _OverlappingAvatars(images: avatars.take(4).toList()),
            const Spacer(),
            _StreakChip(streak: streak),
          ],
        ),
      ],
    );
  }
}

class _StreakChip extends StatelessWidget {
  final int streak;

  const _StreakChip({required this.streak});

  @override
  Widget build(BuildContext context) {
    final active = streak > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppTheme.kPrimaryColor : AppTheme.kSurface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            size: 20,
            color: active ? Colors.white : AppTheme.kSubheadingColor,
          ),
          const SizedBox(width: 4),
          Text(
            active ? AppLocalizations.of(context).streakDays(streak) : AppLocalizations.of(context).noStreak,
            style: AppTheme.mono(15, color: active ? Colors.white : AppTheme.kText),
          ),
        ],
      ),
    );
  }
}

/// The round mentor photos that pop in once when the home screen opens.
/// (The original version never rebuilt during the animation, so the photos
/// could stay invisible. ScaleTransition listens to the animation itself.)
class _OverlappingAvatars extends StatefulWidget {
  final List<String> images;

  const _OverlappingAvatars({required this.images});

  @override
  State<_OverlappingAvatars> createState() => _OverlappingAvatarsState();
}

class _OverlappingAvatarsState extends State<_OverlappingAvatars> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pop;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pop = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // "Remove animations" in the phone settings: show the photos at once.
    if (MediaQuery.disableAnimationsOf(context)) _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pop,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final image in widget.images)
            Align(
              widthFactor: 0.62,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: CircleAvatar(radius: 22, backgroundImage: AssetImage(image)),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final CategoryOverview overview;
  final VoidCallback onTap;

  const _ContinueCard({required this.overview, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final category = overview.category;
    final next = overview.nextLesson!;
    return Material(
      color: AppTheme.kGreyShade800,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(radius: 26, backgroundImage: AssetImage(category.image)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).continueWith(category.mentorName),
                      style: AppTheme.mono(14, color: category.color, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      next.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.body(16, color: Colors.white, weight: FontWeight.w600, height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    ProgressBar(value: overview.ratio, color: category.color, height: 5),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.play_circle_fill, color: AppTheme.kPrimaryColor, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Asks for the learner's name the first time, and lets them change it later.
class _NameDialog extends StatefulWidget {
  final String initial;
  final bool firstTime;

  const _NameDialog({required this.initial, required this.firstTime});

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: AppTheme.kSurface,
      title: Text(
        widget.firstTime ? l.nameDialogFirstTitle : l.nameDialogChangeTitle,
        style: AppTheme.mono(22, weight: FontWeight.w700),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(hintText: l.nameHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.firstTime ? l.skip : MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(onPressed: _save, child: Text(l.saveName)),
      ],
    );
  }
}
