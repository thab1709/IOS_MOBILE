// @dart=2.9
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_daytime/check_sheet/role/check_role_cover/check_role_cover_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/app_color.dart';
import '../../../../../../models/day_night/popups/role_model.dart';
import '../../../../base/base_popup_wigget.dart';
import 'role_controller.dart';
import 'second_chamber/second_chamber_screen.dart';

class RoleScreen extends BasePopupWidget {
  RoleScreen(
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

  final _controller = RoleController<RoleModel>();

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
                _controller.dataModel.value.protectionRelays,
                nonCheck: true, title: 1))
              buildCheckRoleCoverScreen(_controller),
            if (_controller.transformerTicketController.checkAbnormalNotify(
                _controller.dataModel.value.secondChamber,
                nonCheck: true, title: 2))
              if (_controller.isEqual110.value == false)
                buildSecondChamberScreen(_controller)
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

