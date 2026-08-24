// @dart=2.9
import 'package:evnmobile/src/htld/screens/grid_management/choose_line/choose_line_controller.dart';
import 'package:get/get.dart';


class ChooseLineBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => ChooseLineController());
  }
}
