// @dart=2.9
import 'package:evnmobile/src/htdct/models/line/line_general_info_model.dart';
import 'package:evnmobile/src/htdct/services/responsitory/line_repository.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../transformer/transformer_ticket_controller.dart';

class LineGeneralInfoController extends GetxController {
  final _lineRep = LineRepository();
  Rx<LineGeneralInfoModel> lineGeneralInfoModel = LineGeneralInfoModel().obs;
  RxBool isLoad = false.obs;
  final TransformerTicketController transformerTicketController = Get.find();

  Future getGeneralInfo() async {
    isLoad = false.obs;
    final res = await _lineRep.getGeneralInfo(
        idTicket: transformerTicketController.ticketId);
    if (res.isLoadSuccess) {
      lineGeneralInfoModel.value = res.data.lineGeneralInfoModel;
    } else {
      await hShowDialogOneButton(res.message);
    }
    isLoad = true.obs;
  }
}

