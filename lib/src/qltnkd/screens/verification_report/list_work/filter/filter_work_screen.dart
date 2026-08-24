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
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/work_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterWorkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FilterWorkState();
  }
}

class FilterWorkState extends State<FilterWorkScreen> {
  final WorkReportController _controller = Get.find();
  final _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_controller.toDate.isNotEmpty) {
      _timeController.text =
          'Từ ${_controller.fromDateTime.toStringFormat(RAppStrings.ddMMyyyy)} đến ${_controller.toDateTime.toStringFormat(RAppStrings.ddMMyyyy)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    if(!RUserRole.isDriver)
                    RDropDown(
                      title: 'Loại vật tư thiết bị',
                      options: _controller.equipmentTypes,
                      value: _controller.equipmentType.toIntOrNull(),
                      parentMargin: const EdgeInsets.only(bottom: 16),
                      isHasDefaultValue: true,
                      onSelected: (value) {
                        _controller.equipmentType = value;
                      },
                    ),
                    if(!RUserRole.isDriver)
                    RDropDown(
                      title: 'Chi tiết vật tư thiết bị',
                      options: _controller.detailEquipmentList,
                      value: _controller.detailEquipmentType.toIntOrNull(),
                      parentMargin: const EdgeInsets.only(bottom: 16),
                      isHasDefaultValue: true,
                      onSelected: (value) {
                        _controller.detailEquipmentType = value;
                      },
                    ),
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
                Get.back(result: true);
              }),
          const SizedBox(
            width: 24,
          ),
          RButton(
            title: 'Áp dụng',
            action: () {
              Get.back(result: true);
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

