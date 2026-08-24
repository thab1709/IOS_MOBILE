// @dart=2.9
import 'package:evnmobile/src/app_common/rescource/images_common.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/photo/report_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageView extends StatelessWidget {
  ImageView({this.enable = true, this.fieldModel});

  final bool enable;
  final FieldModel fieldModel;
  final limitImageNumber = 10;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ReportPhotoScreen(
              fieldModel: fieldModel,
              isEnable: enable,
            ));
      },
      child: Container(
        height: 46,
        child: Stack(
          children: [
           Container(
             padding: const EdgeInsets.only(top: 10, right: 8),
             child: const Icon(Icons.photo_camera_rounded),
           ),
            Positioned(
                top: 1,
                right: 1,
                child: Text(
              fieldModel.getArrValue().length.toString(),
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
            ))
          ],
        ),
      ),
    );
  }
}

