// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../../common/components/popup_mobile_screen.dart';
import '../../../../../common/constance/inspection_category.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../common/utils/snack_bar_h_u_d.dart';
import '../../../../../models/day_night/tba_content_check.dart';
import '../../../../../models/day_night/ticket.dart';
import '../../../../../models/equipment_model.dart';
import '../../../../../models/line/line_node_model.dart';
import '../../../../../services/responsitory/line_repository.dart';
import '../../../../../services/responsitory/tba_repository.dart';
import '../../../transformer/transformer_ticket_controller.dart';
import 'tunnel_cable_popup/tunnel_cable_popup.dart';

class TunnelCableContentController extends GetxController {
  final _lineRep = LineRepository();
  final _tbaRep = TBARepository();
  RxList<String> listAbnormal;
  RxString textAbnormal = ''.obs;
  String keySearchNoteSelected = '';
  final TransformerTicketController transformerTicketController = Get.find();

  final listEquipmentCopy = RxList<EquipmentModel>.empty();
  RxBool isCheckedAll = false.obs;
  RxBool isShowCheckedAll = true.obs;
  List<LineNodeModel> listNodeSelectedOriginal = List.empty();
  final listNodeSelected = RxList<LineNodeModel>.empty();
  List<LineNodeModel> listNodeUnSelectedOriginal = List.empty();
  final listNodeUnSelected = RxList<LineNodeModel>.empty();
  String idEquipmentCopy = '';
  RxBool isCheckedCopyAll = false.obs;
  int positionCopy = -1;
  RxBool isSuggestAbnormal = false.obs;
  String searchText = '';
  bool isCheckPreValue = false;
  int positionPreCheck = -1;
  RxString searchTermCopy = ''.obs;
  Rx<ContentCheckModel> tbaContentCheck = ContentCheckModel().obs;

  List<EquipmentModel> listEquipmentOriginal = List.empty();
  final listEquipment = RxList<EquipmentModel>.empty();
  bool fromNotify = false;

  Future getNodesList( Null Function() fun, {bool isSelected}) async {
    listNodeUnSelected.value = [];
    isShowCheckedAll.value = true;
    final res = await _lineRep.getLineInspect(
        idLine: transformerTicketController.lineId,
        idTicket: transformerTicketController.ticketId,
        isBackground: true,
        isUnderSystem: true,
        isUpdate: true);
    if (res.isLoadSuccess) {
      if (isSelected) {
        listNodeSelectedOriginal = res.data.list ?? [];
        await searchNodeSelected(keySearchNoteSelected);
        await getEquipmentList();
      } else {
        listNodeUnSelectedOriginal = res.data.list ?? [];
        listNodeUnSelected.value = listNodeUnSelectedOriginal
            .where((element) => element.isSelected != true)
            .toList(growable: false);
        listNodeUnSelected.refresh();
      }
      fun?.call();
    } else {
      await hShowDialogOneButton(res.message);
    }
    update();
  }

  Future searchNodeSelected(String value) async {
    keySearchNoteSelected = value;
    final result = listNodeSelectedOriginal
        .where((element) =>
            (value.isNullOrBlank() ||
                TiengViet.parse(element.name.toLowerCase()).contains(value)) &&
            element.isSelected == true)
        ?.toList();

    listNodeSelected.value = result;
    listNodeSelected.refresh();
    update();
  }

  Future deleteNode(LineNodeModel lineNode) async {
    //await transformerTicketController.sendLocation();
    final res = await _lineRep.deleteNode(
        idTicket: transformerTicketController.ticketId, idNode: lineNode.id);
    if (res.isLoadSuccess) {
      await getNodesList(null, isSelected: true);
    } else {
      await hShowDialogOneButton(res.message);
    }
    update();
  }

  void onCheckAllSelect({bool isCheck}) {
    listNodeUnSelected.forEach((element) {
      element.isSelected = isCheck;
    });
    listNodeUnSelected.refresh();
    update();
    isCheckedAll.value = isCheck;
  }

  Future onNodeSelected({bool isCheck, int index}) async {
    listNodeUnSelected[index].isSelected = isCheck;
    if (!isCheck) {
      if (isCheckedAll.value == true) {
        isCheckedAll.value = false;
        isCheckedAll.refresh();
        update();
      }
    }
  }

  Future searchNodeUnSelected(String value) async {
    final isNullOrBlank = value.isNullOrBlank();
    isShowCheckedAll.value = isNullOrBlank;
    isShowCheckedAll.refresh();
    final result = listNodeUnSelectedOriginal
        .where((element) =>
            (isNullOrBlank ||
                TiengViet.parse(element.name.toLowerCase()).contains(value)) &&
            element.isSelected != true)
        ?.toList();

    listNodeUnSelected.value = result;
    listNodeUnSelected.refresh();
    update();
  }

  Future updateNode() async {
    //await transformerTicketController.sendLocation();
    final listNodesId = listNodeUnSelected
        .where((element) => element.isSelected == true)
        .map((e) => e.id)
        .toList(growable: false);
    if (listNodesId.isNotEmpty) {
      final params = {
        'listNodes': listNodesId,
        'lineInspectId': transformerTicketController.ticketId
      };
      final res = await _lineRep.addNode(params: params);
      if (res.isLoadSuccess) {
        await getNodesList(null, isSelected: true);
      } else {
        await hShowDialogOneButton(res.message);
      }
      update();
    } else {
      await hShowDialogOneButton('Vui lòng chọn nút');
    }
  }

  Future getAbnormalPhenomenon() async {
    final res = await _tbaRep.getAbnormalPhenomenon(
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType,
        isBackground: false);
    listAbnormal = RxList<String>.empty();
    var abnormal = '';

    if (res.statusCode == 200) {
      listAbnormal.value = res.data.list;
      listAbnormal.forEach((element) {
        abnormal += '$element\n';
      });
      textAbnormal.value = abnormal;
      textAbnormal.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future getContentCheck() async {
    final res = await _tbaRep.getLineContentCheck(
        idTicket: transformerTicketController.ticketId);
    if (res.isLoadSuccess) {
      tbaContentCheck.value = res.data.tbaContentCheckModel;
      isSuggestAbnormal.value = tbaContentCheck.value.isSuggestAbnormal ?? true;
      if(tbaContentCheck.value.isSuggestAbnormal) {
        await getAbnormalPhenomenon();
      } else {
        textAbnormal.value = tbaContentCheck.value.abnormalPhenomenon;
      }
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future getEquipmentList() async {
    final res = await _tbaRep.getEquipment(
        categoryId: HighElectricInspectionCategory.CAPN.toString(),
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType);

    if (res.isLoadSuccess) {
      listEquipmentOriginal = res.data.list;
      listEquipmentOriginal.forEach((element) {
        element.equipmentCategory = HighElectricInspectionCategory.CAPN;
      });

      await searchEquipment(searchText, isPopup: false);
      // listEquipment.assignAll(listEquipmentOriginal.toList(growable: false));
      // listEquipment.refresh();
      // update();
    } else {
      await hShowDialogOneButton(res.message);
    }
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
                TiengViet.parse(element.substationName.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()));
      });
      listEquipment.assignAll(listSearch);
    }
    listEquipment.refresh();
    update();
  }

  bool isShowCopy(int index) {
    return transformerTicketController.testType == TestType.line &&
        listEquipment[index].isAllowLineCopy == true;
  }

  Future onRouter(EquipmentModel equipment,
      {EquipmentModel equipmentOriginal,
      String ticketId,
      List<EquipmentModel> equipmentsDestination}) async {
    transformerTicketController.equipmentCategory = HighElectricInspectionCategory.CAPN;
    await _openPopup(
        equipment,
        TunnelCableScreen(
          model: equipment,
          equipmentsDestination: equipmentsDestination,
        ));
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
        isSuggestAbnormal.value &&
        value == true) {
      await getAbnormalPhenomenon();
    }
    await getEquipmentList();
    if (value == true) {
      // _contentCheckController.updatePopupSuccess(model);
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

  Future searchEquipmentCopy(String value) async {
    if (value.isEmpty) {
      listEquipmentCopy.assignAll(listEquipmentOriginal);
      listEquipmentCopy.removeAt(positionCopy);
    } else {
      final listSearch = listEquipmentOriginal.where((element) {
        return element.id != idEquipmentCopy &&
            (TiengViet.parse(element.name.toLowerCase())
                .contains(value?.trim()?.toLowerCase()) ||
                TiengViet.parse(element.substationName.toLowerCase())
                    .contains(value?.trim()?.toLowerCase()));
      });
      listEquipmentCopy.assignAll(listSearch);
    }
    listEquipmentCopy.refresh();
    update();
  }

  void onCheckAllSelectCopy({bool isCheck}) {
    listEquipmentCopy.forEach((element) {
      element.isChecked = isCheck;
    });
    listEquipmentCopy.refresh();
    isCheckedCopyAll.value = isCheck;
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

  Future saveContent(String content, {bool isSuggestAbnormal}) async {
    final res = await _tbaRep.saveContentCheck(
        testType: TestType.line,
        idTicket: transformerTicketController.ticketId,
        abnormalPhenomenon: content,
        isSuggestAbnormal: isSuggestAbnormal
    );
    if (res.isLoadSuccess) {
      SnackBarHUD.show('Lưu nội dung kiểm tra thành công');
    } else {
      await hShowDialogOneButton(res.message);
    }
  }
}

