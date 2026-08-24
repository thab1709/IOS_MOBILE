// @dart=2.9
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BadgeApp extends StatelessWidget {
  final String title;
  final double size;
  final Color borderColor;

  const BadgeApp({Key key, this.size, this.borderColor, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .05),
      child: Center(
        child:

        FittedBox(
          fit: BoxFit.cover,
          child:
          Text(title??'', style: TextStyle(
              // fontSize: 16,
              fontWeight: FontWeight.bold,
              color: borderColor)),)
      ),
    );
  }
}
