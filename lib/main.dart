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
    return ValueListenableBuilder<Locale?>(
      valueListenable: ContentSeeder.appLocale,
      builder: (context, locale, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    );
  }
}
