import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/models/user.dart';
import 'package:mobile_app_dev/view/widgets/post_card.dart';

void main() {
  group('PostCard Widget Tests', () {
    final testPost = Post(
      id: 1,
      content: 'Test post content',
      imagePaths: '',
      date: DateTime.now(),
      userId: 1,
    );

    final testUser = User(
      id: 1,
      name: 'Abdullahi Jaafar',
      initials: 'AJ',
    );

    testWidgets('Displays post content and user name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(
              post: testPost,
              user: testUser,
              onDelete: () {},
              onRefresh: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test post content'), findsOneWidget);
      expect(find.text('Abdullahi Jaafar'), findsOneWidget);
      expect(find.text('AJ'), findsOneWidget);
    });

    testWidgets('Shows popup menu button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(
              post: testPost,
              user: testUser,
              onDelete: () {},
              onRefresh: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('Opens popup menu when actions button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(
              post: testPost,
              user: testUser,
              onDelete: () {},
              onRefresh: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text('Share (Email)'), findsOneWidget);
      expect(find.text('Share (X)'), findsOneWidget);
    });

    testWidgets('Delete callback runs when delete is tapped', (WidgetTester tester) async {
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(
              post: testPost,
              user: testUser,
              onDelete: () {
                deleted = true;
              },
              onRefresh: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(deleted, true);
    });

    testWidgets('Displays image when image path exists', (WidgetTester tester) async {
      final imagePost = Post(
        id: 1,
        content: 'Image post',
        imagePaths: '/fake/path/image.png',
        date: DateTime.now(),
        userId: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PostCard(
                post: imagePost,
                user: testUser,
                onDelete: () {},
                onRefresh: () {},
              ),
            )
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });
  });
}
