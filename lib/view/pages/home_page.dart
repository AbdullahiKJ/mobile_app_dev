import 'package:flutter/material.dart';
import 'package:mobile_app_dev/data/database_helper.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/view/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    loadPosts();
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
            return PostCard(post: posts[index], onDelete: () => deletePost(posts[index].id),);
          },
      )
      : Center(child: Text("No Posts yet"));
  }
}