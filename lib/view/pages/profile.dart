import 'package:flutter/material.dart';
import 'package:mobile_app_dev/data/database_helper.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/models/user.dart';
import 'package:mobile_app_dev/view/widgets/post_card.dart';
import 'package:mobile_app_dev/view/widgets/user_icon.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Post> posts = [];
  List<User> users = [];
  bool editMode = false;
  List<int> postIdList = [];

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

  // Delete multiple posts
  Future<void> bulkDelete() async {
    int count = postIdList.length;
    await DatabaseHelper.instance.deleteMultiplePosts(postIdList);

    // Reload posts
    loadPosts();

    // Clear the id list and exit edit mode
    setState(() {
      postIdList.clear();
      editMode = false;
    });

    showToast(count);
  }

  // Show toast with the number of posts deleted
  void showToast(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$count message${count == 1 ? '' : 's'} deleted"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
      // Clear the selection when exiting edit mode
      if(!editMode) {
        postIdList.clear();
      }
    });
  }

  void updateList(bool? state, int id) {
    // Add the post id to the list when checked if it is not in the list
    if(state == true) {
      setState(() {
        if(!postIdList.contains(id)) {
          postIdList.add(id);
        }
      });
    }
    // Remove otherwise
    else {
      setState(() {
        postIdList.remove(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? userNameTheme = Theme.of(context).textTheme.titleLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 75),
          child: Row(
            children:[
              UserIcon(initials: 'AJ'),
              Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Text("Abdullahi Ja'afar", style: userNameTheme)
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if(!editMode)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: toggleEditMode,
                      ),
                    editMode ? IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: bulkDelete,
                    ) : Container(),
                    editMode ? IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: toggleEditMode,
                    ) : Container(),
                  ]
                )
              ),
            ])
        ),
        posts.isNotEmpty
          ? Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return Row (
                  children: [
                    if(editMode)
                      Checkbox(
                          value: postIdList.contains(posts[index].id),
                          onChanged: (bool? value) => updateList(value, posts[index].id)
                      ),
                    Expanded(
                      child: PostCard(
                          post: posts[index],
                          user: users.firstWhere((user) => user.id == posts[index].userId),
                          onDelete: () => deletePost(posts[index].id))
                    )
                  ]
                );
              },
            )
          )
          : Center(child: Text("No Posts yet"))
      ]
    );
  }
}