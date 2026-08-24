// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/themes/colorx.dart';

class EAppbar extends StatelessWidget implements PreferredSizeWidget {
  const EAppbar({@required this.title, this.actions, this.color, this.brightness});

  final String title;
  final Color color;
  final List<Widget> actions;
  final SystemUiOverlayStyle brightness;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle: brightness ?? SystemUiOverlayStyle.dark,
      elevation: 1,
      backgroundColor: color ?? AppColor.highlightColor70,
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

