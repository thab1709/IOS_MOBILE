// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/themes/colorx.dart';

class TButton40 extends StatelessWidget {
  const TButton40({this.child, this.color, this.border});

  final Widget child;
  final Color color;
  final BoxBorder border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color ?? AppColor.highlightColor70,
        border: border,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}

