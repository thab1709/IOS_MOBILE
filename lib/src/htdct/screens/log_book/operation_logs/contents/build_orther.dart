// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../common/enum/ticket_enum.dart';
import '../../../../models/option_model.dart';
import '../../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../common/widget_items.dart';
import '../operation_log_controller.dart';

Widget BuildOther(OperationLogController _controller) {
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
        required: true,
        function: (value) {},
        invalid: _controller.invalid.value,
        readOnly: true,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: '3.Người nhận',
        required: true,
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
        title: '4.Người nhận khác(nếu có)',
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
        typeItem: TypeItem.textArea,
        title: '5.Nội dung khác',
        textValue: _controller.model.otherContent,
        required: true,
        function: (value) {
          _controller.model.otherContent = value?.toString();
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

