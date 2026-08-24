// @dart=2.9
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/report_controller.dart';
import 'package:get/get.dart';

class TabFormController extends GetxController {
  final fieldModel = FieldModel().obs;
  bool isChild = false;
  final reportController = Get.put(ReportController());

  void setFieldModel(FieldModel model) {
    fieldModel.value = model;
    update();
  }
}

