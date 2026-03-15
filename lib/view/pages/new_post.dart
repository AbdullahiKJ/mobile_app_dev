import 'package:flutter/material.dart';

class NewPost extends StatefulWidget
{
  const NewPost({super.key});
  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final FocusNode focusNode = FocusNode();

  // todo: create post
  void _createPost() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _createPost(),
          ),
        ]
      ),
      body: Center(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Icon(Icons.account_circle),
            SizedBox(
              width: 250,
              height: 500,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Write your message here',
                ),
                focusNode: focusNode,
                autofocus: true,
              )
            )
          ],
        )
      ),
    );
  }
}