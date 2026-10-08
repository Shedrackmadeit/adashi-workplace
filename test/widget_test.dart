import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adashi_workplace/main.dart';

void main() {
  testWidgets('employee can accept rules and request membership', (tester) async {
    await tester.pumpWidget(const AdashiApp());
    await tester.tap(find.text('Groups'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Year Goals'));
    await tester.pumpAndSettle();
    final request = find.widgetWithText(FilledButton, 'Request to join');
    expect(tester.widget<FilledButton>(request).onPressed, isNull);
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.ensureVisible(request);
    await tester.tap(request);
    await tester.pumpAndSettle();
    expect(find.text('Request pending organizer approval'), findsOneWidget);
  });

  testWidgets('demo contribution needs explicit confirmation', (tester) async {
    await tester.pumpWidget(const AdashiApp());
    await tester.tap(find.text('Staff Monthly Circle'));
    await tester.pumpAndSettle();
    final report = find.text('Report demo contribution');
    await tester.ensureVisible(report);
    await tester.tap(report);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(find.byType(FilledButton).first).onPressed,
      isNotNull);
    await tester.tap(report);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();
    expect(find.text('Reported • awaiting confirmation'), findsOneWidget);
  });
}
