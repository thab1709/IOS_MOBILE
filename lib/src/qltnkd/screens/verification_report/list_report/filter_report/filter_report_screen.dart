// @dart=2.9
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/constance/r_user_role_type.dart';
import '../../report_by_transformer/report_by_transformer_controller.dart';

class FilterReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterReportState();
  }
}

class _FilterReportState extends State<FilterReportScreen> {
  final _timeController = TextEditingController();

  final ReportByTransformerController _controller = Get.find();

  String unit;
  String workType;
  String reportType;
  String teamId;
  String userId;
  String locationReport;
  String content;
  String departmentId;
  String statusReport;
  bool isPaperReport;

  String equipmentType;
  String detailEquipmentType;
  DateTime fromDateTime;
  DateTime toDateTime;

  @override
  void initState() {
    super.initState();
    if (_controller.toDate.isNotEmpty) {
      _timeController.text =
          'Từ ${_controller.fromDateTime.toStringFormat(RAppStrings.ddMMyyyy)} đến ${_controller.toDateTime.toStringFormat(RAppStrings.ddMMyyyy)}';
    }
    unit = _controller.unit;
    workType = _controller.workType;
    reportType = _controller.reportType;
    teamId = _controller.teamId;
    userId = _controller.userId;
    statusReport = _controller.statusReport;
    locationReport = _controller.locationReport;
    content = _controller.content;
    isPaperReport = _controller.isPaperReport.value;
    departmentId = _controller.departmentId;
    equipmentType = _controller.equipmentType;
    detailEquipmentType = _controller.detailEquipmentType;
    fromDateTime = _controller.fromDateTime;
    toDateTime = _controller.toDateTime;
  }

  void _setToPreviousState() {
    _controller.unit = unit;
    _controller.workType = workType;
    _controller.reportType = reportType;
    _controller.teamId = teamId;
    _controller.userId = userId;
    _controller.statusReport = statusReport;
    _controller.locationReport = locationReport;
    _controller.content = content;
    _controller.isPaperReport.value = isPaperReport;
    _controller.departmentId = departmentId;
    _controller.equipmentType = equipmentType;
    _controller.detailEquipmentType = detailEquipmentType;
    _controller.fromDateTime = fromDateTime;
    _controller.toDateTime = toDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _setToPreviousState();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: false,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                _setToPreviousState();
                Get.back();
              },
            ),
            title: const Text(
              'Bộ lọc',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildListInput() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Obx(() => Checkbox(value: _controller.isPaperReport.value, onChanged: (isChecked) {
                      _controller.isPaperReport.value = isChecked;
                    }),
                  )),
                  const Text('Biên bản giấy', style: TextStyle(fontSize: 16))
                ],),
                const SizedBox(height: 10,),
                RDateTime(
                  title: 'Khoảng thời gian',
                  onTap: () {
                    _showTimePicker(context);
                  },
                  isShowClear: true,
                  onClear: () {
                    _controller.fromDate = '';
                    _controller.toDate = '';
                  },
                  textController: _timeController,
                ),
                RDropDown(
                  title: 'Trạng thái',
                  value: _controller.statusReport.toIntOrNull(),
                  options: _controller.optionsStatus,
                  parentMargin: const EdgeInsets.only(top: 16),
                  isHasDefaultValue: true,
                  onSelected: (value) {
                    _controller.statusReport = value;
                  },
                ),
                if(RUserRole.isWorker || RUserRole.isCaptain || RUserRole.isExpert)
                  RDropDown(
                    title: 'Loại vật tư thiết bị',
                    options: _controller.equipmentTypes,
                    value: _controller.equipmentType,
                    parentMargin: const EdgeInsets.only(bottom: 16),
                    isHasDefaultValue: true,
                    onSelected: (value) {
                      _controller.equipmentType = value;
                      _controller.renderEquipmentDetail(value);
                    },
                  ),
                if(RUserRole.isWorker || RUserRole.isCaptain || RUserRole.isExpert)
                  Obx(() => RDropDown(
                    title: 'Chi tiết vật tư thiết bị',
                    options: _controller.detailEquipmentList.value,
                    value: _controller.detailEquipmentType,
                    parentMargin: const EdgeInsets.only(bottom: 16),
                    isHasDefaultValue: true,
                    onSelected: (value) {
                      _controller.detailEquipmentType = value;
                    },
                  ),),
                // RDropDown(
                //   title: 'Loại công việc',
                //   value: _controller.workType.toIntOrNull(),
                //   options: workTypeOptions,
                //   parentMargin: const EdgeInsets.only(top: 16),
                //   isHasDefaultValue: true,
                //   onSelected: (value) {
                //     _controller.workType = value;
                //   },
                // ),
                // RDropDown(
                //   title: 'Kế hoạch',
                //   value: _controller.reportType.toIntOrNull(),
                //   options: reportTypeOptions,
                //   parentMargin: const EdgeInsets.only(top: 16),
                //   isHasDefaultValue: true,
                //   onSelected: (value) {
                //     _controller.reportType = value;
                //   },
                // ),
                // RDropDown(
                //   title: 'Trung tâm',
                //   value: _controller.departmentId,
                //   options: _controller.department,
                //   parentMargin: const EdgeInsets.only(top: 16),
                //   isHasDefaultValue: true,
                //   onSelected: (value) {
                //     _controller.departmentId = value;
                //   },
                // ),
                RDropDown(
                  title: 'Đơn vị',
                  value: _controller.unit,
                  options: _controller.unitOptions,
                  parentMargin: const EdgeInsets.only(top: 16),
                  isHasDefaultValue: true,
                  onSelected: (value) {
                    _controller.unit = value;
                  },
                ),
                // RDropDown(
                //   title: 'Tổ đội',
                //   value: _controller.teamId,
                //   options: _controller.teams,
                //   parentMargin: const EdgeInsets.only(top: 16),
                //   isHasDefaultValue: true,
                //   onSelected: (value) {
                //     _controller.teamId = value;
                //   },
                // ),
                // RDropDown(
                //   title: 'Người thực hiện',
                //   value: _controller.userId,
                //   options: _controller.users,
                //   parentMargin: const EdgeInsets.only(top: 16),
                //   isHasDefaultValue: true,
                //   onSelected: (value) {
                //     _controller.userId = value;
                //   },
                // ),
                // RDropDown(
                //   title: 'Địa điểm',
                //   value: _controller.locationReport,
                //   options: _controller.listSubstation,
                //   parentMargin: const EdgeInsets.symmetric(vertical: 16),
                //   isHasDefaultValue: true,
                //   onSelected: (value) {
                //     _controller.locationReport = value;
                //   },
                // ),
                // RTextField(
                //   title: 'Nội dung',
                //   value: _controller.content,
                //   margin: const EdgeInsets.only(bottom: 16),
                //   onChange: (value) {
                //     _controller.content = value;
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [_buildListInput(), _buildButton()],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: const EdgeInsets.all(PaddingSize.normal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RButton(
              title: 'Bỏ lọc',
              color: RAppColor.backgroundColorGray,
              titleColor: Colors.black,
              action: () {
                _controller.clearFilter();
                _controller.checkFiltered();
                Get.back(result: true);
              }),
          const SizedBox(
            width: 24,
          ),
          RButton(
            title: 'Áp dụng',
            action: () {
              _controller.checkFiltered();
              Get.back(result: true);
            },
          )
        ],
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final arrDateSearch =
        await showTimePickerSearch(context, _controller.fromDateTime, _controller.toDateTime);
    if (arrDateSearch != null) {
      _timeController.text =
      'Từ ${arrDateSearch.start.toStringFormat(RAppStrings.ddMMyyyy)} đến ${arrDateSearch.end.toStringFormat(RAppStrings.ddMMyyyy)}';
      _controller.fromDateTime = arrDateSearch.start;
      _controller.toDateTime = arrDateSearch.end;
      _controller.fromDate = arrDateSearch.start.formatFirstDate();
      _controller.toDate = arrDateSearch.end.formatSecondDate();
    }
  }
}

