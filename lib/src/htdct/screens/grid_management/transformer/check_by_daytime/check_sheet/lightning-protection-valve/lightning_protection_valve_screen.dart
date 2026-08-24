// @dart=2.9
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/app_color.dart';
import '../../../../../../models/day_night/popups/lightning_protection_valve_model.dart';
import '../../../../base/base_popup_wigget.dart';
import 'check_electrode/check_electrode_sceen.dart';
import 'lightning_protection_valve_controller.dart';
import 'check_bonded/check_bonded_screen.dart';

class LightningProtectionValveScreen extends BasePopupWidget {
  LightningProtectionValveScreen(
      {@required EquipmentModel model,
      List<EquipmentModel> equipmentsDestination,
      String ticketId}) {
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

  final _controller =
      LightningProtectionValveController<LightningProtectionValveModel>();

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
            buildCommonInfo(_controller),
            if (_controller.transformerTicketController.checkAbnormalNotify(
                _controller.dataModel.value.checkBonded,
                nonCheck: true, title: 1))
              buildCheckBondedScreen(_controller),
            if (_controller.transformerTicketController.checkAbnormalNotify(
                _controller.dataModel.value.checkCSVPoles,
                nonCheck: true, title: 2))
              buildCheckElectrodeSceen(_controller),
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

