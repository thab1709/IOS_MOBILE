// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/tba_content_check.dart';
import 'package:evnmobile/src/htdct/models/line/line_equipment_model.dart';
import 'package:evnmobile/src/htdct/models/line/line_node_model.dart';
import 'package:evnmobile/src/htdct/services/responsitory/line_repository.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../common/utils/snack_bar_h_u_d.dart';
import '../../../../../services/responsitory/tba_repository.dart';
import '../../../transformer/transformer_ticket_controller.dart';

class LineContentCheckController extends GetxController {
  final _tbaRep = TBARepository();
  final _lineRep = LineRepository();

  Rx<ContentCheckModel> tbaContentCheck = ContentCheckModel().obs;

  final TransformerTicketController transformerTicketController = Get.find();

  List<LineNodeModel> listNodeSelectedOriginal = List.empty();
  final listNodeSelected = RxList<LineNodeModel>.empty();
  List<LineNodeModel> listNodeUnSelectedOriginal = List.empty();
  final listNodeUnSelected = RxList<LineNodeModel>.empty();

  List<LineEquipmentModel> listEquipmentOriginal = List.empty();
  final listEquipment = RxList.empty();

  String keySearchNoteSelected = '';

  RxString textAbnormal = ''.obs;
  RxBool isCheckedAll = false.obs;
  RxBool isShowCheckedAll = true.obs;
  RxBool isSuggestAbnormal = true.obs;

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

  Future getAbnormalPhenomenon() async {
    final res = await _tbaRep.getAbnormalPhenomenon(
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType,
        isBackground: false);
    if (res.isLoadSuccess) {
      var abnormal = '';
      res.data.list.forEach((element) {
        abnormal += '$element\n';
      });
      textAbnormal.value = abnormal;
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future getNodesList(Null Function() fun, {bool isSelected}) async {
    listNodeUnSelected.value = [];
    isCheckedAll.value = false;
    isShowCheckedAll.value = true;
    final res = await _lineRep.getLineInspect(
        idLine: transformerTicketController.lineId,
        idTicket: transformerTicketController.ticketId,
        isBackground: true,
        isUpdate: true);
    if (res.isLoadSuccess) {
      if (isSelected) {
        listNodeSelectedOriginal = res.data.list ?? [];
        await searchNodeSelected(keySearchNoteSelected);
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
                TiengViet.parse(element.name.toLowerCase()).contains(value) ||
                TiengViet.parse(element.code.toLowerCase()).contains(value?.trim()?.toLowerCase())
            ) &&
            element.isSelected == true)
        ?.toList();

    listNodeSelected.value = result;
    listNodeSelected.refresh();
    update();
  }

  Future searchNodeUnSelected(String value) async {
    final isNullOrBlank = value.isNullOrBlank();
    isShowCheckedAll.value = isNullOrBlank;
    isShowCheckedAll.refresh();
    final result = listNodeUnSelectedOriginal
        .where((element) =>
            (isNullOrBlank || TiengViet.parse(element.name.toLowerCase()).contains(value) ||
                TiengViet.parse(element.code.toLowerCase()).contains(value?.trim()?.toLowerCase())
            ) &&
            element.isSelected != true)
        ?.toList();

    listNodeUnSelected.value = result;
    listNodeUnSelected.refresh();
    update();
  }

  Future saveContent(String content, {bool isSuggestAbnormal}) async {
    final res = await _tbaRep.saveContentCheck(
        testType: transformerTicketController.testType,
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

  Future deleteNode(LineNodeModel lineNode) async {
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

  Future updateNode() async {
    //await transformerTicketController.sendLocation();
    final listNodesId = listNodeUnSelected
        .where((element) => element.isSelected == true)
        .map((e) => e.id)
        .toList(growable: false);
    if (listNodesId.isNotEmpty) {
      final res = await _lineRep.getLineEquipment(
          workId: transformerTicketController.workId, listNodes: listNodesId);
      if (res.isLoadSuccess) {
        listEquipmentOriginal = res.data.list;
        listEquipment.assignAll(listEquipmentOriginal.toList(growable: false));
        final response = await _lineRep.updateNodeLine(
            idTicket: transformerTicketController.ticketId,
            listNodes: listNodeUnSelected,
            listEquipment: getListEquipmentId());
        if (response.isLoadSuccess) {
          await getNodesList(() => Get.back(), isSelected: true);
        } else {
          await hShowDialogOneButton(response.message);
          return;
        }
      } else {
        await hShowDialogOneButton(res.message);
      }
      update();
    } else {
      await hShowDialogOneButton('Vui lòng chọn nút');
    }
  }

  List<Map<String, String>> getListEquipmentId() {
    final listEquipmentId = <Map<String, String>>[];
    listEquipment.forEach((element) {
      listEquipmentId.add({'equipmentId': element.id});
    });
    return listEquipmentId;
  }
}

