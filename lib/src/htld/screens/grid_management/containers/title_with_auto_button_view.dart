// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';

import 'e_label.dart';

class TitleWithAutoButtonView extends StatelessWidget {
  const TitleWithAutoButtonView(this.title, this.autoFill, {this.horizontalPadding = 0, this.actionType = ActionType.edit});

  final Function autoFill;
  final String title;
  final double horizontalPadding;
  final ActionType actionType;
  @override
  Widget build(BuildContext context) {
     return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: ELabel(title: title)),
          const SizedBox(width: 20,),
          Opacity(
            opacity: actionType == ActionType.view ? 0 : 1,
            child: InkWell(
              onTap: actionType == ActionType.view ? null: autoFill ,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.highlightColor70,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(AppStrings.autoFill, style: TextStyle(color: Colors.white),),
              ),
            ),
          )
        ],
      ),
    );
  }
}

