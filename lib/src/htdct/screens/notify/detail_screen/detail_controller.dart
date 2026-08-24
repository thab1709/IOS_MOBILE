// @dart=2.9
import 'package:get/get.dart';

import '../../../../../routes.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../models/notify/notify_detail_model.dart';
import '../../../models/notify/notify_model.dart';
import '../../../services/responsitory/notify_respository.dart';


class DetailController extends GetxController {
  Rx<NotifyDetailModel> model = NotifyDetailModel().obs;
  final service  = NotifyRepository();
  Future getDetail(String id) async {
    final res = await service.getNotifyDetail(
      id: id
    );
    if (res.isLoadSuccess) {
      model.value = res.data.model;

      model.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
    update();
  }

}
