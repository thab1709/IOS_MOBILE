// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/models/image_report.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/images_repository.dart';
import 'package:get/get.dart';

class ReportPhotoController extends GetxController {
  RxList<ImageReport> images = <ImageReport>[].obs;
  final service = ImageRepository();
  final RxBool uploadSuccess = false.obs;
  FieldModel fieldModel;

  void setImages(List<ImageReport> imagesData) {
    images.assignAll(imagesData ?? []);
    images.refresh();
  }

  void remove(ImageReport item) {
    images.remove(item);
    images.refresh();
    final values = fieldModel.getArrValue()
      ..removeWhere((element) => element == item.imageStorageId);
    fieldModel.arrayValueToString(values);
  }

  Future<List<ImageReport>> uploadImage(List<File> files) async {
    final response = await service.upload(files);

    if (response.isLoadSuccess) {
      images.addAll(response.data);
      images.refresh();
      final values = fieldModel.getArrValue()..addAll(response.data.map((e) => e.imageStorageId).toList());
      fieldModel.arrayValueToString(values);
      update();
      return response.data;
    } else {
      await hShowDialogOneButton(response.message);
    }
    return null;
  }

  Future getImageByIDs() async {
    final res = await service.getImagesByIDs(fieldModel.getArrValue());

    if (res.isLoadSuccess) {
      images.assignAll(res.data);
      images.refresh();
    } else {
      await hShowDialogOneButton(res?.message ?? '');
    }
  }
}

