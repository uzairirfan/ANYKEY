import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  final Color color;

  UserHomePage(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}