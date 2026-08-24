// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/app_bar_common.dart';
import 'package:evnmobile/src/htdct/common/enum/ticket_enum.dart';
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/grid_management/base/base_popup_wigget.dart';
import '../utils/alert_dialog_utils.dart';

class PopupBaseEquipmentScreen extends StatelessWidget {
  final String name;
  final BasePopupWidget child;
  final ActionTicketType actionType;
  final bool fromNotify;

  const PopupBaseEquipmentScreen({this.name, this.child, this.actionType, this.fromNotify});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommon(
        title: name,
        onPressedBack: () {
          if (actionType == ActionTicketType.edit) {
            hShowMyDialogOkCancel('Bạn có chắc muốn quay lại không?',
                secondFunction: () {
              Get.back();
            });
          } else {
            Get.back(result: false);
          }
        },
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              )),
              if (actionType != ActionTicketType.view && fromNotify!=true)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: EButton(
                            title: 'Huỷ',
                            titleColor: Colors.grey,
                            borderColor: Colors.grey,
                            color: Colors.white,
                            action: () {
                              if (actionType == ActionTicketType.edit) {
                                hShowMyDialogOkCancel(
                                    'Bạn có chắc muốn hủy không?',
                                    secondFunction: () {
                                  Get.back();
                                });
                              } else {
                                Get.back(result: false);
                              }
                            }),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: EButton(
                            title: 'Lưu',
                            action: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              child.saveData();
                            }),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

