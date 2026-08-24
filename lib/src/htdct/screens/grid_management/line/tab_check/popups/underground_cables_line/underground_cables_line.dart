// @dart=2.9
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/underground_cables_line/underground_cables_line_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/app_color.dart';
import '../../../../../../models/equipment_model.dart';
import '../../../../../../models/line/popups/underground_cables_line_model.dart';
import '../../../../base/base_popup_wigget.dart';
import 'check_head_underground_cables/check_head_underground_cables.dart';

class UndergroundCablesLinePopupScreen extends BasePopupWidget {

  UndergroundCablesLinePopupScreen({@required EquipmentModel model, List<EquipmentModel> equipmentsDestination, String ticketId}) {
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

  final _controller = UndergroundCableLineController<UndergroundCablesLineModel>();

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
            buildCheckHeadUndergroundCables(_controller),
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

