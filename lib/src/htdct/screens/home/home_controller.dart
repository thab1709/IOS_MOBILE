// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/services/responsitory/user_repository.dart';
import 'package:evnmobile/src/htld/common/utils/global_app.dart';
import 'package:get/get.dart';

import '../../../qltnkd/common/utils/common.dart';
import '../../../qltnkd/common/utils/connection.dart';
import '../../services/responsitory/dashboard_repository.dart';
import '../../services/responsitory/notify_respository.dart';

class HomeCTController extends GetxController{
  final repo = UserRepository();
  final notifyRepo = NotifyRepository();
  int notifyQuantity = 0;
  final _dashboardRep = DashboardRepository();

  RxDouble tempValue = 0.0.obs;
  RxDouble humiValue = 0.0.obs;

  Future<bool> checkVersionApp() async {
    final isOnline = await RConnection.shared.checkConnection();
    if(!isOnline){
      return true;
    }
    final appVerSion = await getDeviceInfo();
    final userProfileResponse = await repo.getUserProfile();
    if (userProfileResponse.isLoadSuccess && userProfileResponse?.data != null) {
      if (!AppShared.instance.getUserProfileDCT().getAppVersion().contains(appVerSion)) {
        return false;
      }
    }

    return true;
  }

  Future getNotifyQuantityNotSeen() async {
    final res = await notifyRepo.getTotalDelivery(isBackground: true);
    if (res.isLoadSuccess) {
      notifyQuantity = int.tryParse(res.data);
    } else {
      notifyQuantity = 0;
    }
  }

  Future getWeather() async {
    final res = await _dashboardRep.getWeather();

    if (res != null && res['main'] != null) {
      tempValue.value = res['main']['temp'] - 273.5;
      humiValue.value = res['main']['humidity'] - 0.0;
      App.tempValue = tempValue.value;
      App.humiValue = humiValue.value;
      tempValue.refresh();
      humiValue.refresh();
    }
  }
}

