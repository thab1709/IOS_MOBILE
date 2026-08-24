// @dart=2.9
import 'package:flutter/material.dart';

import '../../../common/themes/colorx.dart';

class TButtonWidget extends StatelessWidget {
  const TButtonWidget({this.text, this.textColor, this.bgColor, this.width});

  final String text;
  final Color textColor;
  final Color bgColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: AppColor.highlightColor70, width: 1),
            borderRadius: BorderRadius.circular(4)),
        height: 40,
        width: width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
        ));
  }
}

