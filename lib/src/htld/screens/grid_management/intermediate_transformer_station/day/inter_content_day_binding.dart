// @dart=2.9
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/inter_content_day_controller.dart';
import 'package:get/get.dart';

class InterContentDayBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => InterContentDayController());
  }
}
