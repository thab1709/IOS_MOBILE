// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htdct/common/constance/work_status.dart';
import 'package:evnmobile/src/htdct/common/enum/ticket_enum.dart';
import 'package:get/get.dart';

import '../../../../app_common/utils/permission_utils.dart';
import '../../../../htld/common/constance/content_option.dart';
import '../../../models/day_night/ticket.dart';
import '../../../models/work_model.dart';
import '../../../services/responsitory/location_repository.dart';

class TransformerTicketController extends GetxController {
  String ticketId = '';
  String lineId = '';
  String workId = '';
  WorkModel workModel;
  TestType testType = TestType.subStation;
  TicketType ticketType = TicketType.periodicDay;
  int workType;
  ActionTicketType actionTicketType = ActionTicketType.view;
  ActionTicketType actionPopupType = ActionTicketType.view;
  String substationName;
  bool triggerCompleteTicket = false;
  final bool abnormalNotify;
  final String titleAbnormalNotify;
  String equipmentNameNotify = '';
  String nodeNameNotify = '';
  int equipmentCategory;
  String nodeName = '';

  TransformerTicketController(
      {this.abnormalNotify = false, this.titleAbnormalNotify = ''});

  bool isHasPermissionEdit() => ActionTicketType.edit == actionTicketType;

  bool isCreate() {
    return workModel.workStatus == HWorkStatus.notImplement;
  }

  final _repository = LocationRepository();

  Future<bool> sendLocation({bool isAwait = false, bool isCheckIn = false}) async {
    if (await requestPermission()) {
      if (testType == TestType.line) {
        if(isAwait){
          await _repository.sendLocation(
              lineInspectId: ticketId, entityId: workModel.entity.id, isCheckIn: isCheckIn);
        } else {
          unawaited(_repository.sendLocation(
              lineInspectId: ticketId, entityId: workModel.entity.id, isCheckIn: isCheckIn));
        }
      } else if (testType == TestType.subStation) {
        if(isAwait){
          await _repository.sendLocation(
              substationInspectId: ticketId, entityId: workModel.entity.id, isCheckIn: isCheckIn);
        } else {
          unawaited(_repository.sendLocation(
              substationInspectId: ticketId, entityId: workModel.entity.id, isCheckIn: isCheckIn));
        }

      } else {}
      return true;
    } else {
      return false;
    }
  }

  bool checkAbnormalNotify(int option,
      {String abnormal = '', bool nonCheck = false, int title = 0}) {
    return (nonCheck &&
            option == ContentOptions.weirdo.value && titleAbnormalNotify.contains(' - $title.')) ||
        (option != null &&
            abnormalNotify &&
            abnormal != null &&
            abnormal.isNotEmpty &&
            titleAbnormalNotify.contains(abnormal) &&
            (option == ContentOptions.weirdo.value ||
                option == ContentOptions.bad.value ||
                option == ContentOptions.lack.value)) ||
        abnormalNotify == false ||
        option == null;
  }
}

