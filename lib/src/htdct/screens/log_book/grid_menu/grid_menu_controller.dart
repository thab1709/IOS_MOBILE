// @dart=2.9
import 'package:get/get.dart';

import '../../../common/utils/alert_dialog_utils.dart';
import '../../../models/day_night/ticket.dart';
import '../../../models/log_book/total_check_model.dart';
import '../../../services/responsitory/log_book_repository.dart';


class GridMenuController extends GetxController {
  final _logBookRep = LogBookRepository();
  final totalCheck = TotalCheckModel().obs;

  Future setTypeWork(TestType subStationType, TicketType ticketType) async {
    await Get.deleteAll(force: true);
    Get.put(subStationType, tag: 'testType');
    Get.put(ticketType, tag: 'ticketType');
  }

  Future getTotalCheckNote() async {
    final res = await _logBookRep.getTotalCheckNote();
    if (res.isLoadSuccess) {
      totalCheck.value = res.data.model;
      totalCheck.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

}

