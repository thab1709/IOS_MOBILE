// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../common/constance/inspection_category.dart';
import '../../../../common/enum/ticket_enum.dart';
import '../../../../models/option_model.dart';
import '../../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../common/content_option.dart';
import '../../common/option_type.dart';
import '../../common/widget_items.dart';
import '../operation_log_controller.dart';

Widget BuildEnsure(OperationLogController _controller) {
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
        title: '2.Trạm biến áp/Đường dây',
        required: true,
        function: (value) {
          _controller.model.pmisEquipmentCategories = null;
          _controller.typeInspect = value?.toString()?.toIntOrNull();
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
            if (_controller.typeInspect ==
                ContentOptions.subStationInspect.value) {
              _controller.model.substationId = value.toString();
            } else {
              _controller.model.lineId = value.toString();
            }
            if (_controller.typeInspect ==
                ContentOptions.subStationInspect.value) {
              _controller.model.mcElectric = null;
              await _controller.getEquipmentByCategory(
                  substationId: _controller.model.substationId,
                  categoryId: HighElectricInspectionCategory.MC,
                  options: _controller.listCutterDevice);
            }
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
      if (_controller.typeInspect == ContentOptions.subStationInspect.value)
        WidgetItems(
          typeItem: TypeItem.multiDropdown,
          title: '3.Máy cắt',
          required: true,
          function: (value) {
            _controller.model.mcElectric = _controller.fromMultiOptionsSelected(
                options: List<OptionModelString>.from(value));
            _controller.refreshView();
          },
          optionsString: _controller.listCutterDevice.value,
          defaultOptionsString: _controller.getOptionInitValue(
              options: _controller.listCutterDevice.value,
              optionValue: _controller.model.mcElectric),
          invalid: _controller.invalid.value,
          readOnly: _controller.transformerTicketController.actionPopupType ==
              ActionTicketType.view,
        ),
      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '4.Nội dung ĐBĐ',
        textValue: _controller.model.contentDBD,
        required: true,
        function: (value) {
          _controller.model.contentDBD = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '5.Ghi chú',
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
        title: '6.Tải ảnh',
        required: true,
        function: (value) {},
        imagesValue: _controller.model.images,
        removeImage: (file) async {
          await _controller.removeImage(file);
          // _controller.refreshView();
        },
        addImage: (file) async {
          await _controller.addImage(images: file);
          // _controller.refreshView();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
    ],
  );
}

