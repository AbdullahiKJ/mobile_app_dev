import 'package:autoscalable_container/autoscalable_container.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_dev/models/post.dart';
import 'package:mobile_app_dev/view/widgets/user_icon.dart';
import 'dart:io';

import '../../models/user.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final User user;
  final void onDelete;
  const PostCard({super.key, required this.post, required this.user, required this.onDelete});

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
              _Post(post: post, user: user,),
              _Actions(post: post),
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
  const _Post({super.key, required this.post, required this.user});

  @override
  Widget build(BuildContext context) {
    final List<String> images = post.imagePaths.isNotEmpty ? post.imagePaths.split('|') : [];

    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostDetails(post: post, userName: user.name,),

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
  const _PostDetails({super.key, required this.post, required this.userName});

  @override
  Widget build(BuildContext context) {
    final TextStyle? userNameTheme = Theme.of(context).textTheme.titleLarge;
    final TextStyle? contentTheme = Theme.of(context).textTheme.bodyLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
            padding: EdgeInsetsGeometry.all(5),
            child: Text("Abdullahi Ja'afar", style: userNameTheme)
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
  const _Actions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final TextStyle? timeTheme = Theme.of(context).textTheme.labelSmall;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.more_horiz),
        const SizedBox(height: 8),
        Text(
          '${post.date.hour}:${post.date.minute}',
          style: timeTheme,
        ),      ],
    );
  }
}
