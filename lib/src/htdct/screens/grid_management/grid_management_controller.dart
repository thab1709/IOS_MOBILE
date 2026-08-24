// @dart=2.9
import 'package:get/get.dart';

import '../../models/day_night/ticket.dart';

class HighGridManagementController extends GetxController {
  Future setTypeWork(TestType subStationType, TicketType ticketType) async {
    await Get.deleteAll(force: true);
    Get.put(subStationType, tag: 'testType');
    Get.put(ticketType, tag: 'ticketType');
    Get.put('', tag: 'ticketIdNotify');
    Get.put('', tag: 'workIdNotify');
  }
}

