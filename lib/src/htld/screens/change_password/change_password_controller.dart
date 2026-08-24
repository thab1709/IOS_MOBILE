// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/services/responsitory/authen_repository.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final repository = AuthRepository();

  Future changePasswordExpired(String username, String oldPass, String newPass,
      String retypePass) async {
    final response = await repository.changePasswordExpired(
        username, oldPass, newPass, retypePass);
    await showDialogError(response.message, action: () async {
      if (response.statusCode == 200) {
        await AppShared.instance.persistentUserPassword(newPass);
        Get.back(result: true);
      }
    });
  }

  Future changePassword(
      String oldPass, String newPass, String retypePass) async {
    final userProfile = AppShared.instance.getUserProfile();

    final response = await repository.changePassword(
        username: userProfile.username,
        oldPass: oldPass,
        newPass: newPass,
        retypePass: retypePass,
        userId: userProfile.id);
    await showDialogError(response.message, action: () async {
      if (response.statusCode == 200) {
        await AppShared.instance.persistentUserPassword(newPass);
        Get.back(result: true);
      }
    });
  }
}
