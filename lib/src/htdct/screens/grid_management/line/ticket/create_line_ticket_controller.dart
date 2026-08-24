// @dart=2.9
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/models/line/line_equipment_model.dart';
import 'package:evnmobile/src/htdct/models/line/line_node_model.dart';
import 'package:evnmobile/src/htdct/services/responsitory/line_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../../app_common/utils/permission_utils.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../common/utils/common.dart';
import '../../transformer/transformer_ticket_controller.dart';

class CreateLineTicketController extends GetxController {
  final _lineRep = LineRepository();
  TransformerTicketController transformerTicketController = Get.find();
  String workId = '';
  String idLine = '';
  RxString name = ''.obs;
  List<LineNodeModel> listNodeOriginal = List.empty();
  final RxList<LineNodeModel> listNode = RxList.empty();
  List<LineEquipmentModel> listEquipmentOriginal = List.empty();
  final listEquipment = RxList.empty();
  List<String> listNodesId = [];
  RxBool isCheckedAll = true.obs;
  RxBool isShowCheckedAll = true.obs;

  Future getNodesList() async {
    if (transformerTicketController.ticketId.isNotEmpty == true) {
      final res = await _lineRep.getLineInspect(
          idLine: idLine,
          idTicket: transformerTicketController.ticketId,
          isUnderSystem:
              transformerTicketController.ticketType == TicketType.tunnelCable,
          isUpdate: true);
      if (res.isLoadSuccess) {
        listNodeOriginal = res.data.list ?? [];
        listNode.value = listNodeOriginal.toList(growable: false);
        listNode.refresh();
        await getLineEquipmentList(updateTicket: true);
      } else {
        await hShowDialogOneButton(res.message);
      }
    } else {
      final res = await _lineRep.getLineInspect(
        idLine: idLine,
        isUnderSystem:
            transformerTicketController.ticketType == TicketType.tunnelCable,
      );
      if (res.isLoadSuccess) {
        listNodeOriginal = res.data.list;
        listNode.value = listNodeOriginal.toList(growable: false);
        listNode.refresh();
        if (isCheckedAll.isTrue) {
          await getAllEquipment(isCheck: true);
        }
      } else {
        await hShowDialogOneButton(res.message);
      }
    }
    update();
  }

  Future getLineEquipmentList(
      {bool isCheck, bool updateTicket = false, String idNode}) async {
    if (updateTicket) {
      isCheckedAll.value = false;
      if (listNode != null) {
        // get list in update ticket
        listNode.forEach((node) {
          if (node.isSelected) {
            listNodesId.add(node.id);
          }
        });
      }
    } else {
      if (isCheck) {
        listNodesId.add(idNode);
      } else {
        listNodesId.remove(idNode);
      }
    }
    if (listNodesId.isNotEmpty) {
      final res = await _lineRep.getLineEquipment(
          workId: workId, listNodes: listNodesId);
      if (res.isLoadSuccess) {
        listEquipmentOriginal = res.data.list;
        listEquipment.assignAll(listEquipmentOriginal.toList(growable: false));
      } else {
        await hShowDialogOneButton(res.message);
      }
    } else {
      listEquipmentOriginal = [];
      listEquipment.assignAll([]);
    }
    update();
  }

  Future searchNode(String value) async {
    isCheckedAll.value = false;
    if (value?.trim()?.isNotEmpty == true) {
      listNode.value = listNodeOriginal
          .where((element) =>
              TiengViet.parse(element.name.toLowerCase()).contains(value) ||
              TiengViet.parse(element.code.toLowerCase())
                  .contains(value?.trim()?.toLowerCase()))
          ?.toList();
      isShowCheckedAll.value = false;
    } else {
      listNode.value = listNodeOriginal.toList(growable: false);
      isShowCheckedAll.value = true;
    }
    listNode.refresh();
    update();
  }

  Future searchEquipment(String value) async {
    if (value?.trim()?.isNotEmpty == true) {
      listEquipment.value = listEquipmentOriginal
          .where((equipment) =>
              TiengViet.parse(equipment.equipmentType.toLowerCase())
                  .contains(value) ||
              TiengViet.parse(equipment.equipmentName.toLowerCase())
                  .contains(value))
          .toList();
    } else {
      listEquipment.assignAll(listEquipmentOriginal.toList(growable: false));
    }
    listEquipment.refresh();
    update();
  }

  Future getAllEquipment({bool isCheck}) async {
    isCheckedAll.value = isCheck;
    listNodesId = [];
    if (listNode != null) {
      listNode.forEach((node) {
        final item = node;
        if (isCheck) {
          node.isSelected = true;
          listNodesId.add(node.id);
        } else {
          if (item?.isAllowEdit == false) {
            listNodesId.add(node.id);
            return;
          }
          node.isSelected = false;
        }
      });

      if (listNodesId.isNotEmpty) {
        final res = await _lineRep.getLineEquipment(
            workId: workId, listNodes: listNodesId);
        if (res.isLoadSuccess) {
          listEquipmentOriginal = res.data.list;
          listEquipment
              .assignAll(listEquipmentOriginal.toList(growable: false));
        } else {
          await hShowDialogOneButton(res.message);
        }
      } else {
        listEquipmentOriginal = [];
        listEquipment.clear();
      }
    }

    listNode.refresh();
    listEquipment.refresh();
    update();
  }

  Future<String> createTicket({@required Position location}) async {
    if (listEquipment.isEmpty) {
      await hShowDialogOneButton('Vui lòng chọn nút có thiết bị kiểm tra');
      return '';
    }
    ProgressHUD.show();
    final listMapEquipment = <Map<String, String>>[];
    listEquipment.forEach((equipment) {
      listMapEquipment.add({'equipmentId': equipment.id});
    });
    final res = await _lineRep.createLineTicket(
        location: location,
        workId: workId,
        inspectionType: transformerTicketController.ticketType.testTypeCode(),
        listEquipment: listMapEquipment,
        listNodes: listNodesId);
    ProgressHUD.dismiss();
    if (res.isLoadSuccess) {
      return res.data.toString();
    } else {
      await hShowDialogOneButton(res.message);
    }
    return '';
  }

  String getTitleButton() {
    if (transformerTicketController.isCreate()) {
      return 'Tạo phiếu kiểm tra';
    } else {
      return 'Cập nhật phiếu kiểm tra';
    }
  }

  Future onRouter() async {
    if (listEquipment.isEmpty) {
      await hShowDialogOneButton('Vui lòng chọn nút có thiết bị kiểm tra');
      return '';
    }
    if (transformerTicketController.isCreate()) {
      final location = await checkValidLocation();
      if (location == null) {
        return;
      }
      transformerTicketController.ticketId =
          await createTicket(location: location);

      if (transformerTicketController.ticketId.isEmpty) {
        return;
      } else {
        await Get.toNamed(Routes.transformerTicket);
      }
    } else {
      final res = await _lineRep.updateNodeLine(
          idTicket: transformerTicketController.ticketId,
          listNodes: listNode.value,
          listEquipment: getListEquipmentId());
      if (res.isLoadSuccess) {
        await Get.toNamed(Routes.transformerTicket);
      } else {
        await hShowDialogOneButton(res.message);
      }
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

