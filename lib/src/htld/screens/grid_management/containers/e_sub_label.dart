// @dart=2.9
import 'package:flutter/material.dart';

class ESubLabel extends StatelessWidget {
  const ESubLabel({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500));
  }
}

