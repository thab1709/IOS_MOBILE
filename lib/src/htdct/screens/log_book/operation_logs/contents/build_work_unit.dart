// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/option_model.dart';
import 'package:flutter/material.dart';
import '../../../../common/enum/ticket_enum.dart';
import '../../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../common/content_option.dart';
import '../../common/widget_items.dart';
import '../../common/option_type.dart';
import '../operation_log_controller.dart';

Widget BuildWorkUnit(OperationLogController _controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //Thời gian kế hoạch
      const WidgetItems(
        typeItem: TypeItem.title,
        title: '1.Thời gian kế hoạch',
      ),
      //bắt đầu
      WidgetItems(
        typeItem: TypeItem.dateTimePicker,
        title: 'Bắt đầu',
        required: false,
        function: (value) {
          _controller.model.startDatePlan = (value as DateTime)
              ?.toUtc()
              ?.toStringFormat(HighElectricStrings.utcFormat);
          _controller.refreshView();
        },
        timeController: TextEditingController()
          ..text = _controller.model.startDatePlanLocalTZ ?? '',
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
          _controller.model.endDatePlan = (value as DateTime)
              ?.toUtc()
              ?.toStringFormat(HighElectricStrings.utcFormat);
          _controller.refreshView();
        },
        timeController: TextEditingController()
          ..text = _controller.model.endDatePlanLocalTZ ?? '',
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: _controller.model.isBefore(
          dateTimeStart: _controller.model.startDatePlan,
          dateTimeEnd: _controller.model.endDatePlan,
        ),
        invalidEndDate: _controller.model.isBefore(
          dateTimeStart: _controller.model.startDatePlan,
          dateTimeEnd: _controller.model.endDatePlan,
        ),
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      //Thời gian thực tế
      const WidgetItems(
        typeItem: TypeItem.title,
        title: '2.Thời gian thực tế',
      ),
      //bắt đầu
      WidgetItems(
        typeItem: TypeItem.dateTimePicker,
        title: 'Bắt đầu',
        required: true,
        function: (value) {
          _controller.model.startDateReal = (value as DateTime)
              ?.toUtc()
              ?.toStringFormat(HighElectricStrings.utcFormat);
          _controller.refreshView();
        },
        timeController: TextEditingController()
          ..text = _controller.model.startDateRealLocalTZ ?? '',
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
          _controller.model.endDateReal = (value as DateTime)
              ?.toUtc()
              ?.toStringFormat(HighElectricStrings.utcFormat);
          _controller.refreshView();
        },
        timeController: TextEditingController()
          ..text = _controller.model.endDateRealLocalTZ ?? '',
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: _controller.model.isBefore(
          dateTimeStart: _controller.model.startDateReal,
          dateTimeEnd: _controller.model.endDateReal,
        ),
        invalidEndDate: _controller.model.isBefore(
          dateTimeStart: _controller.model.startDateReal,
          dateTimeEnd: _controller.model.endDateReal,
        ),
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      //Căn cứ công tác
      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '3.Căn cứ công tác',
        required: true,
        function: (value) {
          _controller.model.workBase = value?.toString()?.toIntOrNull();
          _controller.refreshView();
        },
        optionsNumber: OptionsType.WorkBase.getOptions,
        defaultOptionsNumber: _controller.model.workBase,
        isNumber: true,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
        invalid: _controller.invalid.value,
      ),
      const WidgetItems(
        typeItem: TypeItem.title,
        title: '4.Phân loại',
        required: true,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Lắp đặt thiết bị',
        required: !_controller.model.checkValidEquipmentInstallation(),
        function: (value) {
          _controller.model.equipmentInstallation =
              _controller.fromMultiOptionsSelected(
                  options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.equipmentInstallationOptions,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.equipmentInstallationOptions,
            optionValue: _controller.model.equipmentInstallation),
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: !_controller.model.checkValidEquipmentInstallation() &&
            _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Xử lý',
        required: !_controller.model.checkValidEquipmentInstallation(),
        function: (value) {
          _controller.model.handle = _controller.fromMultiOptionsSelected(
              options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.handleOptions,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.handleOptions,
            optionValue: _controller.model.handle),
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: !_controller.model.checkValidEquipmentInstallation() &&
            _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Định kỳ',
        required: !_controller.model.checkValidEquipmentInstallation(),
        function: (value) {
          _controller.model.schedule = _controller.fromMultiOptionsSelected(
              options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.scheduleOptions,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.scheduleOptions,
            optionValue: _controller.model.schedule),
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: !_controller.model.checkValidEquipmentInstallation() &&
            _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Đo điểm',
        required: !_controller.model.checkValidEquipmentInstallation(),
        function: (value) {
          _controller.model.measurements = _controller.fromMultiOptionsSelected(
              options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.measurementsOptions,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.measurementsOptions,
            optionValue: _controller.model.measurements),
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: !_controller.model.checkValidEquipmentInstallation() &&
            _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Vận hành',
        required: !_controller.model.checkValidEquipmentInstallation(),
        function: (value) {
          _controller.model.operation = _controller.fromMultiOptionsSelected(
              options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.operationOptions,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.operationOptions,
            optionValue: _controller.model.operation),
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: !_controller.model.checkValidEquipmentInstallation() &&
            _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Đoàn kiểm tra',
        required: !_controller.model.checkValidEquipmentInstallation(),
        function: (value) {
          _controller.model.inspectionTeam =
              _controller.fromMultiOptionsSelected(
                  options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.inspectionTeamOptions,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.inspectionTeamOptions,
            optionValue: _controller.model.inspectionTeam),
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: !_controller.model.checkValidEquipmentInstallation() &&
            _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Khác',
        textValue: _controller.model.other,
        required: false,
        function: (value) {
          _controller.model.other = value.toString();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),

      WidgetItems(
        typeItem: TypeItem.singleDropdown,
        title: '5.Trạm biến áp/Đường dây',
        required: true,
        function: (value) async {
          _controller.model.pmisEquipmentCategories = null;
          _controller.model.pmisEquipmentCategoriesChecks = null;
          _controller.model.pmisEquipmentCategoriesNonChecks = null;
          _controller.model.reason = null;
          _controller.typeInspect = value?.toString()?.toIntOrNull();
          await _controller.getListTypeEquipmentTBAorLine(
              lineOrSubstationID: _controller.typeInspect ==
                      ContentOptions.subStationInspect.value
                  ? _controller.model.substationId ?? ''
                  : _controller.typeInspect == ContentOptions.lineInspect.value
                      ? _controller.model.lineId ?? ''
                      : '');
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
            _controller.model.pmisEquipmentCategoriesChecks = null;
            _controller.model.pmisEquipmentCategoriesNonChecks = null;
            _controller.model.reason = null;
            if (_controller.typeInspect ==
                ContentOptions.subStationInspect.value) {
              _controller.model.substationId = value.toString();
            } else {
              _controller.model.lineId = value.toString();
            }

            await _controller.getListTypeEquipmentTBAorLine(
                lineOrSubstationID: value.toString());
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
        title: '6.Đối tượng công tác',
        required: true,
        function: (value) {
          _controller.model.pmisEquipmentCategories =
              _controller.fromMultiOptionsSelected(
                  options: List<OptionModelString>.from(value));
          _controller.model.pmisEquipmentCategoriesChecks = null;
          _controller.model.pmisEquipmentCategoriesNonChecks = null;
          _controller.model.reason = null;
          _controller.refreshView();
        },
        optionsString: _controller.listTypeEquipmentTBAorLine.value,
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.listTypeEquipmentTBAorLine.value,
            optionValue: _controller.model.pmisEquipmentCategories),
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),

      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '7.Phạm vi công tác',
        textValue: _controller.model.scopeWork,
        required: true,
        function: (value) {
          _controller.model.scopeWork = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '8.Tên đơn công tác',
        textValue: _controller.model.unitWork,
        required: true,
        function: (value) {
          _controller.model.unitWork = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '9.Nội dung công tác',
        textValue: _controller.model.contentWork,
        required: true,
        function: (value) {
          _controller.model.contentWork = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '10.Người chỉ huy trực tiếp',
        textValue: _controller.model.leadDirect,
        required: true,
        function: (value) {
          _controller.model.leadDirect = value?.toString();
        },
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: '11.Người giám sát an toàn điện (nếu có)',
        textValue: _controller.model.monitorElectric,
        required: false,
        function: (value) {
          _controller.model.monitorElectric = value?.toString();
        },
        invalid: _controller.invalid.value,
      ),
      const WidgetItems(
        typeItem: TypeItem.title,
        title: '12.Kết quả',
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Đã thực hiện',
        required: !_controller.model.checkPmisEquipmentCategories(),
        function: (value) {
          _controller.model.pmisEquipmentCategoriesChecks =
              _controller.fromMultiOptionsSelected(
                  options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.getOptionInitValue(
            options: _controller.listTypeEquipmentTBAorLine.value,
            optionValue: _controller.model.pmisEquipmentCategories),
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.getOptionInitValue(
                options: _controller.listTypeEquipmentTBAorLine.value,
                optionValue: _controller.model.pmisEquipmentCategories),
            optionValue: _controller.model.pmisEquipmentCategoriesChecks),
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: _controller.invalid.value &&
            !_controller.model.checkPmisEquipmentCategories(),
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.multiDropdown,
        title: 'Chưa thực hiện',
        required: !_controller.model.checkPmisEquipmentCategories(),
        function: (value) {
          _controller.model.pmisEquipmentCategoriesNonChecks =
              _controller.fromMultiOptionsSelected(
                  options: List<OptionModelString>.from(value));
          _controller.refreshView();
        },
        optionsString: _controller.getOptionInitValue(
            options: _controller.listTypeEquipmentTBAorLine.value,
            optionValue: _controller.model.pmisEquipmentCategories),
        defaultOptionsString: _controller.getOptionInitValue(
            options: _controller.getOptionInitValue(
                options: _controller.listTypeEquipmentTBAorLine.value,
                optionValue: _controller.model.pmisEquipmentCategories),
            optionValue: _controller.model.pmisEquipmentCategoriesNonChecks),
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        invalidEx: _controller.invalid.value &&
            !_controller.model.checkPmisEquipmentCategories(),
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),
      WidgetItems(
        typeItem: TypeItem.textBox,
        title: 'Lý do',
        textValue: _controller.model.reason,
        required:
            !_controller.model.pmisEquipmentCategoriesNonChecks.isNullOrEmpty(),
        function: (value) {
          _controller.model.reason = value?.toString();
        },
        isChildrenItem: true,
        invalid: _controller.invalid.value,
        readOnly: _controller.transformerTicketController.actionPopupType ==
            ActionTicketType.view,
      ),

      WidgetItems(
        typeItem: TypeItem.textArea,
        title: '13.Ghi chú',
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
        title: 'Tải ảnh',
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

