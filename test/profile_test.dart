import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/view/pages/profile.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Profile Page Tests', () {
    testWidgets('Profile page displays user name and "No Posts yet" initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Profile())));
      await tester.pumpAndSettle();

      expect(find.text("Abdullahi Ja'afar"), findsOneWidget);
      expect(find.text('No Posts yet'), findsOneWidget);
    });

    testWidgets('Edit button exists and toggles view', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Profile())));
      await tester.pumpAndSettle();

      final editButton = find.byIcon(Icons.edit);
      expect(editButton, findsOneWidget);

      await tester.tap(editButton);
      await tester.pump();

      // After clicking edit, the cancel button should appear
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });
  });
}
