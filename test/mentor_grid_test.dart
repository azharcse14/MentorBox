import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/components/mentor_card.dart';
import 'package:mentor_app_flutter/data/models.dart';
import 'package:mentor_app_flutter/l10n/app_localizations.dart';
import 'package:mentor_app_flutter/logic/mentor_engine.dart';

void main() {
  // The home grid uses a fixed card ratio; make sure a card's text still fits
  // on a small phone with large text.
  testWidgets('mentor card fits the home grid on a small phone', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    const category = MentorCategory(
      id: 'cse',
      name: 'Computer Science and Engineering',
      mentorName: 'Professor Byte the Long Named',
      tagline: '',
      description: '',
      image: 'assets/images/career.jpg',
      color: Colors.teal,
      sortOrder: 0,
      messages: {},
    );
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: const MediaQueryData(size: Size(320, 640), textScaler: TextScaler.linear(1.3)),
        child: Scaffold(
          body: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.72,
            children: [
              MentorCard(
                overview: const CategoryOverview(
                  category: category,
                  levels: [],
                  lessons: [],
                  progress: {},
                  state: null,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
  });

  testWidgets('list row and carousel card fit on a small phone', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    const overview = CategoryOverview(
      category: MentorCategory(
        id: 'cse',
        name: 'Computer Science and Engineering',
        mentorName: 'Professor Byte the Long Named',
        tagline: 'A long tagline that needs to wrap onto more than one line here',
        description: '',
        image: 'assets/images/career.jpg',
        color: Colors.teal,
        sortOrder: 0,
        messages: {},
      ),
      levels: [],
      lessons: [],
      progress: {},
      state: null,
    );
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: const MediaQueryData(size: Size(320, 640), textScaler: TextScaler.linear(1.3)),
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              MentorListTile(overview: overview, onTap: () {}),
              SizedBox(height: 400, child: MentorCard(overview: overview, large: true, onTap: () {})),
            ],
          ),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
  });
}
