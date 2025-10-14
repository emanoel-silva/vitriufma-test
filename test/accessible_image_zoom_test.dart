import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitrine_ufma/app/core/components/accessible_image_zoom.dart';

void main() {
  testWidgets('AccessibleImageZoom widget builds correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AccessibleImageZoom(
            image: 'logo.png',
            altText: 'Test image',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );

    // Verify that the widget builds without errors
    expect(find.byType(AccessibleImageZoom), findsOneWidget);
  });

  testWidgets('AccessibleImageZoom has proper semantics',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AccessibleImageZoom(
            image: 'logo.png',
            altText: 'Test image',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );

    // Verify that the widget has semantics
    expect(find.byType(Semantics), findsWidgets);
  });
}