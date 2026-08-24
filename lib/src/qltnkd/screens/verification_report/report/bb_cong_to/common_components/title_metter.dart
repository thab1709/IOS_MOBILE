// @dart=2.9
import 'package:flutter/material.dart';

class TitleMeter extends StatelessWidget {
  const TitleMeter({@required this.title, this.isRequire = false, Key key})
      : super(key: key);
  final String title;
  final bool isRequire;

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(
      children: [
        TextSpan(text: title.replaceAll(':', ''), style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black)),
        if(isRequire == true)
        const TextSpan(text: '*', style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.red)),

      ]
    ));
  }
}

