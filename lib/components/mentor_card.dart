import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../logic/mentor_engine.dart';
import '../theme.dart';
import 'widgets.dart';

/// One mentor in the home carousel. Same look as the original mentor cards,
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

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: category.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(category.image, fit: BoxFit.cover),
                  if (overview.started)
                    Positioned(
                      top: 12,
                      right: 12,
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
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: AppTheme.mono(14, color: AppTheme.kGreyShade800, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(category.mentorName, style: AppTheme.display(28, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(
                    category.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.body(12, color: Colors.white70, height: 1.35),
                  ),
                  const SizedBox(height: 10),
                  ProgressBar(value: overview.ratio, color: Colors.white),
                  const SizedBox(height: 6),
                  Text(
                    l.cardStats(overview.completedCount, overview.total, overview.levels.length),
                    style: AppTheme.mono(12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
