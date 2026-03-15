import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 2,
      child:  Card(
        elevation: 2,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              _UserImage(),
              _Post(),
              _Actions(),
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
  const _Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        children: <Widget>[_PostDetails(), _PostImage()],
      ),
    );
  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? userNameTheme = Theme.of(context).textTheme.titleLarge;
    final TextStyle? contentTheme = Theme.of(context).textTheme.labelSmall;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text("Abdullahi Ja'afar", style: userNameTheme),
        Text("Lorem ipsum...", style: contentTheme)],
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 2, child: Image.asset("assets/images/eye.jpg"));
  }
}

class _Actions extends StatelessWidget {
  const _Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[_Options(), _PostTimeStamp()],
    );
  }
}

class _Options extends StatelessWidget {
  const _Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Icon(Icons.more_horiz)
    );
  }
}

class _PostTimeStamp extends StatelessWidget {
  const _PostTimeStamp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? timeTheme = Theme.of(context).textTheme.labelSmall;
    return Expanded(
      flex: 2,
      child: Text("5:15", style: timeTheme),
    );
  }
}

