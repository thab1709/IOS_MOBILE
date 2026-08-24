// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htdct/common/constance/work_status.dart';
import 'package:evnmobile/src/htdct/common/enum/ticket_enum.dart';
import 'package:get/get.dart';

import '../../../../../app_common/utils/permission_utils.dart';
import '../../../../models/day_night/ticket.dart';
import '../../../../models/work_model.dart';
import '../../../../services/responsitory/location_repository.dart';

class WorkNotPmisTicketController extends GetxController {
  String ticketId = '';
  String lineId = '';
  String workId = '';
  WorkModel workModel;
  TestType testType = TestType.subStation;
  TicketType ticketType = TicketType.periodicDay;
  ActionTicketType actionTicketType = ActionTicketType.view;

  bool isHasPermissionEdit() => ActionTicketType.edit == actionTicketType;

  bool isCreate() {
    return workModel.workStatus == HWorkStatus.notImplement;
  }

  final _repository = LocationRepository();

  Future<bool> sendLocation() async {
    if(await requestPermission()) {
      if (testType == TestType.line) {
        unawaited(_repository.sendLocation(
            lineInspectId: ticketId, entityId: workModel.entity.id));
      } else if (testType == TestType.subStation) {
        unawaited(_repository.sendLocation(
            substationInspectId: ticketId, entityId: workModel.entity.id));
      } else {}
      return true;
    } else {
    return false;
    }
  }
}

