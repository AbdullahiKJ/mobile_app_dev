import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/models/post.dart';

void main() {
  test('Post.fromMap creates valid Post object', () {
    final map = {
      'id': 1,
      'content': 'Hello world',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    };

    final post = Post.fromMap(map);

    expect(post.id, 1);
    expect(post.content, 'Hello world');
    expect(post.userId, 1);
  });
}