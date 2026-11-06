import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/theme.dart';

double ratio(Color a, Color b) {
  final (x, y) = (a.computeLuminance() + 0.05, b.computeLuminance() + 0.05);
  return x > y ? x / y : y / x;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('light secondary text reads on the light background (WCAG AA)', () {
    AppTheme.isDark = false;
    expect(ratio(AppTheme.kSubheadingColor, AppTheme.kScaffoldBackgroundColor), greaterThanOrEqualTo(4.5));
  });

  test('mentor card text reads on every category color (large text, 3:1)', () async {
    final index = jsonDecode(await rootBundle.loadString('assets/content/index.json')) as Map<String, dynamic>;
    for (final path in (index['categories'] as List<dynamic>).cast<String>()) {
      final json = jsonDecode(await rootBundle.loadString('assets/content/en/$path.json')) as Map<String, dynamic>;
      final hex = json['color'] as String;
      final color = Color(int.parse('FF${hex.substring(1)}', radix: 16));
      expect(ratio(AppTheme.onColor(color), color), greaterThanOrEqualTo(3.0), reason: '$path $hex');
    }
  });
}
