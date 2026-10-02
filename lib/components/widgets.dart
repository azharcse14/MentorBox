import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme.dart';

/// Rounded progress bar used on cards, mentor pages and the quiz.
class ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color background;
  final double height;

  const ProgressBar({
    super.key,
    required this.value,
    this.color = AppTheme.kPrimaryColor,
    this.background = const Color(0x33FFFFFF),
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0).toDouble(),
        minHeight: height,
        color: color,
        backgroundColor: background,
      ),
    );
  }
}

/// The big orange call-to-action button from the original design.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppTheme.kPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.45 : 1,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.body(
                    18,
                    color: AppTheme.kScaffoldBackgroundColor,
                    weight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A message "spoken" by a category's mentor.
class MentorBubble extends StatelessWidget {
  final MentorCategory category;
  final String message;
  final bool dark;

  const MentorBubble({
    super.key,
    required this.category,
    required this.message,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = dark ? const Color(0x26FFFFFF) : Colors.white;
    final textColor = dark ? AppTheme.kScaffoldBackgroundColor : AppTheme.kGreyShade800;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: category.color, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(category.image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.mentorName,
                  style: AppTheme.mono(15, color: category.color, weight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(message, style: AppTheme.body(14, color: textColor, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A titled block inside a lesson (key points, tip, task, notes).
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(title, style: AppTheme.mono(18, weight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// A tappable row for one lesson, used in the saved and today lists.
class LessonRow extends StatelessWidget {
  final Lesson lesson;
  final MentorCategory? category;
  final String? subtitle;
  final VoidCallback onTap;

  const LessonRow({
    super.key,
    required this.lesson,
    required this.category,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final accent = category?.color ?? AppTheme.kPrimaryColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (category != null)
                  CircleAvatar(radius: 22, backgroundImage: AssetImage(category!.image))
                else
                  const CircleAvatar(radius: 22, backgroundColor: AppTheme.kPrimaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category?.name ?? '', style: AppTheme.mono(14, color: accent, weight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(lesson.title, style: AppTheme.body(15, weight: FontWeight.w600, height: 1.3)),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.body(13, color: AppTheme.kSubheadingColor, height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.kSubheadingColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
