// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/violate_inspection_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../app_common/shared/app_shared.dart';
import '../../../../../../../app_common/utils/utils.dart';
import '../../../../../../../qltnkd/common/utils/alert_dialog_utils.dart';
import '../../../../../../../qltnkd/services/responsitory/images_repository.dart';
import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/inspection_type.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../common/utils/common.dart';
import '../../../../../../models/day_night/popups/images_model.dart';
import '../../../../../../models/option_model.dart';
import '../../../../../../services/responsitory/line_repository.dart';
import '../../../../transformer/transformer_ticket_controller.dart';

class ViolatePopupController extends GetxController {
  final timeFollowController = TextEditingController();
  final timeFinishController = TextEditingController();

  ViolateModel model =
      ViolateModel(images: [], trackingStatus: ContentOptions.following.value);
  final service = ImageRepository();
  final lineRepo = LineRepository();
  RxInt typeViolation = 0.obs;
  String nameViolate;
  String id;
  RxBool invalid = false.obs;
  final TransformerTicketController transformerTicketController = Get.find();
  LatLng position;
  List<OptionModelString> abnormalOptions = [];
  RxList<OptionModelString> listLine = RxList.empty();
  RxList<OptionModelString> listWorkByLine = RxList.empty();
  List<OptionModel> listViolate = [
    OptionModel('Vi phạm hành lang', 1),
    OptionModel('Công trường thi công', 2),
    OptionModel('Cây hành lang', 3),
  ];

  Future<void> addImage(List<File> files, int problem) async {
    final response = await service.upload(files);

    if (response.isLoadSuccess) {
      for (var i = 0; i < response.data.length; i++) {
        model.images.add(Images(
            problems: problem,
            imageStorageId: response.data[i].imageStorageId,
            url: response.data[i].url));
      }
    } else {
      await rShowDialogOneButton(response.message);
    }
    invalid.refresh();
  }

  void refreshWidget() {
    // invalid.value = false;
    invalid.refresh();
  }

  Future removeImage(Images image) async {
    model.images.remove(image);
    invalid.refresh();
  }

  List<Images> getImageByProblem(int problem) {
    return model.images
            ?.where((element) => element.problems == problem)
            ?.toList() ??
        List.empty();
  }

  bool checkValid() {
    return typeViolation.value == 0 ||
        model.violateId.isNullOrBlank() ||
        (typeViolation.value == ViolateInspectionType.violateLobby &&
            (model.namePointViolate.isNullOrBlank() ||
                model.subjectViolate.isNullOrBlank() ||
                model.standingDistance == null ||
                model.horizontalDistance == null ||
                model.statusViolate.isNullOrBlank() ||
                model.constructionProperties.isNullOrBlank())) ||
        (typeViolation.value == ViolateInspectionType.violateCorridorTree &&
            (model.treeType.isNullOrBlank() ||
                model.height.isNullOrBlank() ||
                model.address.isNullOrBlank() ||
                model.location.isNullOrBlank() ||
                model.statusViolate.isNullOrBlank() ||
                model.distanceNearest.isNullOrBlank())) ||
        (typeViolation.value == ViolateInspectionType.violateRoadworks &&
            (model.constructionName.isNullOrBlank() ||
                model.constructionUnit.isNullOrBlank() ||
                model.address.isNullOrBlank() ||
                model.constructionStatus.isNullOrBlank())) ||
        model.aboutColumn.isNullOrBlank() ||
        model.timeViolate == null ||
        model.solution.isNullOrBlank() ||
        model.trackingStatus == null ||
        getImageByProblem(0).isEmpty;
  }

  bool checkValidDateTimeValid() {
    if (model.timeViolate != null &&
        model.endViolate != null &&
        DateTime.parse(model.endViolate)
            .isBefore(DateTime.parse(model.timeViolate))) {
      return false;
    }
    return true;
  }

  Future<void> getData({String id}) async {
    final response =
        await lineRepo.getViolateInspectDetail(id: id, isBackground: true);
    if (response.isLoadSuccess) {
      model = response.data.model;

      if (model.timeViolate != null) {
        timeFollowController.text = model.timeViolate
            .fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmm);
      }
      if (model.endViolate != null) {
        timeFinishController.text = model.endViolate
            .fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmm);
      }

      position = LatLng(
          model.latitude?.toDoubleOrNull(), model.longitude?.toDoubleOrNull());

      invalid.refresh();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future<void> onSubmit({bool fromAbnormal = false}) async {
    if (position == null) {
      await hShowDialogOneButton('Lỗi lấy bị trí thiết bị');
      return;
    }
    model.latitude = position.latitude.toString();
    model.longitude = position.longitude.toString();
    if (checkValid()) {
      invalid.value = true;
      invalid.refresh();
      await rShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
    } else if (!checkValidDateTimeValid()) {
      invalid.value = true;
      invalid.refresh();
      await rShowDialogOneButton(HighElectricStrings.invalidDateTime);
    } else {
      if (id != null && fromAbnormal == false) {
        model.id = id;
        model.nameViolate = nameViolate;
        model.typeViolation = typeViolation.value;
        final response = await lineRepo.updateViolateTicket(
          params: model.toJson(),
          idTicket: id,
        );

        if (response.isLoadSuccess) {
          Get.back();
        } else {
          await rShowDialogOneButton(response.message);
        }
      } else {
        model.id = fromAbnormal ? id : transformerTicketController.ticketId;
        model.typeViolation = typeViolation.value;
        model.nameViolate = nameViolate;
        final response = await lineRepo.createViolateTicket(
          params: model.toJson(),
          idTicket: transformerTicketController.ticketId,
        );

        if (response.isLoadSuccess) {
          Get.back();
        } else {
          await rShowDialogOneButton(response.message);
        }
      }
    }
  }

  Future<LatLng> getPosition() async {
    final location = await getCurrentPosition();
    if (location == null) {
      position = null;
      return null;
    }
    position = LatLng(location.latitude, location.longitude);
    return LatLng(location.latitude, location.longitude);
  }

  Future getAddress(LatLng location) async {
    model.address =
        await getNameByLocation(location.latitude, location.longitude);
    invalid.refresh();
  }

  Future getAbnormalOptions() async {
    final response = await lineRepo.getAbnormalOptions(
        typeViolation: typeViolation.value, isBackground: true);
    if (response.isLoadSuccess) {
      abnormalOptions = List.empty(growable: true);
      abnormalOptions.addAll(response.data.list);
      invalid.refresh();
    }
  }

  Future addAbnormalOption({String name}) async {
    final response = await lineRepo.addAbnormalOption(
        name: name, typeViolation: typeViolation.value);
    if (response.isLoadSuccess) {
      await getAbnormalOptions();
    }
  }

  void getLineAssign() {
    listLine.assignAll(AppShared.instance
        .getListAllLineHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listLine.refresh();
  }

  Future getAllLine() async {
    final response = await lineRepo.getAllLine(isBackground: true);
    if (response.isLoadSuccess) {
      listLine.assignAll(
          response.data.list.map((e) => OptionModelString(e.name, e.id)));
      listLine.refresh();
    } else {
      await rShowDialogOneButton(response?.message);
    }
  }

  Future getWorkByLine({String lineId}) async {
    listWorkByLine.value = List.empty(growable: true);
    final response = await lineRepo.getInspectByLine(lineId: lineId);
    if (response.isLoadSuccess) {
      listWorkByLine.value = response.data.list
          .map((e) => OptionModelString(e.name, e.id))
          .toList();
      invalid.refresh();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  List<OptionModelString> getOptionInitValue(
      {@required List<OptionModelString> options, String optionValue = ''}) {
    final listOptions = List<OptionModelString>.empty(growable: true);

    final modelOptionMulti = (optionValue ?? '').split(';');

    for (var i = 0; i < modelOptionMulti.length; i++) {
      for (var j = 0; j < (options ?? []).length; j++) {
        if (options[j].value == modelOptionMulti[i]) {
          listOptions.add(options[j]);
          break;
        }
      }
    }
    return listOptions;
  }
}

