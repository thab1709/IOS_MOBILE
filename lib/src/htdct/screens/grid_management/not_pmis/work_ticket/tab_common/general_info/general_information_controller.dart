// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/tba_general_info_model.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';

import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../models/work_model.dart';
import '../../../../../../services/responsitory/tba_repository.dart';
import '../../../../transformer/transformer_ticket_controller.dart';

class TBAGeneralInfoController extends GetxController {
  final _tbaRep = TBARepository();
  Rx<TBAGeneralInfoModel> tbaGeneralInfoModel = TBAGeneralInfoModel().obs;
  RxBool isLoad = false.obs;
  final TransformerTicketController transformerTicketController = Get.find();

  Future getGeneralInfo() async {
    isLoad = false.obs;
    final res = await _tbaRep.getGeneralInfo(idTicket: transformerTicketController.ticketId,testType: transformerTicketController.testType);
    if (res.isLoadSuccess) {
      tbaGeneralInfoModel.value = res.data.tbaGeneralInfoModel;
    } else {
      await hShowDialogOneButton(res.message);
    }
    isLoad = true.obs;
  }

  String getWatt() {
    final value = tbaGeneralInfoModel?.value?.wattage;
    if(value?.isNotEmpty == true) {
      final valueDouble = value.toDoubleOrNull();
      if(valueDouble is double) {
        return '${valueDouble.toStringAsFixed(2)} MVA';
      } else {
        return value;
      }
    } else {
      return '';
    }

  }
}

