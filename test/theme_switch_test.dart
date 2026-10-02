import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/data/content_seeder.dart';
import 'package:mentor_app_flutter/main.dart';
import 'package:mentor_app_flutter/theme.dart';

void main() {
  testWidgets('picking a theme recolors widgets that read AppTheme', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(AppTheme.isDark, isFalse);
    final before = tester.widgetList<Text>(find.byType(Text)).first.style?.color;

    ContentSeeder.appTheme.value = 'dark';
    await tester.pump();
    expect(AppTheme.isDark, isTrue);
    final after = tester.widgetList<Text>(find.byType(Text)).first.style?.color;
    expect(after, isNot(before));

    ContentSeeder.appTheme.value = 'light';
    await tester.pump();
    expect(AppTheme.isDark, isFalse);
  });
}
