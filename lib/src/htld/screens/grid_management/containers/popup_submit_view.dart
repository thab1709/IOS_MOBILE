// @dart=2.9

import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:flutter/material.dart';

class PopupSubmitView extends StatelessWidget {
  final Function() onSave;

  const PopupSubmitView({this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        EButton(title: 'Huỷ', action: () => {
          Navigator.pop(context)}, color: AppColor.colorOrange,),
        const SizedBox(width: 24,),
        EButton(title: 'Lưu', action: onSave)
      ],
    );
  }
}
