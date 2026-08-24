// @dart=2.9

import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:evnmobile/src/htdct/models/line/popups/pole_foundation.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/pole_foundation/content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/app_color.dart';
import '../../../../base/base_popup_wigget.dart';
import 'controller.dart';

class PoleFoundationPopupScreen extends BasePopupWidget {

  PoleFoundationPopupScreen({@required EquipmentModel model, List<EquipmentModel> equipmentsDestination, String ticketId}) {
    _controller.equipmentModel = model;
    _controller.ticketId = ticketId;
    _controller.equipmentsDestination = equipmentsDestination;
    Future.delayed(const Duration(milliseconds: 200), () {
      if(equipmentsDestination != null) {
        _controller.copyData();
      } else {
        _controller.getData();
      }
    });
  }

  final _controller = PoleFoundationController<PoleFoundationModel>();

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
            buildCommonInfoLine(_controller),
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

