// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:self_management_app/main.dart';

void main() {
  testWidgets('Self Management App smoke test', (WidgetTester tester) async {
    // Initialize locale data for tests
    await initializeDateFormatting('id_ID', null);
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SelfManagementApp());

    // Verify that the app loads properly
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
