// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/app_common/edit_picture/add_text_screen.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/violate_popup/violate_popup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../../../app_common/utils/utils.dart';
import '../../../../../../../../htld/common/utils/alert_dialog_utils.dart';
import '../../../../../../../common/components/button_40.dart';
import '../../../../../../../common/constance/app_color.dart';
import '../../../../../../../common/constance/app_icon.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/day_night/popups/images_model.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/dialog_picture.dart';

Widget ImageCamera(
    {ViolatePopupController controller,
    BuildContext context,
    List<Images> images,
    int problem,
    bool required = false,
    String title,
    bool viewMode = false}) {
  return Column(
    crossAxisAlignment:
        required ? CrossAxisAlignment.start : CrossAxisAlignment.end,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(
              title,
              style: Styles.titleTextField,
            ),
            if (required)
              const Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              )
          ],
        ),
      ),
      Wrap(
        children: [
          Visibility(
            visible: images.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogPicture(
                                listImage: images,
                                removeImage: controller.removeImage,
                                addImage: (item) =>
                                    controller.addImage(item, problem),
                                isGroup: viewMode);
                          });
                    },
                    child: Button40(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            HighElectricAppIcon.collections,
                            width: 18,
                            height: 20,
                            fit: BoxFit.scaleDown,
                          ),
                          Positioned(
                              top: 3,
                              right: 3,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: HighElectricAppColor.brandColor04,
                                  border: Border.all(
                                      color: HighElectricAppColor.nature01),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  images.length.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: HighElectricAppColor.nature01,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!viewMode)
            GestureDetector(
              onTap: () async {
                if (images.length == 10) {
                  await showDialogOneButton(
                      HighElectricStrings.overloadImagesLength);
                } else {
                  final result = await showSelectMultiImageBottomSheet(
                      context, 10 - (images != null ? images.length : 0));
                  if (result != null && result is List<File> && result.isNotEmpty) {
                    final editImageResult = await Get.to(EditImageScreen(
                      files: result,
                    ));
                    if (editImageResult != null) {
                      await controller.addImage(editImageResult, problem);
                    }
                  }
                }
              },
              child: Button40(
                child: SvgPicture.asset(
                  HighElectricAppIcon.camera,
                  color:
                      (controller.invalid.value && images.isEmpty && required)
                          ? Colors.red
                          : Colors.white,
                  width: 18,
                  height: 20,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
        ],
      ),
    ],
  );
}

