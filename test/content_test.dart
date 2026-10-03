import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/data/content_seeder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every category in index.json loads in every language with the same lessons and answers', () async {
    final index = jsonDecode(await rootBundle.loadString('assets/content/index.json')) as Map<String, dynamic>;
    final ids = (index['categories'] as List<dynamic>).cast<String>();
    expect(ids, isNotEmpty);

    for (final id in ids) {
      final shapes = <String>[];
      for (final language in ContentSeeder.languages) {
        final category =
            jsonDecode(await rootBundle.loadString('assets/content/$language/$id.json')) as Map<String, dynamic>;
        expect(category['id'], id);
        shapes.add(jsonEncode([
          for (final level in category['levels'] as List<dynamic>)
            for (final lesson in level['lessons'] as List<dynamic>)
              [level['id'], lesson['id'], for (final q in lesson['quiz'] as List<dynamic>) q['answer']],
        ]));
      }
      expect(shapes.toSet(), hasLength(1), reason: '$id differs between languages');
    }
  });
}
