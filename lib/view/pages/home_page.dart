import 'package:flutter/material.dart';
import 'package:mobile_app_dev/data/database_helper.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/view/widgets/post_card.dart';

import '../../models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    loadPosts();
    loadUsers();
  }

  // Fetch all posts
  Future<void> loadPosts() async {
    // Get posts from the database
    final data = await DatabaseHelper.instance.getPosts();
    // Update the posts variable with a list of posts
    setState(() {
      posts = data.map((e) => Post.fromMap(e)).toList();
    });
  }

  // Fetch all users
  Future<void> loadUsers() async {
    // Get users from the database
    final data = await DatabaseHelper.instance.getUsers();
    // Update the users variable with a list of users
    setState(() {
      users = data.map((e) => User.fromMap(e)).toList();
    });
  }

  // Delete a post with a given id
  Future<void> deletePost(int id) async {
    await DatabaseHelper.instance.deletePost(id);
    // Reload all posts after deletion
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return posts.isNotEmpty
      ? ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(
              post: posts[index],
              user: users.firstWhere((user) => user.id == posts[index].userId),
              onDelete: () => deletePost(posts[index].id)
            );
          },
      )
      : Center(child: Text("No Posts yet"));
  }
}