// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../common/enum/ticket_enum.dart';
import '../../../../common/utils/common.dart';
import '../../../../models/option_model.dart';
import '../../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../common/widget_items.dart';
import '../operation_log_controller.dart';

Widget BuildFullOperation(OperationLogController _controller) {
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
        title: 'Bắt đầu',
        required: true,
        function: (value) {
          _controller.model.dateStart = (value as DateTime)
              ?.toUtc()
              ?.toStringFormat(HighElectricStrings.utcFormat);
          _controller.refreshView();
        },
        timeController: TextEditingController()
          ..text = _controller.model.dateStartLocalTZ ?? '',
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      //kết thúc
      WidgetItems(
        typeItem: TypeItem.dateTimePicker,
        title: 'Kết thúc',
        required: false,
        function: (value) {
          _controller.model.endDate = (value as DateTime)
              ?.toUtc()
              ?.toStringFormat(HighElectricStrings.utcFormat);
          _controller.refreshView();
        },
        timeController: TextEditingController()
          ..text = _controller.model.endDateLocalTZ ?? '',
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: _controller.model.isBefore(
          dateTimeStart: _controller.model.dateStart,
          dateTimeEnd: _controller.model.endDate,
        ),
        invalidEndDate: _controller.model.isBefore(
          dateTimeStart: _controller.model.dateStart,
          dateTimeEnd: _controller.model.endDate,
        ),
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '2.Trạm',
        required: true,
        function: (value) {
          if (value != null) {
            _controller.model.pmisEquipmentCategories = null;
            _controller.getListTypeEquipmentTBAorLine(
                lineOrSubstationID: value.toString());

            _controller.getListEquipmentTBAorLine();

            _controller.model.substationId = value.toString();
          } else {
            _controller.model.substationId = null;
          }
        },
        defaultSingleOptionsString: _controller.model.substationId,
        optionsString: _controller.listTBA.value,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Loại thiết bị',
        required: true,
        function: (value) {
          _controller.model.pmisEquipmentCategories =
              _controller.fromMultiOptionsSelected(
                  options: List<OptionModelString>.from(value));
          _controller.getListEquipmentTBAorLine(
              category: _controller.model.pmisEquipmentCategories);
          _controller.model.equipmentsName = null;
          _controller.refreshView();
        },
        optionsString: _controller.listTypeEquipmentTBAorLine.value,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.listTypeEquipmentTBAorLine.value,
            optionValue: _controller.model.pmisEquipmentCategories),
        invalid: _controller.invalid.value,
        isChildrenItem: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: '3.Tên thiết bị',
        required: true,
        function: (value) {
          _controller.model.equipmentsName =
              _controller.fromMultiOptionsSelected(
                  options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.listEquipmentTBAorLine.value,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.listEquipmentTBAorLine.value,
            optionValue: _controller.model.equipmentsName),
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '4.Dòng mang tải',
        textValue: _controller.model.loadCarry.toString(),
        required: true,
        function: (value) {
          _controller.model.loadCarry = value?.toString()?.toDoubleOrNull();
          _controller.keyboardVisibilityTrigger = true;
        },
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '5.Dòng định mức tại nấc vận hành',
        textValue: _controller.model.ratedCurrent.toString(),
        required: true,
        function: (value) {
          _controller.model.ratedCurrent = value?.toString()?.toDoubleOrNull();
          _controller.keyboardVisibilityTrigger = true;
        },
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '6.Mức độ mang tải (%)',
        textValue: (_controller.model.ratedCurrent == null ||
                _controller.model.ratedCurrent == 0 ||
                _controller.model.loadCarry == null)
            ? ''
            : roundDouble(
                    (_controller.model.loadCarry /
                            _controller.model.ratedCurrent) *
                        100,
                    2)
                .toString(),
        required: false,
        function: (value) {},
        invalid: _controller.invalid.value,
        isNumber: true,
        readOnly: true,
      ),

      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '7.Ghi chú',
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
        title: '8.Tải ảnh',
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

