import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/data/database_helper.dart';
import 'package:mobile_app_dev/view/pages/new_post.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Helper to clear DB between tests
  Future<void> clearDatabase() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('Posts');
    await db.delete('Users');
  }

  setUp(() async {
    await clearDatabase();
  });

  group('NewPost Page Tests', () {
    testWidgets('Initial state has empty text field and zero character count', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: NewPost()));

      expect(find.text("What's happening?"), findsOneWidget);
      expect(find.text("0/280"), findsOneWidget);
    });

    testWidgets('Character count updates when typing', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: NewPost()));

      await tester.enterText(find.byType(TextField), 'Hello Flutter');
      await tester.pump();

      expect(find.text('13/280'), findsOneWidget);
    });

    testWidgets('Send button exists', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: NewPost()));
      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });
}
