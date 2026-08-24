// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/conductor_popup/conductor_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/csv_popup/csv_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/insulation/insulation_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/lighting/lighting_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/pole/pole_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/underground_cables_line/underground_cables_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../../../../htld/common/utils/alert_dialog_utils.dart';
import '../../../../../../common/components/popup_mobile_screen.dart';
import '../../../../../../common/constance/inspection_category.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../services/responsitory/line_repository.dart';
import '../../../../../../services/responsitory/tba_repository.dart';
import '../../../../line/tab_check/popups/pole_foundation/popup.dart';
import '../../../../transformer/transformer_ticket_controller.dart';

class EquipmentLineController extends GetxController {
  final _tbaRep = TBARepository();
  final _lineTicketRepository = LineRepository();
  int categoryId;
  List<String> listSameLine = [];
  RxString categoryName = ''.obs;
  RxString searchTermCopy = ''.obs;
  String idEquipmentCopy = '';
  bool isCheckPreValue = false;
  RxBool isShowCheckAll = true.obs;
  int positionPreCheck = -1;
  int positionCopy = -1;
  bool isSuggestAbnormal;
  String searchText = '';
  List<EquipmentModel> listEquipmentOriginal = List.empty();
  final listEquipment = RxList<EquipmentModel>.empty();
  final listEquipmentCopy = RxList<EquipmentModel>.empty();
  final TransformerTicketController transformerTicketController = Get.find();
  RxBool isCheckedAll = false.obs;
  RxBool isCheckedCopyAll = false.obs;
  RxBool isShowButtonCheck = true.obs;
  bool fromNotify = false;

  Future getEquipmentList() async {
    final res = await _tbaRep.getEquipment(
        categoryId: categoryId.toString(),
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType);

      if (res.isLoadSuccess) {
        listEquipmentOriginal = res.data.list;

        listEquipmentOriginal.forEach((element) {
          element.equipmentCategory = categoryId;
        });

        listEquipment.assignAll(listEquipmentOriginal.toList(growable: false));
        // listEquipment.refresh();
        checkShowCheckAll();
        checkShowButtonCheck();
        // update();
        await searchEquipment(searchText);
      }else {
        await hShowDialogOneButton(res.message);
      }
  }

  Future setChecked(int position) async {
    listEquipment[position].isChecked = !listEquipment[position].isChecked;
    if(!listEquipment[position].isChecked && isCheckedAll.value){
      isCheckedAll.value = false;
    }
    listEquipment.refresh();
    update();
  }

  Future setCheckedCopy(int position) async {
    listEquipmentCopy[position].isChecked = !listEquipmentCopy[position].isChecked;
    if(!listEquipmentCopy[position].isChecked && isCheckedCopyAll.value){
      isCheckedCopyAll.value = false;
    }
    listEquipmentCopy.refresh();
    update();
  }

  Future searchEquipment(String value) async {
    if (value.isEmpty) {
      listEquipment.assignAll(listEquipmentOriginal);
    } else {
      final listSearch = listEquipmentOriginal.where((element) {
        return element.id != idEquipmentCopy &&
            (TiengViet.parse(element.name.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.code.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.substationName.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()));
      });
      listEquipment.assignAll(listSearch);
    }
    listEquipment.refresh();
    update();
  }

  Future searchEquipmentCopy(String value) async {
    if (value.isEmpty) {
      listEquipmentCopy.assignAll(listEquipmentOriginal);
      listEquipmentCopy.removeAt(positionCopy);
    } else {
      final listSearch = listEquipmentOriginal.where((element) {
        return element.id != idEquipmentCopy &&
            (TiengViet.parse(element.name.toLowerCase())
                .contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.code.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.substationName.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()));
      });
      listEquipmentCopy.assignAll(listSearch);
    }
    listEquipmentCopy.refresh();
    update();
  }

  Future refreshList() async {
    isCheckPreValue = false;
    positionPreCheck = -1;
    listEquipment.assignAll(RxList.from(listEquipmentOriginal));
    for (var i = 0; i < listEquipment.length; i++) {
      listEquipment[i].isChecked = false;
    }
    update();
  }

  Future onRouter(EquipmentModel equipment,
      {EquipmentModel equipmentOriginal,
      String ticketId,
      List<EquipmentModel> equipmentsDestination}) async {
    transformerTicketController.equipmentCategory = categoryId;
    switch (categoryId) {
      case HighElectricInspectionCategory.CS_VAN:
        return _openPopup(
            equipment,
            CSVPopupScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
              ticketId: ticketId,
            ));
        break;

      case HighElectricInspectionCategory.DCS:
        return _openPopup(
            equipment,
            LightingScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
              ticketId: ticketId,
            ));
        break;
      case HighElectricInspectionCategory.SU:
        return _openPopup(
            equipment,
            InsulationScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
              ticketId: ticketId,
            ));
        break;
      case HighElectricInspectionCategory.DDAN:
        return _openPopup(
            equipment,
            ConductorPopupScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
              ticketId: ticketId,
            ));
        break;
      case HighElectricInspectionCategory.CD:
        return _openPopup(
            equipment,
            PolePopupScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
              ticketId: ticketId,
            ));
        break;
      case HighElectricInspectionCategory.MCOT:
        return _openPopup(
            equipment,
            PoleFoundationPopupScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
              ticketId: ticketId,
            ));
        break;
      case HighElectricInspectionCategory.CAPN:
        return _openPopup(
            equipment,
            UndergroundCablesLinePopupScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
              ticketId: ticketId,
            ));
        break;
      default:
        return '';
    }
  }

  Future _openPopup(EquipmentModel model, Widget child) async {
    final value = await Get.to(() => PopupBaseEquipmentScreen(
          name: HighElectricInspectionCategory.getPopupName(
              model.equipmentCategory),
          actionType: transformerTicketController.actionTicketType,
          child: child,
          fromNotify: fromNotify,
        ));
    if (transformerTicketController.isHasPermissionEdit() && isSuggestAbnormal == true && value == true) {
      getAbnormalPhenomenon();
    }
    if (transformerTicketController.isHasPermissionEdit()) {
      await getEquipmentList();
    }
    if (value == true) {
      // _contentCheckController.updatePopupSuccess(model);
    }
  }

  bool isShowCopy(int index) {
    return transformerTicketController.testType == TestType.line &&
            listEquipment[index].isAllowLineCopy == true;
  }

  void getAbnormalPhenomenon() async {
    final res = await _tbaRep.getAbnormalPhenomenon(
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType,
        isBackground: true);
    if (res.isLoadSuccess) {
      var abnormal = '';
      res.data.list.forEach((element) {
        abnormal += '$element\n';
      });
      saveContent(abnormal);
    }
  }

  void saveContent(String content) {
    _tbaRep.saveContentCheck(
        testType: transformerTicketController.testType,
        idTicket: transformerTicketController.ticketId,
        isBackground: true,
        isSuggestAbnormal: true,
        abnormalPhenomenon: content);
  }

  void onCheckAllSelect({bool isCheck}) {
    listEquipment.forEach((element) {
      if (element.isAllowSameLineCopy == true) {
        element.isChecked = isCheck;
      }
    });
    listEquipment.refresh();
    isCheckedAll.value = isCheck;
  }

  void onCheckAllSelectCopy({bool isCheck}) {
    listEquipmentCopy.forEach((element) {
      element.isChecked = isCheck;
    });
    listEquipmentCopy.refresh();
    isCheckedCopyAll.value = isCheck;
  }

  Future onNodeSelected({bool isCheck, int index}) async {
    if (isCheck) {
      for (var i = 0; i < listEquipment[index].sameLine.length; i++) {
        for (var j = 0; j < listEquipment.length; j++) {
          if (j != index) {
            if (listEquipment[j]
                .sameLine
                .contains(listEquipment[index].sameLine[i])) {
              listEquipment[j].isShowCheckBox = true;
            } else {
              listEquipment[j].isShowCheckBox = false;
              listEquipment[j].isChecked = false;
            }
          }
        }
      }
    }

    listEquipment[index].isChecked = isCheck;
    if (!isCheck) {
      if (isCheckedAll.value == true) {
        isCheckedAll.value = false;
        isCheckedAll.refresh();
        update();
      }
    }
  }

  void checkShowButtonCheck() {
    isShowButtonCheck.value = listEquipment?.firstWhereOrNull((element) => element.isAllowSameLineCopy == true) != null;
  }

  void checkShowCheckAll() {

    for (var i = 0; i < listEquipment.length; i++) {
      if (listEquipment[i].isAllowSameLineCopy == false) {
        isShowCheckAll.value = false;
        return;
      }
    }
    if (listEquipment.isNotEmpty) {
      for (var i = 0; i < listEquipment[0].sameLine.length; i++) {
        for (var j = 1; j < listEquipment.length; j++) {
          if (!listEquipment[j]
              .sameLine
              .contains(listEquipment[0].sameLine[i])) {
            isShowCheckAll.value = false;
            return;
          }
        }
      }
    }
  }

  Future sameLineCopyClick() async {
    final listEquipmentChecked = List<EquipmentModel>.empty(growable: true);
    listEquipmentChecked.assignAll(listEquipment
        .where((element) =>
            element.isChecked == true && element.isAllowSameLineCopy == true)
        .toList(growable: false));
    if (listEquipmentChecked.isEmpty) {
      await showDialogOneButton('Chọn ít nhất 1 thiết bị kiểm tra');
    } else {
      final listId = List<String>.empty(growable: true);

      listEquipmentChecked.forEach((element) {
        listId.add(element.id);
      });

      final response = await _lineTicketRepository.getSameLine(
          params: {'equipmentIds': listId, 'equipmentCategory': categoryId});

      if (response.isLoadSuccess) {
        final model = response.data.model;
        await onRouter(
            EquipmentModel(
                id: model?.equipmentId, equipmentCategory: categoryId),
            ticketId: model?.lineInspectId,
            equipmentsDestination: listEquipmentChecked);
      } else {
        await showDialogOneButton(response.message);
      }
    }
  }
}

