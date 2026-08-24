// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import '../../../../common/enum/ticket_enum.dart';
import '../../../../models/option_model.dart';
import '../../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../common/content_option.dart';
import '../../common/widget_items.dart';
import '../../common/option_type.dart';
import '../operation_log_controller.dart';

Widget BuildTrouble(OperationLogController _controller) {
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
        typeItem: TypeItem.textBox,
        title: '2.Người báo',
        textValue: _controller.model.reporters,
        required: false,
        function: (value) {},
        invalid: _controller.invalid.value,
        readOnly: true,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: '3.Người nhận',
        required: false,
        function: (value) {
          _controller.model.receiver = _controller.fromMultiOptionsSelected(
              options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.listUser.value,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.listUser.value,
            optionValue: _controller.model.receiver),
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),

      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '4.Người nhận khác nếu có',
        textValue: _controller.model.otherReceiver,
        required: false,
        function: (value) {
          _controller.model.otherReceiver = value.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '5.Trạm biến áp/Đường dây',
        required: true,
        function: (value) async {
          _controller.model.troubleType = null;
          _controller.model.pmisEquipmentCategories = null;
          _controller.model.equipmentsName = null;
          _controller.typeInspect = value?.toString()?.toIntOrNull();
          await _controller.getListTypeEquipmentTBAorLine(
              lineOrSubstationID: _controller.typeInspect ==
                      ContentOptions.subStationInspect.value
                  ? _controller.model.substationId ?? ''
                  : _controller.typeInspect == ContentOptions.lineInspect.value
                      ? _controller.model.lineId ?? ''
                      : '');
          await _controller.getListEquipmentTBAorLine(
              category: _controller.model.pmisEquipmentCategories ?? '');
          _controller.refreshView();
        },
        optionsNumber: OptionsType.TypeInspect.getOptions,
        defaultOptionsNumber: _controller.typeInspect,
        isNumber: true,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: 'Chọn',
        required: true,
        function: (value) async {
          if (value != null) {
            _controller.model.pmisEquipmentCategories = null;
            _controller.model.equipmentsName = null;
            if (_controller.typeInspect ==
                ContentOptions.subStationInspect.value) {
              _controller.model.substationId = value.toString();
            } else {
              _controller.model.lineId = value.toString();
            }

            await _controller.getListTypeEquipmentTBAorLine(
                lineOrSubstationID: value.toString());
            await _controller.getListEquipmentTBAorLine(
                category: _controller.model.pmisEquipmentCategories ?? '');
          } else {
            _controller.model.substationId = null;
            _controller.model.lineId = null;
          }
          _controller.refreshView();
        },
        defaultSingleOptionsString:
            _controller.typeInspect == ContentOptions.subStationInspect.value
                ? _controller.model.substationId
                : _controller.model.lineId,
        optionsString:
            _controller.typeInspect == ContentOptions.subStationInspect.value
                ? _controller.listTBA.value
                : _controller.typeInspect == ContentOptions.lineInspect.value
                    ? _controller.listLine.value
                    : [],
        invalid: _controller.invalid.value,
        isChildrenItem: true,
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
        title: '6.Tên thiết bị',
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
        typeItem: TypeItem.singleDropdown,
        title: '7.Phân loại sự cố',
        required: true,
        function: (value) {
          _controller.model.troubleType = value?.toString()?.toIntOrNull();
        },
        optionsNumber:
            _controller.typeInspect == ContentOptions.subStationInspect.value
                ? OptionsType.TroubleTypeSubstation.getOptions
                : _controller.typeInspect == ContentOptions.lineInspect.value
                    ? OptionsType.TroubleTypeLine.getOptions
                    : [],
        defaultOptionsNumber: _controller.model.troubleType,
        isNumber: true,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '8.Diễn biến sự cố',
        textValue: _controller.model.incidentTrouble,
        required: true,
        function: (value) {
          _controller.model.incidentTrouble = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '9.Nguyên nhân tác động sai',
        required: false,
        function: (value) {
          _controller.model.causeImpact = value?.toString()?.toIntOrNull();
        },
        optionsNumber: OptionsType.CauseImpact.getOptions,
        defaultOptionsNumber: _controller.model.causeImpact,
        isNumber: true,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '10.Chi tiết nguyên nhân',
        textValue: _controller.model.detailReason,
        required: false,
        function: (value) {
          _controller.model.detailReason = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '11.Biện pháp xử lý',
        textValue: _controller.model.solution,
        required: false,
        function: (value) {
          _controller.model.solution = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: '12.Đơn vị xử lý',
        required: false,
        function: (value) {
          _controller.model.unitHandle = _controller.fromMultiOptionsSelected(
              options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.listUnit.value,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.listUnit.value,
            optionValue: _controller.model.unitHandle),
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '13.Đơn vị xử lý khác(nếu có)',
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
        typeItem: TypeItem.multiDropdown,
        title: '14.Đơn vị chịu trách nhiệm',
        required: false,
        function: (value) {
          _controller.model.responsibleUnit =
              _controller.fromMultiOptionsSelected(
                  options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.listGroup.value,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.listGroup.value,
            optionValue: _controller.model.responsibleUnit),
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '15.Kết quả xử lý',
        textValue: _controller.model.resultHandler,
        required: false,
        function: (value) {
          _controller.model.resultHandler = value.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),

      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '16.Ghi chú',
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
        title: '17.Tải ảnh',
        required: true,
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

