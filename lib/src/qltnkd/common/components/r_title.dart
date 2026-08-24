// @dart=2.9
import 'package:flutter/material.dart';

class RTitle extends StatelessWidget {
  const RTitle({@required this.title, Key key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }
}

