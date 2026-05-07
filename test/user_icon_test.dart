import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/view/widgets/user_icon.dart';

void main() {
  group('UserIcon Widget Tests', () {
    testWidgets('Displays user initials', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserIcon(initials: 'AJ'),
          ),
        ),
      );

      expect(find.text('AJ'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}