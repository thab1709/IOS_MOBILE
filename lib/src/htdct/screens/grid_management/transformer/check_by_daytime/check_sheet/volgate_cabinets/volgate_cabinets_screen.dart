// @dart=2.9
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/app_color.dart';
import '../../../../../../models/day_night/popups/voltage_cabinet_model.dart';
import '../../../../base/base_popup_wigget.dart';
import 'check_content/check_content_screen.dart';
import 'volgate_cabinets_controller.dart';

class VoltageCabinetScreen extends BasePopupWidget {

  final keyboardVisibilityController = KeyboardVisibilityController();

  VoltageCabinetScreen({@required EquipmentModel model, List<EquipmentModel> equipmentsDestination, String ticketId}) {
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

  final _controller = VoltageCabinetController<VoltageCabinetModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>KeyboardVisibilityProvider(child: _renderBody(context)));
  }

  Widget _renderBody(BuildContext context) {
    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((visible) {
     if(!visible && _controller.triggerAutoUpdateAbnormal) {
       _controller.updateDegreeDifference();
       _controller.updateBusbarVoltageDC();
       _controller.triggerAutoUpdateAbnormal = false;
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
            buildCheckContentScreen(_controller),
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

