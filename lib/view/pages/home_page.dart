import 'package:flutter/material.dart';
import 'package:mobile_app_dev/view/widgets/post_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return PostCard();
        },
    );
  }
}