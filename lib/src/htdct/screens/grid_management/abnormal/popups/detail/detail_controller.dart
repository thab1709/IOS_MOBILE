// @dart=2.9
import 'package:get/get.dart';

import '../../../../../../qltnkd/common/utils/alert_dialog_utils.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../models/abnormal/abnormal_detail_model.dart';
import '../../../../../models/line/popups/violate_inspection_model.dart';
import '../../../../../services/responsitory/abnormal_repository.dart';
import '../../../../../services/responsitory/line_repository.dart';



class DetailController extends GetxController {
  Rx<AbnormalDetailModel> model = AbnormalDetailModel().obs;
  final violateModel = ViolateModel().obs;
  final _abnormalRep = AbnormalRepository();
  final _lineRep = LineRepository();

  final isShowFull = false.obs;
  Future getDetail(String id, {bool isBackground = false}) async
  {
    final res = await _abnormalRep.getAbnormalDetail(id: id, isBackground: isBackground);
    if (res.isLoadSuccess) {
      model.value = res.data.model;
      model.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future getDetailViolate(String id) async
  {
    final response = await _lineRep.getViolateInspectDetail(
      id: id,
      isBackground: true
    );
    if (response.isLoadSuccess) {
      violateModel.value = response.data.model;
      violateModel.refresh();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }
}
