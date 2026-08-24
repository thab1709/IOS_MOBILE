// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

import '../../../app_common/utils/utils.dart';

class HomeController extends GetxController{

  Future checkVersionApp() async {
    final appVerSion = await getDeviceInfo();
    final cachedProfile = AppShared.instance.getUserProfile();
    if (cachedProfile != null) {
      if (!cachedProfile.getAppVersion().contains(appVerSion)) {
        // await showDialogUpdateApp();
      }
    }
  }

    Future<String> getDeviceInfo() async {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    }
}

