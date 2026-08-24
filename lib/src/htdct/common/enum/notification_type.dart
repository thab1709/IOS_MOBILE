// @dart=2.9
import 'package:flutter/material.dart';

class NotificationType {
  static const feedBackWorkFromPMIS = 5; // Phản hồi công việc từ PMIS
  static const feedBackWorkFromUnPMIS = 6; // Phản hồi công việc không từ PMIS
  static const feedBackInspectFromPMIS = 7; // Phản hồi phiếu kiểm tra từ PMIS
  static const feedBackInspectFromUnPMIS = 8; // Phản hồi phiếu kiểm tra không từ PMIS

  static String getNotificationType(
      {@required bool isFromPmis, @required bool isHasCreateInspectTicket}) {
    if (isFromPmis) {
      if (isHasCreateInspectTicket) {
        return feedBackInspectFromPMIS.toString();
      } else {
        return feedBackWorkFromPMIS.toString();
      }
    } else {
      if (isHasCreateInspectTicket) {
        return feedBackInspectFromUnPMIS.toString();
      } else {
        return feedBackWorkFromUnPMIS.toString();
      }
    }
  }
}

