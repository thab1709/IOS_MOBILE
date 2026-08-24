// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/transformer_ticket_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../app_common/utils/utils.dart';
import '../../../../qltnkd/services/responsitory/images_repository.dart';
import '../../../common/constance/content_option.dart';
import '../../../common/constance/strings.dart';
import '../../../common/enum/ticket_enum.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../common/utils/common.dart';
import '../../../common/utils/snack_bar_h_u_d.dart';
import '../../../models/day_night/popups/abnormal_model.dart';
import '../../../models/day_night/popups/images_model.dart';
import '../../../models/equipment_model.dart';
import '../../../models/option_model.dart';
import '../../../services/responsitory/abnormal_repository.dart';
import '../../../services/responsitory/popups_repo/transformers_repository.dart';

abstract class BasePopupController<T> extends GetxController {
  BasePopupController() {
    getAbnormalOptions();
  }

  final TransformerTicketController transformerTicketController = Get.find();
  final transformerService = TransformersRepository();

  Rx<T> dataModel;

  RxBool invalid = false.obs;
  RxString temperature = ''.obs;
  RxString humidity = ''.obs;
  EquipmentModel equipmentModel;
  String ticketId;
  bool trigger = false;
  bool triggerUpdate = false;
  List<OptionModelString> abnormalOptions = [];

  //substation
  //EquipmentModel equipmentsDestination;

  //line
  List<EquipmentModel> equipmentsDestination;

  final service = ImageRepository();
  final abnormalService = AbnormalRepository();

  void viewRefresh() {
    invalid.refresh();
  }

  bool isNotMultiCopy() {
    return (equipmentsDestination?.length ?? 0) <= 1;
  }

  bool isModeCopy() {
    return equipmentsDestination?.isNotEmpty == true;
  }

  Future getAbnormalOptions() async {
    if (transformerTicketController?.workModel?.workType == null &&
        transformerTicketController?.workType == null) {
      return;
    }
    final response = await abnormalService.getAbnormalOptions(
        equipmentCategory: transformerTicketController.equipmentCategory,
        workType: transformerTicketController?.workModel?.workType ??
            transformerTicketController?.workType);

    if (response.isLoadSuccess) {
      abnormalOptions.clear();
      abnormalOptions = List.empty(growable: true);
      abnormalOptions.addAll(response.data.list);
    } else {
      abnormalOptions = [];
      await hShowDialogOneButton(response.message);
    }
  }

  Future addAbnormalOption({String name}) async {
    final response = await abnormalService.addAbnormalOption(
        name: name,
        equipmentCategory: transformerTicketController.equipmentCategory,
        workType: transformerTicketController?.workModel?.workType ??
            transformerTicketController?.workType);

    if (response.isLoadSuccess) {
      await getAbnormalOptions();
      invalid.refresh();
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  List<Abnormals> getListAbnormal() {
    if ((dataModel.value as BaseHighElectricPopupModel)?.abnormals == null) {
      (dataModel.value as BaseHighElectricPopupModel)?.abnormals = [];
    }
    return (dataModel.value as BaseHighElectricPopupModel)?.abnormals ?? [];
  }

  Abnormals getAbnormalByCategoryIndex(int categoryIndex) {
    final list = getListAbnormal()
        ?.where((element) => element.categoryIndex == categoryIndex);
    if (list.isNotEmpty) {
      return list.first;
    }
    return null;
  }

  List<Images> getListImage() {
    if ((dataModel.value as BaseHighElectricPopupModel)?.images == null) {
      (dataModel.value as BaseHighElectricPopupModel)?.images = [];
    }
    return (dataModel.value as BaseHighElectricPopupModel)?.images;
  }

  List<Images> getImageByProblem(int problem) {
    return getListImage()
            ?.where((element) => element.problems == problem)
            ?.toList() ??
        List.empty();
  }

  Future addImage(List<File> images, int problem) async {
    final result = await uploadImage(images, problem);
    invalid.refresh();
    return result;
  }

  Future removeImage(Images image) async {
    getListImage().remove(image);
    invalid.refresh();
  }

  Future removeImageOfProblem(int problem) async {
    getListImage()?.removeWhere((element) => element.problems == problem);
    invalid.refresh();
  }

  Future uploadImage(List<File> files, int problem) async {
    final response = await service.upload(files);

    if (response.isLoadSuccess) {
      for (var i = 0; i < response.data.length; i++) {
        getListImage().add(Images(
            problems: problem,
            name: response.data[i].name,
            imageStorageId: response.data[i].imageStorageId,
            url: response.data[i].url));
      }

      return response.data;
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  bool checkTemperatureAndHumidityInvalid() {
    return temperature.value == null ||
        humidity.value == null ||
        temperature?.isNotEmpty != true ||
        humidity?.isNotEmpty != true;
  }

  dynamic getValueCopySubstation(int problem) {
    if ([
      ContentOptions.normal.value,
      ContentOptions.good.value,
      ContentOptions.enough.value,
      ContentOptions.onePhase.value,
      ContentOptions.threePhase.value,
      ContentOptions.oil.value,
      ContentOptions.dry.value,
    ].contains(problem)) {
      return problem;
    }
    return null;
  }

  Future updateMulti(Map<dynamic, dynamic> maps, String keyEquipment,
      Position location) async {
    final longitude = location.longitude;
    final latitude = location.latitude;
    final address = await getNameByLocation(latitude, longitude);
    //ensure not has abnormal
    maps['description'] = '';
    final response = await transformerService.lineCopy(
        ticketId: transformerTicketController.ticketId,
        testType: transformerTicketController.testType,
        params: {
          'equipmentIds': equipmentsDestination.map((e) => e.id).toList(),
          // 'temperature': temperature.value,
          // 'humidity': humidity.value,
          'address': address,
          keyEquipment: maps
        },
        endpoint: getEndPoint());

    if (response.isLoadSuccess) {
      Get.back(result: true);
      SnackBarHUD.show(HighElectricStrings.updatePopupSuccess);
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  Future updateOne(Map<dynamic, dynamic> maps, String keyEquipment,
      Position location) async {
    final longitude = location.longitude;
    final latitude = location.latitude;
    final address = await getNameByLocation(latitude, longitude);

    final response = await transformerService.put(
        ticketId: transformerTicketController.ticketId,
        params: {
          'equipmentId': equipmentsDestination?.isNotEmpty == true
              ? equipmentsDestination.first.id
              : equipmentModel.id,
          // 'temperature': temperature.value,
          // 'humidity': humidity.value,
          'address': address,
          keyEquipment: maps
        },
        testType: transformerTicketController.testType,
        endpoint: getEndPoint());

    if (response.isLoadSuccess) {
      Get.back(result: true);
      SnackBarHUD.show(HighElectricStrings.updatePopupSuccess);
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  Future updateEquipment(
      Map<dynamic, dynamic> maps, String keyEquipment) async {
    if (!checkValid()) {
      invalid.refresh();
      invalid.value = true;
      await hShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
      return;
    }

    if (triggerUpdate == false) {
      triggerUpdate = true;
      final location = await getCurrentPosition();

      if (transformerTicketController.actionPopupType == ActionTicketType.create) {
          final locationResult = await checkValidDistance(
            entity: transformerTicketController?.workModel?.entity,
            location: location,
          );
          if (locationResult == null) {
            return;
          }
      }

      final result = await sendLocation();
      if (!result) {
        triggerUpdate = false;
        return;
      }

      if (equipmentsDestination != null && equipmentsDestination.length > 1) {
        //copy Multi
        if (!checkValidCopy()) {
          await hShowDialogOneButton(HighElectricStrings.requireCopyPopupText);
          triggerUpdate = false;
          return;
        }
        await updateMulti(maps, keyEquipment, location);
        triggerUpdate = false;
      } else {
        await updateOne(maps, keyEquipment, location);
        triggerUpdate = false;
      }
    }
  }


  Future<BaseHighElectricPopupModel> getDataLine(String keyEquipment,
      {String equipmentId}) async {
    final response = await transformerService.get(
        ticketId: ticketId ?? transformerTicketController.ticketId,
        endpoint: getEndPoint(),
        testType: transformerTicketController.testType,
        equipmentId: equipmentId ?? equipmentModel.id);
    if (response.isLoadSuccess) {
      var data = json.decode(response.data['data'].toString());
      data ??= {keyEquipment: null};
      final model = (dataModel.value as BaseHighElectricPopupModel)
        ..fromJson(data[keyEquipment]);
      setTile(model);
      model.equipmentId = equipmentId;
      if (equipmentsDestination == null) {
        dataModel.value = model as T;
        invalid.refresh();
      } else {
        dataModel.value = null;
        return model;
      }
    } else {
      await hShowDialogOneButton(response.message);
    }
    return null;
  }

  void setValueTemperatureAndHumidity(Map data) {
    humidity.value = data == null ? '' : data['humidity'];
    temperature.value = data == null ? '' : data['temperature'];
  }

  void setTile(BaseHighElectricPopupModel model) {
    model.title = equipmentsDestination?.length == 1
        ? equipmentsDestination.first.name
        : equipmentModel.name;
  }

  //Nếu copy 2 thiết bị trở lên mà chọn bất thường thì không được copy
  bool checkValidCopy();

  Future<bool> sendLocation() async {
    return transformerTicketController.sendLocation();
  }

  String getEndPoint();

  Future<T> getData({String equipmentId});

  Future updateData();

  Future copyData();

  //check valid model
  bool checkValid();

  //check image, abnormal text when value abnormal
  bool checkValidAbnormal();

  //type - mục lớn
  void checkValidPattern(int type);
}

