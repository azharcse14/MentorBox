import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/data/content_seeder.dart';
import 'package:mentor_app_flutter/pages/mentor_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every category in index.json loads in every language with the same lessons and answers', () async {
    final index = jsonDecode(await rootBundle.loadString('assets/content/index.json')) as Map<String, dynamic>;
    final paths = (index['categories'] as List<dynamic>).cast<String>();
    expect(paths, isNotEmpty);

    Future<Map<String, dynamic>> load(String language, String path) async =>
        jsonDecode(await rootBundle.loadString('assets/content/$language/$path.json')) as Map<String, dynamic>;

    for (final path in paths) {
      final id = path.split('/').last;
      final dir = path.contains('/') ? path.substring(0, path.lastIndexOf('/') + 1) : '';
      final shapes = <String>[];
      for (final language in ContentSeeder.languages) {
        final category = await load(language, path);
        expect(category['id'], id);
        final levels = [
          for (final ref in category['levels'] as List<dynamic>)
            ref is String ? await load(language, '$dir$ref') : ref as Map<String, dynamic>,
        ];
        shapes.add(jsonEncode([
          for (final level in levels)
            for (final lesson in level['lessons'] as List<dynamic>)
              [level['id'], lesson['id'], for (final q in lesson['quiz'] as List<dynamic>) q['answer']],
        ]));
      }
      expect(shapes.toSet(), hasLength(1), reason: '$id differs between languages');
    }
  });

  test('tab groups name real categories, and only the host gets a home card', () async {
    final index = jsonDecode(await rootBundle.loadString('assets/content/index.json')) as Map<String, dynamic>;
    final ids = [for (final p in index['categories'] as List<dynamic>) (p as String).split('/').last];
    for (final group in MentorPage.tabGroups) {
      expect(ids, containsAll(group));
      expect(MentorPage.isTabOnly(group.first), isFalse);
      for (final id in group.skip(1)) {
        expect(MentorPage.isTabOnly(id), isTrue);
      }
    }
    expect(MentorPage.groupOf('finance'), ['finance']);
  });
}
