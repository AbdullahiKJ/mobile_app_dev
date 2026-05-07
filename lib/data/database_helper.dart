import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Use a singleton to ensure only one instance of the database helper exists
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Get the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // if it doesn't exist create a new database
    _database = await _initDB('social.db');
    return _database!;
  }

  // Initialise the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the database tables for users and posts
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT,
        imagePaths TEXT,
        date TEXT,
        userId INTEGER,
        FOREIGN KEY (userId) REFERENCES Users (id)
      )
    ''');
  }

  // Insert Post
  Future<int> insertPost(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('Posts', row);
  }

  // Get All Posts
  Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await instance.database;
    return await db.query('Posts', orderBy: 'date DESC');
  }

  // Get All Posts from a given user
  Future<List<Map<String, dynamic>>> getUserPosts(int id) async {
    final db = await instance.database;
    return await db.query('Posts', where: 'userId = ?', whereArgs: [id], orderBy: 'date DESC');
  }

  // Update Post
  Future<int> updatePost(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update(
      'Posts',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete Post
  Future<int> deletePost(int id) async {
    final db = await instance.database;
    return await db.delete(
      'Posts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete Multiple Posts
  Future<int> deleteMultiplePosts(List<int> ids) async {
    final db = await instance.database;
    return await db.delete(
      'Posts',
      where: 'id IN (${ids.join(',')})',
    );
  }

  // Search Posts
  Future<List<Map<String, dynamic>>> searchPosts(String query) async {
    final db = await instance.database;
    return await db.query(
      'Posts',
      where: 'content LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'date DESC',
    );
  }

  // Get All Users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('Users', orderBy: 'id ASC');
  }

  // Get a user by id
  Future<Map<String, dynamic>?> getUser(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'Users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first; // returns a Map
    } else {
      return null; // no user found
    }
  }

  // Add user for testing
  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('users', row);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}