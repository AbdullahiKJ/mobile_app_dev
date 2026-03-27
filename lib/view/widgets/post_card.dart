import 'package:autoscalable_container/autoscalable_container.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_dev/view/pages/home_page.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

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
              _UserImage(),
              _Post(post: post),
              _Actions(post: post),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.topCenter,
      child: CircleAvatar(
        backgroundImage: AssetImage("assets/images/strawberry.jpg"),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  final Post post;
  const _Post({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        children: post.imagePath.isNotEmpty
            ? <Widget>[_PostDetails(post: post), _PostImage(post: post)]
            : <Widget>[_PostDetails(post: post)],
      ),
    );
  }
}

class _PostDetails extends StatelessWidget {
  final Post post;
  const _PostDetails({super.key, required this.post});

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

class _PostImage extends StatelessWidget {
  final Post post;
  const _PostImage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: Image(
            image: AssetImage(post.imagePath),
            // Fallback image
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return Image(
                image: AssetImage("assets/images/eye.jpg")
              );
            })
      )
    );
  }
}

class _Actions extends StatelessWidget {
  final Post post;
  const _Actions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_Options(), _PostTimeStamp(post: post)],
    );
  }
}

class _Options extends StatelessWidget {
  const _Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        child: Icon(Icons.more_horiz)
      )
    );
  }
}

class _PostTimeStamp extends StatelessWidget {
  final Post post;
  const _PostTimeStamp({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final TextStyle? timeTheme = Theme.of(context).textTheme.labelSmall;
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Text('${post.date.hour}:${post.date.minute}', style: timeTheme)
      ),
    );
  }
}

