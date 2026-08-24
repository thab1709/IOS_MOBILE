// @dart=2.9

import 'package:get/get.dart';

import '../controller/history_check_controller.dart';

class HistoryCheckBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => HistoryCheckController());
  }
}
