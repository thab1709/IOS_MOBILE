// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/popups/tu_model.dart';
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './check_bonded/check_bonded_screen.dart';
import '../../../../../../common/constance/app_color.dart';
import '../../../../base/base_popup_wigget.dart';
import 'operating_voltage/operating_voltage.dart';
import 'tu_controller.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class TUScreen extends BasePopupWidget {
  TUScreen({@required EquipmentModel model, List<EquipmentModel> equipmentsDestination, String ticketId}) {
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

  final _controller = TUController<TUModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(_renderBody);
  }

  Widget _renderBody() {
    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((visible) {
      if (!visible && _controller.triggerWaringValue==true) {
        _controller.updateDegreeDifference();
      }
    });
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
            if(_controller.transformerTicketController.checkAbnormalNotify(_controller.dataModel.value.voltageEachPhase,nonCheck: true, title: 1))
            OpenratingVoltageScreen(_controller),
            if(_controller.transformerTicketController.checkAbnormalNotify(_controller.dataModel.value.checkBonded,nonCheck: true, title: 2))
            CheckBondedScreen(_controller),
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

