import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../logic/mentor_engine.dart';
import '../theme.dart';
import 'widgets.dart';

/// One mentor in the home grid. Same look as the original mentor cards,
/// now showing the category and the learner's progress in it.
class MentorCard extends StatelessWidget {
  final CategoryOverview overview;
  final VoidCallback onTap;

  const MentorCard({super.key, required this.overview, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final category = overview.category;
    final percent = (overview.ratio * 100).round();
    final l = AppLocalizations.of(context);

    return Card(
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
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
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
                      style: AppTheme.display(22, color: Colors.white),
                    ),
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
