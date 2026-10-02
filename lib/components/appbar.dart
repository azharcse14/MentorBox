import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final bool hasMissions;
  final VoidCallback onNameTap;
  final VoidCallback onSavedTap;
  final VoidCallback onTodayTap;

  const CustomAppBar({
    super.key,
    required this.userName,
    required this.hasMissions,
    required this.onNameTap,
    required this.onSavedTap,
    required this.onTodayTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppBar(
      toolbarHeight: 110,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.kScaffoldBackgroundColor,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 24, right: 12),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onNameTap,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.welcomeBack,
                      style: AppTheme.mono(18, color: AppTheme.kSubheadingColor, weight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.display(35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              tooltip: l.savedLessons,
              onPressed: onSavedTap,
              icon: const Icon(Icons.favorite_border, size: 26, color: AppTheme.kGreyShade800),
            ),
            const SizedBox(width: 6),
            IconButton(
              tooltip: l.todaysMissions,
              onPressed: onTodayTap,
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none, size: 26, color: AppTheme.kGreyShade800),
                  if (hasMissions)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: const BoxDecoration(
                          color: AppTheme.kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}
