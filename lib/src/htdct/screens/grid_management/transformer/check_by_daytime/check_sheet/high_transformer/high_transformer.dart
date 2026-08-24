// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/popups/transformers_model.dart';
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/app_color.dart';
import '../../../../base/base_popup_wigget.dart';
import 'check_bonded/check_bonded_screen.dart';
import 'check_temperature/check_temperature_screen.dart';
import 'check_transmission/check_transmission_screen.dart';
import 'high_transformer_controller.dart';

class HighTransformerScreen extends BasePopupWidget {
  HighTransformerScreen(
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

  final _controller = HighTransformerController<TransformersModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(_renderBody);
  }

  Widget _renderBody() {
    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((visible) {
      if (!visible) {
        if (_controller.triggerCounterIndexWarning == true) {
          _controller.updateStepCounterIndex();
          _controller.checkValidPattern(3);
        }
        if (_controller.triggerDegreeDifferenceWarning1) {
          _controller.updateDegreeDifference(1);
          _controller.checkValidPattern(3);
        }
        if (_controller.triggerDegreeDifferenceWarning2) {
          _controller.updateDegreeDifference(2);
          _controller.checkValidPattern(3);
        }
        if (_controller.triggerDegreeDifferenceWarning3) {
          _controller.updateDegreeDifference(3);
          _controller.checkValidPattern(3);
        }
        if (_controller.triggerDegreeDifferenceWarning4) {
          _controller.updateDegreeDifference(4);
          _controller.checkValidPattern(3);
        }
        _controller.triggerDegreeDifferenceAbnormal = false;
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
            if (_controller.transformerTicketController.checkAbnormalNotify(
                _controller.dataModel.value.checkBonded,
                nonCheck: true, title: 1))
              buildCheckBondedScreen(_controller),
            if (_controller.transformerTicketController.checkAbnormalNotify(
                _controller.dataModel.value.mbaLoadTest,
                nonCheck: true, title: 2))
              buildTransmission(_controller),
            if (_controller.transformerTicketController.checkAbnormalNotify(
                _controller.dataModel.value.oilTemperature,
                nonCheck: true, title: 3))
              buildTemperature(_controller),
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

