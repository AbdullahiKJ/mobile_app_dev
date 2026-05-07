import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/models/user.dart';
import 'package:mobile_app_dev/view/pages/post_details.dart';

void main() {
  final testUser = User(id: 1, name: 'John Doe', initials: 'JD');
  final testPost = Post(
    id: 1,
    content: 'Test content',
    imagePaths: '',
    date: DateTime.now(),
    userId: 1,
  );

  testWidgets('PostPage displays post content and user name', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PostPage(
          post: testPost,
          user: testUser,
          onDelete: () {},
          onRefresh: () {},
        ),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Test content'), findsOneWidget);
  });

  testWidgets('PostPage has an AppBar with a back button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PostPage(
          post: testPost,
          user: testUser,
          onDelete: () {},
          onRefresh: () {},
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
  });
}
