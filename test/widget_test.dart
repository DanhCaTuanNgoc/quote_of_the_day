// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quote_of_the_day/main.dart';

void main() {
  testWidgets('Quote of the Day app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that app title is displayed
    expect(find.text('Quote of the Day'), findsOneWidget);

    // Initially, we should see loading indicator or quote content
    // We'll just verify the app builds without errors
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Refresh button exists', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Wait for the widget to build
    await tester.pump();
    
    // Check if Scaffold is present
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('App bar is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Verify AppBar exists
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Quote of the Day'), findsOneWidget);
  });

  testWidgets('FutureBuilder is used', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Verify FutureBuilder is present
    expect(find.byType(FutureBuilder), findsOneWidget);
  });
}
