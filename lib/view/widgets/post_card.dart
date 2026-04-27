import 'package:autoscalable_container/autoscalable_container.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/view/widgets/user_icon.dart';
import 'dart:io';

import '../../models/user.dart';
import '../pages/new_post.dart';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final User user;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const PostCard({
    super.key,
    required this.post,
    required this.user,
    required this.onDelete,
    required this.onRefresh
  });

  @override
  Widget build(BuildContext context) {
    return AutoScalableContainer(
      gradient: LinearGradient(
        colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]
      ),
      margin: EdgeInsetsGeometry.all(0),
      borderRadius: 0,
      child: Card(
        elevation: 2,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              UserIcon(initials: user.initials),
              _Post(post: post, user: user, onDelete: onDelete, onRefresh: onRefresh,),
            ],
          ),
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  final Post post;
  final User user;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const _Post({
    super.key,
    required this.post,
    required this.user,
    required this.onDelete,
    required this.onRefresh
  });

  @override
  Widget build(BuildContext context) {
    final List<String> images = post.imagePaths.isNotEmpty ? post.imagePaths.split('|') : [];

    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostDetails(post: post, userName: user.name, onDelete: onDelete, onRefresh: onRefresh,),

          if (images.isNotEmpty) ...[
            const SizedBox(height: 8),
            _PostImages(images: images),
          ]
        ]
      ),
    );
  }
}

class _PostDetails extends StatelessWidget {
  final Post post;
  final String userName;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const _PostDetails({
    super.key,
    required this.post,
    required this.userName,
    required this.onDelete,
    required this.onRefresh
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle? userNameTheme = Theme.of(context).textTheme.titleLarge;
    final TextStyle? contentTheme = Theme.of(context).textTheme.bodyLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsetsGeometry.all(5),
                    child: Text(userName, style: userNameTheme)
                ),
            ),
            _Actions(post: post, onDelete: onDelete, onRefresh: onRefresh,)
          ]
        ),
        Padding(
            padding: EdgeInsetsGeometry.all(5),
            child: Text(post.content ?? "Placeholder text", style: contentTheme),
        )
      ]
    );
  }
}

class _PostImages extends StatelessWidget {
  final List<String> images;
  const _PostImages({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return _singleImage(images[0]);
    } else {
      return _gridImages();
    }
  }

  Widget _singleImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: Colors.grey,
              child: const Icon(Icons.broken_image),
            );
          }
        ),
      )
    );
  }

  Widget _gridImages() {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length > 4 ? 4 : images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox.expand(
              child: Image.file(
                File(images[index]),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image),
                  );
                }
              ),
            ),
          );
        },
      )
    );
  }
}

class _Actions extends StatelessWidget {
  final Post post;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const _Actions({
    super.key,
    required this.post,
    required this.onDelete,
    required this.onRefresh,
  });

  void _sharePostEmail(BuildContext context) async {
    final email = Email(
      subject: "Sharing Post",
      body: post.content,
      recipients: [],
      attachmentPaths: post.imagePaths.isNotEmpty ? post.imagePaths.split("|") : [],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  void _sharePostX(BuildContext context) async {
    final encodedText = Uri.encodeComponent(post.content ?? '');

    final url = "https://x.com/intent/post?text=$encodedText";
    final Uri uri = Uri.parse(url);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),

      onSelected: (value) async {
        if(value == 'edit') {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPost(post: post, isEditing: true),
            ),
          );
          if(result == true) {
            onRefresh();
          }
        }
        else if (value == 'delete') {
          // Delete the post
          onDelete();

          // Show delete notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Post deleted"),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (value == 'shareEmail') {
          _sharePostEmail(context);
        } else if (value == 'shareX') {
          _sharePostX(context);
        }
      },

      itemBuilder: (context) => [
        // Only edit/delete posts if the user id is 1 (My Posts)
        if(post.userId == 1)
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
        if(post.userId == 1)
          const PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
        const PopupMenuItem(
          value: 'shareEmail',
          child: Text('Share (Email)'),
        ),
        const PopupMenuItem(
          value: 'shareX',
          child: Text('Share (X)'),
        ),
      ],
    );
  }
}
