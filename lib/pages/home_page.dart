import 'package:flutter/material.dart';

import '../components/appbar.dart';
import '../components/mentor_card.dart';
import '../components/widgets.dart';
import '../data/mentor_repository.dart';
import '../l10n/app_localizations.dart';
import '../logic/mentor_engine.dart';
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
  final _pageController = PageController(viewportFraction: 0.86);

  bool _loading = true;
  String? _error;
  String? _userName;
  bool _hasName = true;
  bool _askedForName = false;
  List<CategoryOverview> _overviews = [];
  int _streak = 0;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final name = await _repo.getUserName();
      final overviews = await _repo.getAllOverviews();
      final days = await _repo.getActivityDays();
      if (!mounted) return;
      setState(() {
        _userName = name;
        _hasName = name != null;
        _overviews = overviews;
        _streak = MentorEngine.streak(days);
        _loading = false;
        _error = null;
      });
      if (name == null && !_askedForName) {
        _askedForName = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => _editName());
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '$e';
      });
    }
  }

  Future<void> _editName() async {
    final name = await showDialog<String>(
      context: context,
      barrierDismissible: _hasName,
      builder: (_) => _NameDialog(initial: _hasName ? _userName ?? '' : '', firstTime: !_hasName),
    );
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return;
    await _repo.setUserName(trimmed);
    if (!mounted) return;
    setState(() {
      _userName = trimmed;
      _hasName = true;
    });
  }

  Future<void> _pickLanguage() async {
    final l = AppLocalizations.of(context);
    final current = _repo.language;
    // Wrapped so "phone's language" (null) is not the same as dismissing.
    final picked = await showDialog<({String? code})>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: AppTheme.kSurface,
        title: Text(l.language, style: AppTheme.mono(22, weight: FontWeight.w700)),
        children: [
          for (final (code, label) in [(null, l.deviceLanguage), ('en', 'English'), ('bn', 'বাংলা')])
            ListTile(
              title: Text(label, style: AppTheme.body(16)),
              trailing: code == current ? const Icon(Icons.check, color: AppTheme.kPrimaryColor) : null,
              onTap: () => Navigator.of(context).pop((code: code)),
            ),
        ],
      ),
    );
    if (!mounted || picked == null || picked.code == current) return;
    setState(() => _loading = true);
    try {
      await _repo.setLanguage(picked.code);
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
        hasMissions: inProgress.isNotEmpty,
        onNameTap: _editName,
        onSavedTap: () => _push(const SavedPage()),
        onTodayTap: () => _push(const TodayPage()),
        onLanguageTap: _pickLanguage,
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
          child: Text(
            l.loadError(_error!),
            textAlign: TextAlign.center,
            style: AppTheme.body(14),
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l.exploreLabel,
                  style: AppTheme.mono(20, color: AppTheme.kSubheadingColor, weight: FontWeight.w600),
                ),
                Text(
                  l.exploreTagline,
                  textAlign: TextAlign.right,
                  style: AppTheme.body(14, weight: FontWeight.w600, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _overviews.length,
              onPageChanged: (index) => setState(() => _page = index),
              itemBuilder: (context, index) {
                final overview = _overviews[index];
                return MentorCard(
                  overview: overview,
                  onTap: () => _push(MentorPage(categoryId: overview.category.id)),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          _PageDots(count: _overviews.length, index: _page),
        ],
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
            style: AppTheme.mono(15, color: active ? Colors.white : AppTheme.kGreyShade800),
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

class _PageDots extends StatelessWidget {
  final int count;
  final int index;

  const _PageDots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == index ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index ? AppTheme.kPrimaryColor : const Color(0x33000000),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
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
        if (!widget.firstTime)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
        FilledButton(onPressed: _save, child: Text(l.saveName)),
      ],
    );
  }
}
