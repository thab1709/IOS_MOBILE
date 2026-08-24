// @dart=2.9
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_daytime/check_sheet/charging_cabinet/check_charging_cabinet/check_charging_cabinet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/app_color.dart';
import '../../../../../../models/day_night/popups/charging_cabinet_model.dart';
import '../../../../base/base_popup_wigget.dart';
import 'charging_cabinet_controller.dart';

class ChargingCabinetScreen extends BasePopupWidget {
  ChargingCabinetScreen({@required EquipmentModel model, List<EquipmentModel> equipmentsDestination, String ticketId}) {
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

  final _controller = ChargingCabinetController<ChargingCabinetModel>();

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
            CheckChargingCabinetScreen(_controller),
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

