// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/conductor_popup/conductor_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/insulation/insulation_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/lighting/lighting_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/pole/pole_popup.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_night/popups/transformer/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../common/components/popup_mobile_screen.dart';
import '../../../../common/constance/inspection_category.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../services/responsitory/tba_repository.dart';
import '../../line/tab_check/popups/pole_foundation/popup.dart';
import '../check_by_daytime/check_sheet/index.dart';
import '../check_by_daytime/check_sheet/volgate_cabinets/volgate_cabinets_screen.dart';
import '../check_by_night/popups/capacitor/screen.dart';
import '../check_by_night/popups/cutting_machine/screen.dart';
import '../check_by_night/popups/transformer_auto/screen.dart';
import '../transformer_ticket_controller.dart';

class EquipmentController extends GetxController {
  final _tbaRep = TBARepository();
  int categoryId;
  RxString categoryName = ''.obs;
  String idEquipmentCopy = '';
  bool isCheckPreValue = false;
  int positionPreCheck = -1;
  RxBool isSubstation = false.obs;
  int positionCopy = -1;
  bool isSuggestAbnormal;
  String searchText = '';
  List<EquipmentModel> listEquipmentOriginal = List.empty();
  final listEquipment = RxList<EquipmentModel>.empty();
  final TransformerTicketController transformerTicketController = Get.find();
  RxBool isCheckedCopyAll = false.obs;
  final listEquipmentCopy = RxList<EquipmentModel>.empty();
  RxString searchTermCopy = ''.obs;
  bool fromNotify = false;


  Future getEquipmentList() async {
    if (transformerTicketController.testType == TestType.subStation) {
      isSubstation.value = true;
    }
    final res = await _tbaRep.getEquipment(
        categoryId: categoryId.toString(),
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType);

    if (res.isLoadSuccess) {
      listEquipmentOriginal = res.data.list;
      listEquipmentOriginal.forEach((element) {
        element.equipmentCategory = categoryId;
      });

      await searchEquipment(searchText, isPopup: false);
      // listEquipment.assignAll(listEquipmentOriginal.toList(growable: false));
      // listEquipment.refresh();
      // update();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future setCheckedCopy(int position) async {
    listEquipmentCopy[position].isChecked = !listEquipmentCopy[position].isChecked;
    if(!listEquipmentCopy[position].isChecked && isCheckedCopyAll.value){
      isCheckedCopyAll.value = false;
    }
    listEquipmentCopy.refresh();
    update();
  }

  Future searchEquipment(String value, {bool isPopup}) async {
    if (value.isEmpty) {
      listEquipment.assignAll(listEquipmentOriginal);
      if (isPopup) listEquipment.removeAt(positionCopy);
    } else {
      final listSearch = listEquipmentOriginal.where((element) {
        return element.id != idEquipmentCopy &&
            (TiengViet.parse(element.name.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.code.toLowerCase()).contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.substationName.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()));
      });
      listEquipment.assignAll(listSearch);
    }
    listEquipment.refresh();
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

  Future onRouter(EquipmentModel equipment, {List<EquipmentModel> equipmentsDestination}) async {
    transformerTicketController.equipmentCategory = categoryId;
    switch (categoryId) {
      case HighElectricInspectionCategory.TU:
        return _openPopup(
            equipment,
            TUScreen(
                model: equipment, equipmentsDestination: equipmentsDestination));
        break;
      case HighElectricInspectionCategory.TI:
        return _openPopup(
            equipment,
            TIScreen(
                model: equipment, equipmentsDestination: equipmentsDestination));
        break;
      case HighElectricInspectionCategory.CS_VAN:
        return _openPopup(
            equipment,
            LightningProtectionValveScreen(
                model: equipment, equipmentsDestination: equipmentsDestination));
        break;
      case HighElectricInspectionCategory.DCL:
        return _openPopup(
            equipment,
            IsolationKnifeScreen(
                model: equipment, equipmentsDestination: equipmentsDestination));
        break;
      case HighElectricInspectionCategory.MBA:
        if (transformerTicketController.testType == TestType.subStation) {
          if (transformerTicketController.ticketType ==
              TicketType.periodicNight) {
            return _openPopup(
                equipment,
                TransformerNightScreen(
                    model: equipment,
                    equipmentsDestination: equipmentsDestination));
          } else if (transformerTicketController.ticketType ==
              TicketType.periodicDay) {
            return _openPopup(
                equipment,
                HighTransformerScreen(
                    model: equipment,
                    equipmentsDestination: equipmentsDestination));
          }
        }

        break;
      case HighElectricInspectionCategory.MBA_TD:
        if (transformerTicketController.testType == TestType.subStation) {
          if (transformerTicketController.ticketType ==
              TicketType.periodicNight) {
            return _openPopup(
                equipment,
                TransformerAutoNightScreen(
                    model: equipment,
                    equipmentsDestination: equipmentsDestination));
          } else if (transformerTicketController.ticketType ==
              TicketType.periodicDay) {
            return _openPopup(
                equipment,
                SubstationSeftUseScreen(
                    model: equipment,
                    equipmentsDestination: equipmentsDestination));
          }
        }
        break;
      case HighElectricInspectionCategory.MC:
        if (transformerTicketController.testType == TestType.subStation) {
          if (transformerTicketController.ticketType ==
              TicketType.periodicNight) {
            await _openPopup(
                equipment,
                CuttingMachineNightScreen(
                    model: equipment,
                    equipmentsDestination: equipmentsDestination));
          } else if (transformerTicketController.ticketType ==
              TicketType.periodicDay) {
            await _openPopup(
                equipment,
                CuttingMachineScreen(
                    model: equipment,
                    equipmentsDestination: equipmentsDestination));
          }
        }
        break;
      case HighElectricInspectionCategory.TB:
        if (transformerTicketController.testType == TestType.subStation) {
          if (transformerTicketController.ticketType ==
              TicketType.periodicNight) {
            return _openPopup(
                equipment,
                CapacitorNightScreen(
                    model: equipment,
                    equipmentsDestination: equipmentsDestination));
          } else if (transformerTicketController.ticketType ==
              TicketType.periodicDay) {
            return _openPopup(
                equipment,
                CompensatingCapacitorScreen(
                    model: equipment,
                    equipmentsDestination: equipmentsDestination));
          }
        }
        break;
      case HighElectricInspectionCategory.TNAQ:
        return _openPopup(
            equipment,
            ChargingCabinetScreen(
                model: equipment,  equipmentsDestination: equipmentsDestination));
        break;
      case HighElectricInspectionCategory.AQUY:
        return _openPopup(
            equipment,
            ACCUScreen(
                model: equipment,  equipmentsDestination: equipmentsDestination));
        break;
      case HighElectricInspectionCategory.ROLE:
        return _openPopup(
            equipment,
            RoleScreen(
                model: equipment,  equipmentsDestination: equipmentsDestination));
        break;
      case HighElectricInspectionCategory.DCS:
        return _openPopup(
            equipment,
            LightingScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
            ));
        break;
      case HighElectricInspectionCategory.SU:
        return _openPopup(
            equipment,
            InsulationScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
            ));
        break;
      case HighElectricInspectionCategory.DDAN:
        return _openPopup(
            equipment,
            ConductorPopupScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
            ));
        break;
      case HighElectricInspectionCategory.CD:
        return _openPopup(
            equipment,
            PolePopupScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
            ));
        break;
      case HighElectricInspectionCategory.MCOT:
        return _openPopup(
            equipment,
            PoleFoundationPopupScreen(
              model: equipment,
              equipmentsDestination: equipmentsDestination,
            ));
        break;
      case HighElectricInspectionCategory.CAPN:
        return _openPopup(
            equipment,
            UndergroundCableScreen(
                model: equipment,  equipmentsDestination: equipmentsDestination));
        break;
      case HighElectricInspectionCategory.THT:
        return _openPopup(
            equipment,
            VoltageCabinetScreen(
                model: equipment,  equipmentsDestination: equipmentsDestination));
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
          fromNotify: fromNotify,
          child: child,
        ));
    if (transformerTicketController.isHasPermissionEdit() &&
        isSuggestAbnormal == true &&
        value == true) {
      getAbnormalPhenomenon();
    }
    if (transformerTicketController.isHasPermissionEdit()) {
      await getEquipmentList();
    }
  }

  bool isShowCopy(int index) {
    return transformerTicketController.testType == TestType.line &&
            listEquipment[index].isAllowLineCopy == true ||
        transformerTicketController.testType == TestType.subStation &&
            listEquipment[index].isAllowEditOrCopy;
  }

  void onCheckAllSelectCopy({bool isCheck}) {
    listEquipmentCopy.forEach((element) {
      element.isChecked = isCheck;
    });
    listEquipmentCopy.refresh();
    isCheckedCopyAll.value = isCheck;
  }

  Future searchEquipmentCopy(String value) async {
    if (value.isEmpty) {
      listEquipmentCopy.assignAll(listEquipmentOriginal);
      listEquipmentCopy.removeAt(positionCopy);
    } else {
      final listSearch = listEquipmentOriginal.where((element) {
        return element.id != idEquipmentCopy &&
            (TiengViet.parse(element.name.toLowerCase()).contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.code.toLowerCase()).contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.substationName.toLowerCase()).contains(value?.trim()?.toLowerCase()));
      });
      listEquipmentCopy.assignAll(listSearch);
    }
    listEquipmentCopy.refresh();
    update();
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
        isSuggestAbnormal: true,
        isBackground: true,
        abnormalPhenomenon: content);
  }
}

