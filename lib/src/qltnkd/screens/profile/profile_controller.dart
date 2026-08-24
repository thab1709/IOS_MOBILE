// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/authen_repository.dart';
import 'package:get/get.dart';

import '../../../app_common/login/select_module.dart';
import '../verification_report/workload/list_request/list_request_controller.dart';

class RProfileController extends GetxController {
  final reportService = ReportAuthRepository();

  UserProfileModel user = AppShared.instance.getUserProfile();

  Future logout() async {
    final response = await reportService.logout();
    if (response.isLoadSuccess) {
      await AppShared.instance.persistentUserToken('');
      final ListRequestController _controller = Get.find();
      _controller.clearFilter();
      _controller.setDefaultDate();
      await Get.offAll(const SelectModuleScreen(isLogoutSSO: true,));
    } else {
      await rShowDialogOneButton(response.message);
      return;
    }
  }
}

