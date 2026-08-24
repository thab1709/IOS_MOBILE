// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htdct/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htdct/models/day_night/tba_content_check.dart';
import 'package:get/get.dart';

import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../services/responsitory/tba_repository.dart';
import '../../transformer_ticket_controller.dart';

class TBAContentCheckController extends GetxController {
  final _tbaRep = TBARepository();
  Rx<ContentCheckModel> tbaContentCheck = ContentCheckModel().obs;
  RxList<String> listAbnormal;
  RxString textAbnormal = ''.obs;
  RxBool isSuggestAbnormal = true.obs;
  final TransformerTicketController transformerTicketController = Get.find();

  Future getContentCheck() async {
    final res = await _tbaRep.getContentCheck(
        idTicket: transformerTicketController.ticketId);
    if (res.isLoadSuccess) {
      tbaContentCheck.value = res.data.tbaContentCheckModel;
      isSuggestAbnormal.value = tbaContentCheck.value.isSuggestAbnormal;
      if(tbaContentCheck.value.isSuggestAbnormal) {
        unawaited(getAbnormalPhenomenon());
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
        isBackground: true);
    listAbnormal = RxList<String>.empty();
    var abnormal = '';

    if (res.statusCode == 200) {
      listAbnormal.value = res.data.list;
      listAbnormal.forEach((element) {
        abnormal += '$element\n';
      });
      textAbnormal.value = abnormal;
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future saveContent(String content, {bool isSuggestAbnormal}) async {
    final res = await _tbaRep.saveContentCheck(
        idTicket: transformerTicketController.ticketId,
        abnormalPhenomenon: content,
      isSuggestAbnormal: isSuggestAbnormal,
    );
    if (res.isLoadSuccess) {
     SnackBarHUD.show('Lưu nội dung kiểm tra thành công');
    } else {
      await hShowDialogOneButton(res.message);
    }
  }
}

