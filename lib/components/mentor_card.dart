import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../logic/mentor_engine.dart';
import '../theme.dart';
import 'widgets.dart';

/// One mentor on the home screen, showing the category and the learner's
/// progress in it.
class MentorCard extends StatelessWidget {
  final CategoryOverview overview;
  final VoidCallback onTap;
  const MentorCard({super.key, required this.overview, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final category = overview.category;
    final fg = AppTheme.onColor(category.color);
    final fgSoft = fg.withAlpha(0xB3);
    final percent = (overview.ratio * 100).round();
    final l = AppLocalizations.of(context);

    // One node for screen readers: the texts plus the tap, read as a button.
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: category.color,
          // InkWell on top so the ripple also shows over the photo.
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(category.image, fit: BoxFit.cover),
                        if (overview.completedCount > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xCC000000),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                overview.finished ? l.finished : l.percentDone(percent),
                                style: AppTheme.mono(13, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.mono(13, color: fgSoft, weight: FontWeight.w700),
                        ),
                        Text(
                          category.mentorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.display(22, color: fg),
                        ),
                        const SizedBox(height: 8),
                        ProgressBar(value: overview.ratio, color: fg, background: fg.withAlpha(0x33)),
                        const SizedBox(height: 6),
                        Text(
                          l.lessonsOf(overview.completedCount, overview.total),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.mono(13, color: fgSoft),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(onTap: onTap),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One mentor as a compact row, for the home list view.
class MentorListTile extends StatelessWidget {
  final CategoryOverview overview;
  final VoidCallback onTap;

  const MentorListTile({super.key, required this.overview, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final category = overview.category;
    final fg = AppTheme.onColor(category.color);
    final fgSoft = fg.withAlpha(0xB3);
    final l = AppLocalizations.of(context);
    return MergeSemantics(
      child: Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: category.color,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 84),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(category.image, width: 84, fit: BoxFit.cover),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.mentorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.display(20, color: fg),
                          ),
                          Text(
                            category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.mono(13, color: fgSoft, weight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          ProgressBar(value: overview.ratio, color: fg, background: fg.withAlpha(0x33)),
                          const SizedBox(height: 4),
                          Text(
                            l.lessonsOf(overview.completedCount, overview.total),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.mono(13, color: fgSoft),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
