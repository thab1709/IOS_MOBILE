// @dart=2.9
import 'package:flutter/material.dart';

import '../../../common/constance/app_color.dart';

class EButtonWidget extends StatelessWidget {
  EButtonWidget({this.text, this.textColor, this.bgColor, this.width});
  String text;
  Color textColor;
  Color bgColor;
  double width;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: HighElectricAppColor.primary10, width: 1),
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

