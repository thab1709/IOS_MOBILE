// @dart=2.9
import 'package:flutter/material.dart';

class ELabel extends StatelessWidget {
  const ELabel({this.title, this.padding});

  final String title;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Text(title,
          style: TextStyle(
              color: Colors.black.withAlpha(200),
              fontSize: 16,
              fontWeight: FontWeight.w700)),
    );
  }
}

