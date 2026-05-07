import 'package:flutter/material.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/models/user.dart';

import '../widgets/post_card.dart';
import '../widgets/user_icon.dart';

class PostPage extends StatelessWidget {
  final Post post;
  final User user;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const PostPage({
    super.key,
    required this.post,
    required this.user,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        elevation: 2,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              UserIcon(initials: user.initials),
              PostBody(post: post, user: user, onDelete: onDelete, onRefresh: onRefresh,),
            ],
          ),
        ),
      ),
    );
  }
}