// @dart=2.9
import 'package:evnmobile/src/htdct/models/feedback_detail_model.dart';
import 'package:get/get.dart';

import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../services/responsitory/feed_back_repository.dart';

class FeedbackDetailController extends GetxController {
  Rx<FeedbackDetailModel> model = FeedbackDetailModel().obs;
  final service = FeedbackRepository();

  Future getDetail(String id) async {
    final res = await service.getFeedbackDetail(
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
