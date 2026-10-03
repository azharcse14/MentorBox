import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../logic/mentor_engine.dart';
import '../theme.dart';
import 'widgets.dart';

/// One mentor on the home screen, showing the category and the learner's
/// progress in it. [large] is the carousel look: bigger name plus the tagline.
class MentorCard extends StatelessWidget {
  final CategoryOverview overview;
  final VoidCallback onTap;
  final bool large;

  const MentorCard({super.key, required this.overview, required this.onTap, this.large = false});

  @override
  Widget build(BuildContext context) {
    final category = overview.category;
    final percent = (overview.ratio * 100).round();
    final l = AppLocalizations.of(context);

    return Card(
      elevation: 5,
      margin: large ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6) : EdgeInsets.zero,
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
                    if (overview.started)
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
                padding: large ? const EdgeInsets.fromLTRB(14, 12, 14, 14) : const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.mono(13, color: AppTheme.kGreyShade800, weight: FontWeight.w700),
                    ),
                    Text(
                      category.mentorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.display(large ? 28 : 22, color: Colors.white),
                    ),
                    if (large) ...[
                      const SizedBox(height: 4),
                      Text(
                        category.tagline,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.body(12, color: Colors.white70, height: 1.35),
                      ),
                    ],
                    const SizedBox(height: 8),
                    ProgressBar(value: overview.ratio, color: Colors.white),
                    const SizedBox(height: 6),
                    Text(
                      l.lessonsOf(overview.completedCount, overview.total),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.mono(12, color: Colors.white70),
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
    final l = AppLocalizations.of(context);
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: category.color,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(category.image, width: 84, height: 84, fit: BoxFit.cover),
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
                      style: AppTheme.display(20, color: Colors.white),
                    ),
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.mono(12, color: AppTheme.kGreyShade800, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    ProgressBar(value: overview.ratio, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(
                      l.lessonsOf(overview.completedCount, overview.total),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.mono(11, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
