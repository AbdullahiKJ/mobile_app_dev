import 'package:flutter/material.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/data/database_helper.dart';
import 'package:mobile_app_dev/view/widgets/post_card.dart';

import '../../models/user.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Post> posts = [];
  List<User> users = [];
  final SearchController _controller = SearchController();

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  // Search for posts in the database
  Future<void> _searchPosts() async{
    // Get posts from the database
    final data = await DatabaseHelper.instance.searchPosts(_controller.text.trim());
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
    _searchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 50),
          child: SearchBar(
            controller: _controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onSubmitted: (_) => _searchPosts(),
            leading: const Icon(Icons.search),
          )
        ),

        Expanded(
          child: posts.isNotEmpty
            ? ListView.builder(
              padding: EdgeInsets.only(top:0),
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
              return PostCard(
                post: posts[index],
                user: users.firstWhere((user) => user.id == posts[index].userId),
                onDelete: () => deletePost(posts[index].id),);
              },
            )
            : Center(child: Text("No Posts Found"))
        )
      ]
    );
  }
}
