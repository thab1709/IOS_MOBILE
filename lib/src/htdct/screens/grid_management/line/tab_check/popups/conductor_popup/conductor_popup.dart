// @dart=2.9
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/app_color.dart';
import '../../../../../../models/line/popups/conductor_model.dart';
import '../../../../base/base_popup_wigget.dart';
import 'check_bonded/check_bonded_screen.dart';
import 'conductor_controller.dart';

class ConductorPopupScreen extends BasePopupWidget {
  ConductorPopupScreen(
      {@required EquipmentModel model, String ticketId,
      List<EquipmentModel> equipmentsDestination}) {
    _controller.equipmentModel = model;
    _controller.ticketId = ticketId;
    _controller.equipmentsDestination = equipmentsDestination;
    Future.delayed(const Duration(milliseconds: 200), () {
      if (equipmentsDestination != null) {
        _controller.copyData();
      } else {
        _controller.getData();
      }
    });
  }

  final _controller = ConductorController<ConductorModel>();

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
            buildCheckBondedScreen(_controller),
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

