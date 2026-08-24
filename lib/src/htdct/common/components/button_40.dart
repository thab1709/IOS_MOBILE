// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constance/app_color.dart';

class Button40 extends StatelessWidget {
  Button40({this.child, this.color, this.border});

  Widget child;
  Color color;
  BoxBorder border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color ?? HighElectricAppColor.primary10,
        border: border,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}

