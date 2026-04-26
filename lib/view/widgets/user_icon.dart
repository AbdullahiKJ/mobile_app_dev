import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget{
  final String initials;
  const UserIcon({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.topCenter,
      child: CircleAvatar(
        // backgroundImage: AssetImage("assets/images/strawberry.jpg"),
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(initials),
      ),
    );
  }
}