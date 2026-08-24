// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app_common/shared/app_shared.dart';
import '../../../../qltnkd/common/utils/alert_dialog_utils.dart';
import '../../../../qltnkd/services/responsitory/images_repository.dart';
import '../../../common/constance/inspection_category.dart';
import '../../../common/enum/ticket_enum.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../models/day_night/popups/images_model.dart';
import '../../../models/log_book/operation_model.dart';
import '../../../models/option_model.dart';
import '../../../services/responseModel/log_book_response.dart';
import '../../../services/responsitory/log_book_repository.dart';
import '../../../services/responsitory/test_plan_repository.dart';
import '../../grid_management/transformer/transformer_ticket_controller.dart';
import '../common/content_option.dart';
import '../common/option_type.dart';

class OperationLogController extends GetxController {
  RxInt typeEventId = 0.obs;
  RxBool invalid = false.obs;
  final transformerTicketController = Get.put(TransformerTicketController());
  bool keyboardVisibilityTrigger = false;
  int typeInspect;

  final _workRep = TestPlanRepository();
  final _logBookRep = LogBookRepository();
  String ticketId;
  final userProfile = AppShared.instance.getUserProfile();
  List<OptionModelString> equipmentInstallationOptions =
      OptionsType.EquipmentInstallation.getStringOptions;
  List<OptionModelString> handleOptions = OptionsType.Handle.getStringOptions;
  List<OptionModelString> scheduleOptions =
      OptionsType.Schedule.getStringOptions;
  List<OptionModelString> measurementsOptions =
      OptionsType.Measurements.getStringOptions;
  List<OptionModelString> operationOptions =
      OptionsType.Operation.getStringOptions;
  List<OptionModelString> inspectionTeamOptions =
      OptionsType.InspectionTeam.getStringOptions;
  List<OptionModelString> cuttingOptions = OptionsType.Cutting.getStringOptions;
  List<OptionModelString> protectTypeOptions =
      OptionsType.ProtectType.getStringOptions;

  RxList<OptionModelString> listTBAorLine = RxList.empty();
  RxList<OptionModelString> listTBA = RxList.empty();
  RxList<OptionModelString> listLine = RxList.empty();

  RxList<OptionModelString> listTypeEquipmentTBAorLine = RxList.empty();
  RxList<OptionModelString> listEquipmentTBAorLine = RxList.empty();
  RxList<OptionModelString> listGroup = RxList.empty();
  RxList<OptionModelString> listUnit = RxList.empty();
  RxList<OptionModelString> listUnitX6 = RxList.empty();
  RxList<OptionModelString> listUser = RxList.empty();

  RxList<OptionModelString> listCutterDevice = RxList.empty();
  RxList<OptionModelString> listSubstationDevice = RxList.empty();

  OperationModel model = OperationModel(images: []);
  final imageService = ImageRepository();

  List<EquipmentModel> mbaEquiments = [];

  void refreshView() {
    invalid.refresh();
  }

  Future<void> initData() async {
    await initListOption();
    if(model.reporters.isNullOrEmpty()) {
      model.reporters= userProfile.name;
    }
  }

  Future getListTypeEquipmentTBAorLine({String lineOrSubstationID}) async {
    listTypeEquipmentTBAorLine = RxList.empty();
    if (typeInspect == ContentOptions.subStationInspect.value) {
      var res = await _workRep.getListCategoryBySubstation(
        lineOrSubstationID: lineOrSubstationID,
        isNightTime: false,
        isBackground: false,
      );

      if (res.isLoadSuccess) {
        res.data.list.forEach((element) {
          listTypeEquipmentTBAorLine
              .add(OptionModelString('${element.name}', element.id));
        });
      } else {
        await hShowDialogOneButton(res.message);
      }
      res = await _workRep.getListCategoryBySubstation(
        lineOrSubstationID: lineOrSubstationID,
        isNightTime: true,
        isBackground: false,
      );

      if (res.isLoadSuccess) {
        res.data.list.forEach((element) {
          if (listTypeEquipmentTBAorLine.value
                  .where((element1) => element1.value == element.id) ==
              null) {
            listTypeEquipmentTBAorLine.value
                .add(OptionModelString('${element.name}', element.id));
          }
        });
      } else {
        await hShowDialogOneButton(res.message);
      }
      listTypeEquipmentTBAorLine.refresh();
      invalid.refresh();
    } else {
      var res = await _workRep.getListCategoryBySubstation(
        lineOrSubstationID: lineOrSubstationID,
        isNightTime: false,
        isLine: true,
        isBackground: false,
      );

      if (res.isLoadSuccess) {
        res.data.list.forEach((element) {
            listTypeEquipmentTBAorLine.value
                .add(OptionModelString('${element.name}', element.id));
        });
      } else {
        await hShowDialogOneButton(res.message);
      }
      res = await _workRep.getListCategoryBySubstation(
        lineOrSubstationID: lineOrSubstationID,
        isNightTime: true,
        isLine: true,
        isBackground: false,
      );
      if (res.isLoadSuccess) {
        res.data.list.forEach((element) {
          if (listTypeEquipmentTBAorLine.value
                  .where((element1) => element1.value == element.id) ==
              null) {
            listTypeEquipmentTBAorLine.value
                .add(OptionModelString('${element.name}', element.id));
          }
        });
      } else {
        await hShowDialogOneButton(res.message);
      }
      listTypeEquipmentTBAorLine.refresh();
      invalid.refresh();
    }
    update();
  }

  Future getListEquipmentTBAorLine({String category}) async {
    listEquipmentTBAorLine = RxList.empty();
    if (category.isNullOrEmpty()) {
      listEquipmentTBAorLine.refresh();
      invalid.refresh();
      return;
    }
    var categories = category.split(';');
    categories.forEach((element) async {
      final res = await _workRep.listEquipmentByCategory(
        lineOrSubstationID:
            typeInspect == ContentOptions.subStationInspect.value
                ? model.substationId
                : model.lineId,
        isSubStationInspect:
            typeInspect == ContentOptions.subStationInspect.value,
        category: element,
        isBackground: false,
      );

      if (res.isLoadSuccess) {
        listEquipmentTBAorLine
            .addAll(res.data.list.map((e) => OptionModelString(e.name, e.id)));
      } else {
        await hShowDialogOneButton(res.message);
      }
      listEquipmentTBAorLine.refresh();
      invalid.refresh();
      update();
    });
  }

  List<OptionModelString> getOptionInitValue(
      {@required List<OptionModelString> options, String optionValue = ''}) {
    final listOptions = List<OptionModelString>.empty(growable: true);

    final modelOptionMulti = (optionValue ?? '').split(';');

    for (var i = 0; i < modelOptionMulti.length; i++) {
      for (var j = 0; j < (options??[]).length; j++) {
        if (options[j].value == modelOptionMulti[i]) {
          listOptions.add(options[j]);
          break;
        }
      }
    }
    return listOptions;
  }

  String fromMultiOptionsSelected({@required List<OptionModelString> options}) {
    if (options != null && options.isNotEmpty) {
      final buffer = StringBuffer();
      for (var i = 0; i < options.length; i++) {
        buffer.write(
            '${options[i].value}${i != (options.length - 1) ? ';' : ''}');
      }
      return buffer.toString();
    }
    return null;
  }

  Future addImage({
    @required List<File> images,
  }) async {
    await uploadImage(images);
    invalid.refresh();
  }

  Future removeImage(Images image) async {
    model.images.remove(image);
    invalid.refresh();
  }

  Future uploadImage(List<File> files) async {
    final response = await imageService.upload(files);

    if (response.isLoadSuccess) {
      for (var i = 0; i < response.data.length; i++) {
        model.images.add(Images(
            problems: 1,
            name: response.data[i].name,
            imageStorageId: response.data[i].imageStorageId,
            url: response.data[i].url));
      }
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  Future<void> updateData() async {
    if (model.eventType != ContentOptions.MCTTN.value) {
      typeInspect == ContentOptions.subStationInspect.value
          ? model.lineId = null
          : model.substationId = null;
    }
    if (!model.checkValid(
        isSubstationInppect:
            typeInspect == ContentOptions.subStationInspect.value)) {
      await hShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
      invalid.value = true;
      invalid.refresh();
      return;
    }

    if (transformerTicketController.actionPopupType == ActionTicketType.edit) {
      final response =
          await _logBookRep.updateCheckOperationNote(params: model.toJson());
      if (response.isLoadSuccess) {
        Get.back();
      } else {
        await rShowDialogOneButton(response.message);
      }
    } else {
      final response =
          await _logBookRep.createCheckOperationNote(params: model.toJson());
      if (response.isLoadSuccess) {
        Get.back();
      } else {
        await rShowDialogOneButton(response.message);
      }
    }
  }

  Future initListOption() async {
    listGroup.assignAll(AppShared.instance
        .getGroupsHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listGroup.refresh();

    listTBA.assignAll(AppShared.instance
        .getListAllSubstationHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listTBA.refresh();

    listLine.assignAll(AppShared.instance
        .getListAllLineHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listLine.refresh();

    listUser.assignAll(AppShared.instance
        .getListUser()
        .map((e) => OptionModelString(e.name, e.id)));
    listUser.refresh();

    listUnit.assignAll(AppShared.instance
        .getUnits()
        .map((e) => OptionModelString(e.name, e.id)));
    listUnit.refresh();

    listUnitX6.assignAll(AppShared.instance
        .getUnitsX6()
        .map((e) => OptionModelString(e.name, e.id)));
    listUnitX6.refresh();

    listTBAorLine.addAll(AppShared.instance
        .getListAllSubstationHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listTBAorLine.addAll(AppShared.instance
        .getListAllLineHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listTBAorLine.refresh();
  }

  Future getEquipmentByCategory(
      {String substationId,
      int categoryId,
      RxList<OptionModelString> options}) async {
    options.clear();
    final res = await _workRep.getEquipmentByCategory(
        substationId: substationId,
        categoryId: categoryId.toString(),
        isBackground: false);
    if (res.isLoadSuccess) {
      options.addAll(res.data.list.map((e) => OptionModelString(e.name, e.id)));
      if(categoryId == HighElectricInspectionCategory.MBA) {
        mbaEquiments = res.data.list;
      }
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future getData() async {
    final res = await _logBookRep.getOperation(
      id: ticketId,
    );
    if (res.isLoadSuccess) {
      model = res.data.model;
      typeEventId.value = model.eventType;
      model.substationId.isNullOrEmpty()
          ? typeInspect = ContentOptions.lineInspect.value
          : typeInspect = ContentOptions.subStationInspect.value;
      await getListTypeEquipmentTBAorLine(
          lineOrSubstationID:
              typeInspect == ContentOptions.subStationInspect.value
                  ? model.substationId
                  : model.lineId);
      model.substationId.isNullOrEmpty()
          ? typeInspect = ContentOptions.lineInspect.value
          : typeInspect = ContentOptions.subStationInspect.value;
      if (!model.pmisEquipmentCategories.isNullOrEmpty()) {
        await getListEquipmentTBAorLine(
            category: model.pmisEquipmentCategories);
      }
      if (!model.substationId.isNullOrEmpty()) {
        await getEquipmentByCategory(
            substationId: model.substationId,
            categoryId: HighElectricInspectionCategory.MC,
            options: listCutterDevice);
        if (model.eventType == ContentOptions.MCTTN.value) {
          await getEquipmentByCategory(
              substationId: model.substationId,
              categoryId: HighElectricInspectionCategory.MBA,
              options: listSubstationDevice);
        }
      }
      typeEventId.refresh();
      invalid.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future copyData() async {
    final res = await _logBookRep.getOperation(
      id: ticketId,
    );
    if (res.isLoadSuccess) {
      model = res.data.model;
      model.reporters= userProfile.name;
      model.id = null;
      model.images = [];
      typeEventId.value = model.eventType;
      model.substationId.isNullOrEmpty()
          ? typeInspect = ContentOptions.lineInspect.value
          : typeInspect = ContentOptions.subStationInspect.value;
      await getListTypeEquipmentTBAorLine(
          lineOrSubstationID:
              typeInspect == ContentOptions.subStationInspect.value
                  ? model.substationId
                  : model.lineId);
      if (!model.pmisEquipmentCategories.isNullOrEmpty()) {
        await getListEquipmentTBAorLine(
            category: model.pmisEquipmentCategories);
      }
      if (!model.substationId.isNullOrEmpty()) {
        await getEquipmentByCategory(
            substationId: model.substationId,
            categoryId: HighElectricInspectionCategory.MC,
            options: listCutterDevice);

        if (model.eventType == ContentOptions.MCTTN.value) {
          await getEquipmentByCategory(
              substationId: model.substationId,
              categoryId: HighElectricInspectionCategory.MBA,
              options: listSubstationDevice);
        }
      }
    } else {
      await hShowDialogOneButton(res.message);
    }
    invalid.refresh();
  }
  String getWattage()
  {
    var wattage ='';

    mbaEquiments.forEach((element) {
      if(element.id == model.mbaEquipmentId)
        {
          wattage = roundDouble(double.parse(element.wattage), 2).toString();
        }
    });
    return wattage;
  }
}

