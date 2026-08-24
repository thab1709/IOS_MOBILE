// @dart=2.9
import 'package:flutter/material.dart';

class EText extends StatelessWidget {
  const EText({this.title, this.value, this.childFlex});

  final String title;
  final String value;
  final int childFlex;

  static const _valueTextStyle =
      TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title ?? '',
          )),
          const SizedBox(width: 24,),
          Expanded(
              flex: childFlex ?? 1,
              child: Text(
                value ?? '',
                textAlign: TextAlign.end,
                style: _valueTextStyle,
              )),
        ],
      ),
    );
  }
}

