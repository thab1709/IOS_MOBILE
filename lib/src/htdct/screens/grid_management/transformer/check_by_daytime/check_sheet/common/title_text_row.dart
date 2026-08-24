// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/themes/styles.dart';

class TitleTextRow extends StatelessWidget {
  const TitleTextRow({@required this.title,@required this.text, this.isVertical = false});

  final String title;
  final String text;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = Get.size.width >= 600;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: !isVertical ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Styles.headerTitle),
           SizedBox(width: isLargeScreen? 100:50),
           Flexible(child: Text(text, style: Styles.textNormal, textAlign: TextAlign.right,)),
        ],
      ) : Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Styles.headerTitle),
            const SizedBox(height: 10,),
            Text(text, style: Styles.textNormal, textAlign: TextAlign.left,)
          ],
        ),
      ),
    );
  }
}

