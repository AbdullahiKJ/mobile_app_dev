import 'package:flutter/material.dart';
import 'package:mobile_app_dev/view/widgets/post_card.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Post {
  final int id;
  final String content;
  final String imagePath;
  final DateTime date;
  final int userId;

  const Post({
    required this.id,
    required this.content,
    required this.imagePath,
    required this.date,
    required this.userId
  });
}

class User {
  final int id;
  final String name;
  final String initials;

  String getInitials() {
    final List<String> names = name.split(' ');
    final initials = names[0][0] + names[names.length - 1][0];
    return initials;
  }

  User._(this.id, this.name, this.initials);

  factory User(int id, String name) {
    final List<String> names = name.split(' ');
    final initials = names[0][0] + names[names.length - 1][0];
    return User._(id, name, initials);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  Database? postDb;
  Database? userDb;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    String dbPath = await getDatabasesPath();
    postDb = await openDatabase(
        p.join('${dbPath}social'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE Posts(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, imagePath TEXT, date TEXT, userId INTEGER)"
          );
        },
        version: 1,
    );

    userDb = await openDatabase(
      p.join('${dbPath}social'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE Users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"
        );
      },
      version: 1,
    );
  }

  Future<void> getPosts() async {
    // Get the posts
    final List<Map<String, Object?>> postMaps = await postDb!.query('posts');

    // Convert the list of each post's fields into a list of `Post` objects.
    posts = [
      for (final {'id': id as int, 'content': content as String, 'imagePath': imagePath as String, 'date': date as String, 'userId': userId as int}
      in postMaps)
        Post(id: id, content: content, imagePath: imagePath, date: DateTime.parse(date), userId: userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    getPosts();

    return posts.isNotEmpty
      ? ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(post: posts[index]);
          },
      )
      : SizedBox();
  }
}