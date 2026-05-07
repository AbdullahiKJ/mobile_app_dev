import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/data/database_helper.dart';
import 'package:mobile_app_dev/view/pages/search.dart';
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

  group('Search Page Tests', () {
    testWidgets('Search page shows search bar and "No Posts Found" initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Search())));
      await tester.pumpAndSettle();

      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.text('No Posts Found'), findsOneWidget);
    });

    testWidgets('Entering text in search bar updates controller', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Search())));

      final searchBar = find.byType(TextField);
      await tester.enterText(searchBar, 'flutter');
      await tester.pump();

      expect(find.text('flutter'), findsOneWidget);
    });
  });
}
