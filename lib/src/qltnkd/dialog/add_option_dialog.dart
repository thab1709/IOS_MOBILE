// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showDialogAddOption({
  @required Function(String) positiveAction,
}) async {
  String content;
  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 150,
                // maxHeight: 250
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 26, left: 26, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RTextField(
                          title: '',
                          line: 3,
                          hintText: 'Vui lòng nhập',
                          margin: const EdgeInsets.only(right: 26),
                          onChange: (value) {
                            content = value;
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RButton(
                                title: 'Hủy',
                                titleColor: Colors.black,
                                color: Colors.grey.shade100,
                                action: () {
                                  Get.back();
                                }),
                            const SizedBox(
                              width: 24,
                            ),
                            RButton(title: 'Thêm', action: () {
                                  if (content?.isNotEmpty == true) {
                                    positiveAction(content);
                                    Get.back();
                                  }
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
      barrierDismissible: true);
}

