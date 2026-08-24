// @dart=2.9
import 'package:get/get.dart';

import 'choose_substation_controller.dart';

class ChooseSubStationBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => ChooseSubStationController());
  }
}
