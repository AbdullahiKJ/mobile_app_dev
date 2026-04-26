import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_dev/data/database_helper.dart';

import '../widgets/user_icon.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<File> selectedImages = [];

  int charCount = 0;
  final int maxChars = 280;

  @override
  void initState() {
    super.initState();

    // Open the keyboard automatically when the page opens by requesting focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    // Update the character counter when changes are made to the text controller
    _controller.addListener(() {
      setState(() {
        charCount = _controller.text.length;
      });
    });
  }

  void _createPost() async {
    final content = _controller.text.trim();

    // Prevent empty posts by exiting early
    if (content.isEmpty && selectedImages.isEmpty) {
      return;
    }

    // Join the paths of all the selected image
    final imagePathsString =  selectedImages.map((img) => img.path).join('|');

    // Create post map
    final postMap = {
      'content': content,
      'imagePaths': imagePathsString,
      'date': DateTime.now().toIso8601String(),
      'userId': 1, // default user
    };

    await DatabaseHelper.instance.insertPost(postMap);
    Navigator.pop(context);
  }

  void _openGallery() async {
    // Ignore input if there is more than 4 images selected already
    if (selectedImages.length >= 4) return;

    final pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        for (var img in pickedImages) {
          if (selectedImages.length < 4) {
            selectedImages.add(File(img.path));
          }
        }
      });
    }
  }

  void _openCamera() async {
    // Ignore input if there is more than 4 images selected already
    if (selectedImages.length >= 4) return;

    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        selectedImages.add(File(pickedImage.path));
      });
    }
  }

  // Build the image layout
  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedImages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2x2 grid for 4 images
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.file(
                selectedImages[index],
                fit: BoxFit.cover,
              ),
            ),
            // Remove button
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImages.removeAt(index);
                  });
                },
                child: Container(
                  color: Colors.black54,
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _createPost,
          ),
        ]
      ),

      // Main input area
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserIcon(initials: 'AJ'),
            // Padding between the user icon and text box
            SizedBox(width: 10),

            // TextBox
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    maxLines: null,
                    maxLength: maxChars,
                    decoration: const InputDecoration(
                      hintText: "What's happening?",
                      border: InputBorder.none,
                      counterText: "",
                    ),
                    scrollPhysics: const BouncingScrollPhysics(),
                  ),
                  const SizedBox(height: 10),

                  // Show images if any selected
                  if (selectedImages.isNotEmpty)
                    _buildImageGrid(),
                ]
                ),
              )
            )
          ],
        )
      ),

      // Gallery, Camera and Character count
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.photo),
              onPressed: _openGallery,
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: _openCamera,
            ),
            const Spacer(),
            Text(
                "$charCount/$maxChars",
                style: TextStyle(color: charCount == maxChars ? Colors.red: Colors.black)
            ),
          ],
        ),
      ),
    );
  }
}