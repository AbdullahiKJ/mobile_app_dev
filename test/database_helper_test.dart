import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/data/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite for local tests
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('Insert post returns valid id', () async {
    final db = DatabaseHelper.instance;
    final id = await db.insertPost({
      'content': 'Test post',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });

    expect(id, isNotNull);
    expect(id, greaterThan(0));
  });

  test('Get Posts returns a list of posts', () async {
    final db = DatabaseHelper.instance;
    await db.insertPost({
      'content': 'Test post',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });
    final posts = await db.getPosts();

    expect(posts, isNotEmpty);
    expect(posts.length, greaterThan(0));
  });

  test('Get User Posts returns a list of posts from  given user', () async {
    final db = DatabaseHelper.instance;
    await db.insertPost({
      'content': 'Test post',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });
    final posts = await db.getUserPosts(1);

    expect(posts, isNotEmpty);
    expect(posts.length, greaterThan(0));
  });

  test('Update Posts returns the number of changes made', () async {
    final db = DatabaseHelper.instance;
    final id = await db.insertPost({
      'content': 'Test post',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });

    final changes = await db.updatePost({
      'id': id,
      'content': 'Test post edit',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });

    expect(changes, isNotNull);
    expect(changes, greaterThan(0));
  });

  test('Delete Posts returns the number of posts deleted', () async {
    final db = DatabaseHelper.instance;
    final id = await db.insertPost({
      'content': 'Test post',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });

    final deleted = await db.deletePost(id);

    expect(deleted, isNotNull);
    expect(deleted, greaterThan(0));
  });

  test('Delete Multiple Posts returns the number of posts deleted', () async {
    final db = DatabaseHelper.instance;
    final post_1 = await db.insertPost({
      'content': 'Test post',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });
    final post_2 = await db.insertPost({
      'content': 'Test post',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });

    final deleted = await db.deleteMultiplePosts([post_1, post_2]);

    expect(deleted, isNotNull);
    expect(deleted, greaterThan(1));
  });

  test('Search Posts returns a list of posts that match the search query', () async {
    final db = DatabaseHelper.instance;
    await db.insertPost({
      'content': 'Test post',
      'imagePaths': '',
      'date': DateTime.now().toIso8601String(),
      'userId': 1,
    });

    final posts = await db.searchPosts('test');

    expect(posts, isNotEmpty);
    expect(posts.length, greaterThan(0));
  });

  test('Get All Users Posts returns a list of users', () async {
    final db = DatabaseHelper.instance;

    await db.insertUser({
      'name': 'Test User',
    });

    final users = await db.getUsers();

    expect(users, isNotEmpty);
    expect(users.length, greaterThan(0));
  });

  test('Get user by id returns a user with the given id', () async {
    final db = DatabaseHelper.instance;
    await db.insertUser({
      'name': 'Test User',
    });

    final user = await db.getUser(1);

    expect(user, isNotEmpty);
    expect(user!['id'], 1);
  });

}