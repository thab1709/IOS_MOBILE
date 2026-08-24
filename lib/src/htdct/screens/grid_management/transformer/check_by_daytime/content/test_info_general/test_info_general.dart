// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_wigget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../models/line/popups/test_info_general_model.dart';
import 'content.dart';
import 'test_info_general_controller.dart';

class TestInfoGeneral extends BasePopupWidget {
  TestInfoGeneral() {
  Future.delayed(const Duration(milliseconds: 200), _controller.getData);
}

final _controller = TestInfoGeneralController<TestInfoGeneralModel>();

@override
Widget build(BuildContext context) {
  return Obx(_renderBody);
}

Widget _renderBody() {
  return Column(
    children: [
      Visibility(visible: false, child: Text(_controller.invalid.toString())),
      Expanded(
        child: _buildContent(),
      ),
    ],
  );
}

Widget _buildContent() {
  return SingleChildScrollView(
    child: Container(
      color: HighElectricAppColor.appBackgroundColor,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          buildContent(_controller),
        ],
      ),
    ),
  );
}

@override
void saveData() {
  _controller.updateData();
}
}

