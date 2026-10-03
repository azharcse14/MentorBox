import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app_flutter/components/switch_animation.dart';

void main() {
  testWidgets('overlay runs change once, then goes away', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    final context = tester.element(find.byType(Scaffold));
    var changed = 0;
    var finished = false;
    playThemeSwitch(context, toDark: true, change: () async => changed++).then((_) => finished = true);
    await tester.pump(const Duration(milliseconds: 500));
    expect(changed, 0);
    expect(find.byType(AbsorbPointer), findsWidgets);
    await tester.pumpAndSettle();
    expect(changed, 1);
    expect(finished, isTrue);
    expect(find.byIcon(Icons.nightlight_round), findsNothing);
  });
}
