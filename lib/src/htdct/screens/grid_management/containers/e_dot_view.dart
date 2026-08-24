// @dart=2.9
import 'package:evnmobile/src/htdct/common/themes/colorx.dart';
import 'package:flutter/material.dart';

class EDotView extends StatelessWidget {
  final int currentIndex;
  final int lenght;

  EDotView({this.currentIndex, this.lenght});

  List<int> data;

  @override
  Widget build(BuildContext context) {
    data = List<int>.generate(lenght, (index) => index);
    return buildIndicator();
  }

  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.all(4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: currentIndex == index
              ? AppColor.highlightColor70
              : Colors.grey.shade300),
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: data.map(buildDot).toList(),
    );
  }
}

