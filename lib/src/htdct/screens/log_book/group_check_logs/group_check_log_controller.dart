// @dart=2.9
import 'package:evnmobile/src/htdct/models/log_book/group_note_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';
import 'package:get/get.dart';

import '../../../../app_common/shared/app_shared.dart';
import '../../../../qltnkd/common/utils/alert_dialog_utils.dart';
import '../../../common/constance/strings.dart';
import '../../../common/enum/ticket_enum.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../models/option_model.dart';
import '../../../services/responsitory/log_book_repository.dart';
import '../../grid_management/transformer/transformer_ticket_controller.dart';
import '../common/option_type.dart';

class GroupCheckLogController extends GetxController {
  RxBool invalid = false.obs;
  bool triggerGetData = false;
  final TransformerTicketController transformerTicketController = Get.find();
  RxList listTeamCheck = [
    {'userCheck': '', 'roleUserCheck': ''}
  ].obs;
  RxList listTeam = [
    {'user': '', 'roleUser': ''}
  ].obs;

  final _logBookRep = LogBookRepository();
  String ticketId;

  GroupCheckNoteModel model = GroupCheckNoteModel(assetManage: 'X6');

  List<OptionModelString> listGroupCheck =
      OptionsType.TeamCheck.getStringOptions;
  RxList<OptionModelString> listGroup = RxList.empty();
  RxList<OptionModelString> listTBA = RxList.empty();

  void refreshView() {
    invalid.refresh();
  }

  Future<void> initData() async {
    listGroup.assignAll(AppShared.instance
        .getGroupsHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listGroup.refresh();

    listTBA.assignAll(AppShared.instance
        .getListAllSubstationHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listTBA.refresh();
  }

  List<OptionModelString> getOptionInitValue(
      {@required List<OptionModelString> options, String optionValue = ''}) {
    final listOptions = List<OptionModelString>.empty(growable: true);

    final modelOptionMulti = (optionValue ?? '').split(';');

    for (var i = 0; i < modelOptionMulti.length; i++) {
      for (var j = 0; j < options.length; j++) {
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

  Future<void> updateData() async {
    convertUserCheckList();

    if (!model.checkValid()) {
      await hShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
      invalid.value = true;
      invalid.refresh();
      return;
    }
    if (transformerTicketController.actionPopupType == ActionTicketType.edit) {
      final response =
          await _logBookRep.updateCheckNote(params: model.toJson());
      if (response.isLoadSuccess) {
        Get.back();
      } else {
        await rShowDialogOneButton(response.message);
      }
    } else {
      final response =
          await _logBookRep.createCheckNote(params: model.toJson());
      if (response.isLoadSuccess) {
        Get.back();
      } else {
        await rShowDialogOneButton(response.message);
      }
    }
  }

  Future getData() async {
    final res = await _logBookRep.getCheckNote(
      id: ticketId,
    );
    if (res.isLoadSuccess) {
      model = res.data.model;
      initCheckList();
      invalid.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
    if (transformerTicketController.actionPopupType == ActionTicketType.edit) {
      triggerGetData = true;
      invalid.refresh();
    }
  }

  Future copyData() async {
    final res = await _logBookRep.getCheckNote(
      id: ticketId,
    );
    if (res.isLoadSuccess) {
      model = res.data.model;
      model.id = null;
      initCheckList();
    } else {
      await hShowDialogOneButton(res.message);
    }
    triggerGetData = true;
    invalid.refresh();
  }

  void addTeamCheck({bool isTeamCheck = true}) {
    if (isTeamCheck) {
      listTeamCheck.add({
        'userCheck': '',
        'roleUserCheck': '',
      });
      listTeamCheck.refresh();
    } else {
      listTeam.add({
        'user': '',
        'roleUser': '',
      });
      listTeam.refresh();
    }
  }

  void removeTeamCheck({int index, bool isTeamCheck = true}) {
    if (isTeamCheck) {
      listTeamCheck.removeAt(index);
      listTeamCheck.refresh();
    } else {
      listTeam.removeAt(index);
      listTeam.refresh();
    }
  }

  void convertUserCheckList() {
    final modelJs = model.toJson();
    var listCount = listTeamCheck.length;
    for (var i = 0; i < 10; i++) {
      modelJs['userCheck${i + 1}'] =
          i < listCount ? listTeamCheck[i]['userCheck'] : null;
      modelJs['roleUserCheck${i + 1}'] =
          i < listCount ? listTeamCheck[i]['roleUserCheck'] : null;
    }
    listCount = listTeam.length;
    for (var i = 0; i < 10; i++) {
      modelJs['user${i + 1}'] = i < listCount ? listTeam[i]['user'] : null;
      modelJs['roleUser${i + 1}'] =
          i < listCount ? listTeam[i]['roleUser'] : null;
    }

    model = GroupCheckNoteModel.fromJson(JSON(modelJs));
  }

 void initCheckList() {
    final modelJs = model.toJson();
    for (var i = 0; i < 10; i++) {
      if ((modelJs['userCheck${i + 1}'] != null &&
              modelJs['userCheck${i + 1}'].toString().isNotEmpty) ||
          (modelJs['roleUserCheck${i + 1}'] != null &&
              modelJs['roleUserCheck${i + 1}'].toString().isNotEmpty)) {
        listTeamCheck.add({
          'userCheck': modelJs['userCheck${i + 1}'],
          'roleUserCheck': modelJs['roleUserCheck${i + 1}'],
        });
      }
    }
    for (var i = 0; i < 10; i++) {
      if ((modelJs['user${i + 1}'] != null &&
              modelJs['user${i + 1}'].toString().isNotEmpty) ||
          (modelJs['roleUser${i + 1}'] != null &&
              modelJs['roleUser${i + 1}'].toString().isNotEmpty)) {
        listTeam.add({
          'user': modelJs['user${i + 1}'],
          'roleUser': modelJs['roleUser${i + 1}'],
        });
      }
    }
  }
}

