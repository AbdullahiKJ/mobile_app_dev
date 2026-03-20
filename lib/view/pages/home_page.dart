import 'package:flutter/material.dart';
import 'package:mobile_app_dev/view/widgets/post_card.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Database? database;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    String dbPath = await getDatabasesPath();
    database = await openDatabase(
        p.join('${dbPath}social'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE Posts(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, image_path TEXT, date TEXT)"
          );
        },
        version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return PostCard();
        },
    );
  }
}