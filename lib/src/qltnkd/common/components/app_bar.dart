// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RAppBar({@required this.title, Key key, this.action}) : super(key: key);

  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: RAppColor.highlightColor70,
      elevation: 1,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        '$title',
        style: const TextStyle(fontSize: TextSize.normal),
      ),
      actions: [action ?? Container()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

