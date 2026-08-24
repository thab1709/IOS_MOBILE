// @dart=2.9
import 'package:get/get.dart';

import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../models/abnormal/abnormal_detail_model.dart';
import '../../../../../services/responsitory/abnormal_repository.dart';



class DetailController extends GetxController {
  Rx<TAbnormalDetailModel> model = TAbnormalDetailModel().obs;
  final _abnormalRep = TAbnormalRepository();

  final isShowFull = false.obs;
  Future getDetail(String id, {bool isBackground = false}) async
  {
    final res = await _abnormalRep.getAbnormalDetail(id: id, isBackground: isBackground);
    if (res.isLoadSuccess) {
      model.value = res.data.model;
      model.refresh();
    } else {
      await showDialogOneButton(res.message);
    }
  }
}
