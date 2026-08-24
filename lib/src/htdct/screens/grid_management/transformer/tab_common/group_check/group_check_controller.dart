// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/tba_group_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../../../qltnkd/services/responsitory/images_repository.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../common/utils/common.dart';
import '../../../../../common/utils/progress_h_u_d.dart';
import '../../../../../services/responsitory/tba_repository.dart';
import '../../transformer_ticket_controller.dart';

class GroupCheckController extends GetxController {
  final _tbaRep = TBARepository();
  Rx<TBAGroupCheckModel> tbaGroupCheckModel = TBAGroupCheckModel().obs;
  final TransformerTicketController transformerTicketController = Get.find();
  final imageService = ImageRepository();

  Future getGroupCheck() async {
    ProgressHUD.show();
    final res = await _tbaRep.getGroupCheck(
        testType: transformerTicketController.testType,
        idTicket: transformerTicketController.ticketId,
        isBackground: true);
    if (res.isLoadSuccess) {
      tbaGroupCheckModel.value = res.data.tbaGroupCheckModel;
      final futures = <Future>[];
      if (tbaGroupCheckModel.value.groups != null) {
        for (var position = 0;
            position < tbaGroupCheckModel.value.groups.length;
            position++) {
          futures.add(getImagesUser(
              position, tbaGroupCheckModel.value.groups[position].idImage));
        }
      }
      await Future.wait(futures);
      ProgressHUD.dismiss();
      update();
    } else {
      ProgressHUD.dismiss();
      await hShowDialogOneButton(res.message);
    }
  }

  Future getImagesUser(int position, String imagesId) async {
    final res = await _tbaRep.getImages(
        idImages: imagesId,
        testType: transformerTicketController.testType,
        isBackground: true);
    if (res.isLoadSuccess) {
      tbaGroupCheckModel.value.groups[position].images = res.data.list;
      tbaGroupCheckModel.refresh();
    } else {
      //   await hShowDialogOneButton(res.message);
    }
  }

  Future addImage(List<File> files, String idUserImage) async {
    final location = await getCurrentPosition();

    final locationResult = await checkValidDistance(
        location: location,
        entity: transformerTicketController?.workModel?.entity);

    if (locationResult == null) {
      return;
    }

    final response = await imageService.upload(files);
    var imageStorageId = '';
    if (response.isLoadSuccess) {
      for (var i = 0; i < response.data.length; i++) {
        imageStorageId = response.data[i].imageStorageId;
      }
      await updateUser(
          imageStorageId: imageStorageId, idUserImage: idUserImage);
      await getGroupCheck();
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  Future updateUser({String imageStorageId, String idUserImage}) async {
    final response = await _tbaRep.updateUser(
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType,
        idUserImage: idUserImage,
        imageStorageId: imageStorageId);
    if (response.isLoadSuccess) {
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  Future removeImage(Images images, int positionUser) async {
    final response =
        await _tbaRep.deleteImages(imageStorageId: images.imageStorageId);
    if (response.isLoadSuccess) {
    } else {
      await hShowDialogOneButton(response.message);
    }
    tbaGroupCheckModel.refresh();
  }
}

