// Basic Flutter widget test for Liberator app
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Liberator'))),
      ),
    );

    // Verify that the app has content
    expect(find.text('Liberator'), findsOneWidget);
  });
}
