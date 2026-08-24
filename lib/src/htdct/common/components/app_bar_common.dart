// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constance/app_color.dart';

class AppBarCommon extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCommon({@required this.title, this.actions, this.centerTitle = false, this.onPressedBack, this.disableBack=false});
  final String title;
  final List<Widget> actions;
  final bool centerTitle;
  final Function onPressedBack;
  final bool disableBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: HighElectricAppColor.primary10,
      leading: disableBack?Container(): BackButton(
        color: Colors.white,
        onPressed: () {
          if(onPressedBack != null) {
            onPressedBack();
          } else {
            Get.back();
          }
        },
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            color: HighElectricAppColor.nature01,
            fontWeight: FontWeight.w600),
      ),
      titleSpacing: 0,
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

