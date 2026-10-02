import 'package:flutter/material.dart';

import 'data/content_seeder.dart';
import 'l10n/app_localizations.dart';
import 'pages/home_page.dart';
import 'theme.dart';

void main() {
  // Needed because the database is opened and seeded from bundled assets.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The app follows the device language (English or Bangla) unless one is
    // picked in the app.
    return ListenableBuilder(
      listenable: Listenable.merge([ContentSeeder.appLocale, ContentSeeder.appTheme]),
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: switch (ContentSeeder.appTheme.value) {
          'light' => ThemeMode.light,
          'dark' => ThemeMode.dark,
          _ => ThemeMode.system,
        },
        // No fade: AppTheme colors switch at once, so the theme should too.
        themeAnimationStyle: AnimationStyle.noAnimation,
        builder: (context, child) {
          final dark = Theme.of(context).brightness == Brightness.dark;
          if (AppTheme.isDark != dark) {
            AppTheme.isDark = dark;
            // Widgets read AppTheme colors directly instead of Theme.of, so
            // rebuild all of them once. State (open pages, quiz) is kept.
            void rebuild(Element element) {
              element.markNeedsBuild();
              element.visitChildren(rebuild);
            }

            (context as Element).visitChildren(rebuild);
          }
          return child!;
        },
        locale: ContentSeeder.appLocale.value,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    );
  }
}
