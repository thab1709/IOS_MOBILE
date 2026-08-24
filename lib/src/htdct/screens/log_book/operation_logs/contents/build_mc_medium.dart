// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../common/constance/inspection_category.dart';
import '../../../../common/enum/ticket_enum.dart';
import '../../../../models/option_model.dart';
import '../../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../common/widget_items.dart';
import '../operation_log_controller.dart';

Widget BuildMcMedium(OperationLogController _controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const WidgetItems(
        typeItem: TypeItem.title,
        title: '1.Thời gian',
      ),
      //bắt đầu
      WidgetItems(
        typeItem: TypeItem.dateTimePicker,
        title: 'Nhảy',
        required: true,
        function: (value) {
          _controller.model.timeJump = (value as DateTime)
              ?.toUtc()
              ?.toStringFormat(HighElectricStrings.utcFormat);
          _controller.refreshView();
        },
        timeController: TextEditingController()
          ..text = _controller.model.timeJumpLocalTZ ?? '',
        isChildrenItem: true,
        invalid: _controller.invalid.value,
      ),
      //kết thúc
      WidgetItems(
        typeItem: TypeItem.dateTimePicker,
        title: 'Khôi phục',
        required: false,
        function: (value) {
          _controller.model.timeRecover = (value as DateTime)
              ?.toUtc()
              ?.toStringFormat(HighElectricStrings.utcFormat);
          _controller.refreshView();
        },
        timeController: TextEditingController()
          ..text = _controller.model.timeRecoverLocalTZ ?? '',
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: _controller.model.isBefore(
          dateTimeStart: _controller.model.timeJump,
          dateTimeEnd: _controller.model.timeRecover,
        ),
        invalidEndDate: _controller.model.isBefore(
          dateTimeStart: _controller.model.timeJump,
          dateTimeEnd: _controller.model.timeRecover,
        ),
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: '2.Loại bảo vệ tác động',
        required: false,
        function: (value) {
          _controller.model.protectType = _controller.fromMultiOptionsSelected(
              options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.protectTypeOptions,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.protectTypeOptions,
            optionValue: _controller.model.protectType),
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      const WidgetItems(
        typeItem: TypeItem.title,
        title: '3.Dòng sự cố',
        required: true,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Pha A',
        textValue: _controller.model.linePhaseA.toString(),
        required: !_controller.model.checkPhase(),
        function: (value) {
          _controller.model.linePhaseA = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Pha B',
        textValue: _controller.model.linePhaseB.toString(),
        required: !_controller.model.checkPhase(),
        function: (value) {
          _controller.model.linePhaseB = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Pha C',
        textValue: _controller.model.linePhaseC.toString(),
        required: !_controller.model.checkPhase(),
        function: (value) {
          _controller.model.linePhaseC = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Pha N',
        textValue: _controller.model.linePhaseN.toString(),
        required: !_controller.model.checkPhase(),
        function: (value) {
          _controller.model.linePhaseN = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      const WidgetItems(
        typeItem: TypeItem.title,
        title: '4.Điện áp sự cố',
        required: true,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Pha A',
        textValue: _controller.model.voltagePhaseA.toString(),
        required: !_controller.model.checkPhase(),
        function: (value) {
          _controller.model.voltagePhaseA = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Pha B',
        textValue: _controller.model.voltagePhaseB.toString(),
        required: !_controller.model.checkPhase(),
        function: (value) {
          _controller.model.voltagePhaseB = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Pha C',
        textValue: _controller.model.voltagePhaseC.toString(),
        required: !_controller.model.checkPhase(),
        function: (value) {
          _controller.model.voltagePhaseC = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Pha N',
        textValue: _controller.model.voltagePhaseN.toString(),
        required: !_controller.model.checkPhase(),
        function: (value) {
          _controller.model.voltagePhaseN = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '5.Trạm',
        required: true,
        function: (value) {
          if (value != null) {
            _controller.model.mcEquipmentId = null;
            _controller.model.mbaEquipmentId = null;

            _controller.getListTypeEquipmentTBAorLine(
                lineOrSubstationID: value.toString());
            _controller.model.substationId = value.toString();

            _controller.getEquipmentByCategory(
                substationId: value,
                categoryId: HighElectricInspectionCategory.MC,
                options: _controller.listCutterDevice);
            _controller.getEquipmentByCategory(
                substationId: value,
                categoryId: HighElectricInspectionCategory.MBA,
                options: _controller.listSubstationDevice);
            _controller.refreshView();
          } else {
            _controller.model.substationId = null;
          }
        },
        defaultSingleOptionsString: _controller.model.substationId,
        optionsString: _controller.listTBA.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
        invalid: _controller.invalid.value,
      ),
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '6.Máy cắt',
        required: true,
        function: (value) {
          _controller.model.mcEquipmentId = value ?? value.toString();
          _controller.refreshView();
        },
        defaultSingleOptionsString: _controller.model.mcEquipmentId,
        optionsString: _controller.listCutterDevice.value,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '7.Thuộc MBA',
        required: true,
        function: (value) {
          _controller.model.mbaEquipmentId = value ?? value.toString();
          _controller.refreshView();
        },
        defaultSingleOptionsString: _controller.model.mbaEquipmentId,
        optionsString: _controller.listSubstationDevice.value,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '8.Công suất MBA',
        textValue: _controller.getWattage(),
        //_controller.model.note,
        required: false,
        function: (value) {
          _controller.model.note = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: true,
        isNumber: false,
      ),
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '9.Cấp cho đơn vị Điện Lực',
        required: true,
        function: (value) {
          if (value != null) {
            _controller.getListTypeEquipmentTBAorLine(
                lineOrSubstationID: value.toString());
            _controller.model.powerSupply = value.toString();
          } else {
            _controller.model.powerSupply = null;
          }
        },
        defaultSingleOptionsString: _controller.model.powerSupply,
        optionsString: _controller.listUnitX6.value,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '10.Điện lực khác nếu có',
        textValue: _controller.model.otherUnit,
        required: false,
        function: (value) {
          _controller.model.otherUnit = value.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '11.Ghi chú',
        textValue: _controller.model.note,
        required: false,
        function: (value) {
          _controller.model.note = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      //Tải ảnh
      WidgetItems(
        typeItem: TypeItem.images,
        title: '12.Tải ảnh',
        required: false,
        function: (value) {},
        imagesValue: _controller.model.images,
        removeImage: (file) async {
          await _controller.removeImage(file);
          _controller.refreshView();
        },
        addImage: (file) async {
          await _controller.addImage(images: file);
          _controller.refreshView();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
    ],
  );
}

