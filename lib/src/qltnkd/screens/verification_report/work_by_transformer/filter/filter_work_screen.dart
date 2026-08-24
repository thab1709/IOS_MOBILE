// @dart=2.9
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_text_field.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_by_transformer/work_by_transformer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterWorkByTransformerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterWorkState();
  }
}

class _FilterWorkState extends State<FilterWorkByTransformerScreen> {
  final WorkByTransformerController _controller = Get.find();
  final _timeController = TextEditingController();

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  String fromDate = DateTime.now().formatFirstDate();
  String toDate = DateTime.now().formatSecondDate();
  String equipment = '';
  String reportNumber = '';
  String stampNumber = '';
  String performer = '';
  String equipmentType = '0';
  String detailEquipmentType;
  bool isPaperReport;

  String unit = '0';
  String statusWork = '0';
  String workType = '0';

  @override
  void initState() {
    super.initState();
    if (_controller.toDate.isNotEmpty) {
      _timeController.text =
          'Từ ${_controller.fromDateTime.toStringFormat(RAppStrings.ddMMyyyy)} đến ${_controller.toDateTime.toStringFormat(RAppStrings.ddMMyyyy)}';
    }

    fromDate = _controller.fromDate;
    toDate = _controller.toDate;
    equipment = _controller.equipment;
    reportNumber = _controller.reportNumber;
    stampNumber = _controller.stampNumber;
    performer = _controller.performer;
    equipmentType = _controller.equipmentType;
    detailEquipmentType = _controller.detailEquipmentType;
    unit = _controller.unit;
    statusWork = _controller.statusWork;
    isPaperReport = _controller.isPaperReport.value;
    workType = _controller.workType;
  }

  void _setPreviousFilterValues() {
    _controller.fromDate = fromDate;
    _controller.toDate = toDate;
    _controller.isPaperReport.value = isPaperReport;
    _controller.equipment = equipment;
    _controller.reportNumber = reportNumber;
    _controller.stampNumber = stampNumber;
    _controller.performer = performer;
    _controller.equipmentType = equipmentType;
    _controller.detailEquipmentType = detailEquipmentType;
    _controller.unit = unit;
    _controller.statusWork = statusWork;
    _controller.workType = workType;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _setPreviousFilterValues();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: false,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                _setPreviousFilterValues();
                Get.back();
              },
            ),
            title: const Text(
              'Bộ lọc',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                      textController: _timeController,
                      onClear: () {
                        _controller.fromDate = '';
                        _controller.toDate = '';
                      },
                      margin: const EdgeInsets.only(bottom: 16),
                    ),
                    RTextField(
                      title: 'VTTB',
                      value: _controller.equipment,
                      margin: const EdgeInsets.only(bottom: 16),
                      onChange: (value) {
                        _controller.equipment = value;
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
                    if(!RUserRole.isDriver)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RTextField(
                            title: 'Số biên bản',
                            value: _controller.reportNumber,
                            margin: const EdgeInsets.only(bottom: 16),
                            onChange: (value) {
                              _controller.reportNumber = value;
                            },
                          ),
                          RTextField(
                            title: 'Số Stamp',
                            value: _controller.stampNumber,
                            margin: const EdgeInsets.only(bottom: 16),
                            onChange: (value) {
                              _controller.stampNumber = value;
                            },
                          ),
                          RDropDown(
                            title: 'Loại công việc',
                            options: workTypeOptions,
                            value: _controller.workType.toIntOrNull(),
                            parentMargin: const EdgeInsets.only(bottom: 16),
                            isHasDefaultValue: true,
                            onSelected: (value) {
                              _controller.workType = value;
                            },
                          ),
                          RDropDown(
                            title: 'Trạng thái công việc',
                            options: _controller.workStatusOptions,
                            value: _controller.workStatus.toIntOrNull(),
                            parentMargin: const EdgeInsets.only(bottom: 16),
                            isHasDefaultValue: true,
                            onSelected: (value) {
                              _controller.workStatus = value;
                            },
                          ),
                          RDropDown(
                            title: 'Đơn vị',
                            value: _controller.unit,
                            options: _controller.unitOptions,
                            parentMargin: const EdgeInsets.only(bottom: 16),
                            isHasDefaultValue: true,
                            onSelected: (value) {
                              _controller.unit = value;
                            },
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
          _buildButton()
        ],
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
              Get.back(result: true);
              _controller.checkFiltered();
            },
          )
        ],
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final arrDateSearch = await showTimePickerSearch(
        context, _controller.fromDateTime, _controller.toDateTime);
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

