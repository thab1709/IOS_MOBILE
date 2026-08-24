// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_text_field.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../unscheduled_report_controller.dart';
import 'add_unscheduled_controller.dart';

class AddUnScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddUnScheduleState();
  }
}

class AddUnScheduleState extends State<AddUnScheduleScreen> {
  final _timeController = TextEditingController();
  final _controller = Get.put(AddUnScheduleController());
  final UnscheduledReportController listReportController = Get.find();

  @override
  void initState() {
    super.initState();
    _timeController.text =
        _controller.dateTimeNow.toStringFormat(RAppStrings.ddMMyyyy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RAppColor.highlightColor70,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Biên bản không theo kế hoạch',
          style: TextStyle(fontSize: TextSize.normal),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
        child: Column(
      children: [_buildInput(), _buildButton()],
    ));
  }

  Widget _buildInput() {
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(PaddingSize.normal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RDropDown(
              title: 'Loại công việc',
              options: _controller.workTypeOptions,
              isRequire: true,
              isHasDefaultValue: true,
              onSelected: (value) {
                _controller.workType = value;
              },
            ),
            RDropDown(
              title: 'Đơn vị yêu cầu',
              options: listReportController.unitOptions,
              isRequire: true,
              parentMargin: const EdgeInsets.only(top: PaddingSize.normal),
              isHasDefaultValue: true,
              onSelected: (value) {
                _controller.unit = value;
              },
            ),
            RDropDown(
              title: 'Loại thiết bị',
              options: listReportController.equipmentTypes,
              parentMargin: const EdgeInsets.only(top: PaddingSize.normal),
              isHasDefaultValue: true,
              isRequire: true,
              onSelected: (value) {
                _controller.equipmentType.value = value;
                _controller.renderEquipmentDetail(value);
              },
            ),
            Obx(
              () => RDropDown(
                title: 'Chi tiết thiết bị',
                options: _controller.optionEquipment.value,
                value: _controller.equipmentDetail.value,
                parentMargin: const EdgeInsets.only(top: PaddingSize.normal),
                isHasDefaultValue: true,
                isRequire: true,
                onSelected: (value) {
                  _controller.equipmentDetail.value = value;
                  _controller.renderListForms(value);
                },
              ),
            ),
            RTextField(
              title: 'Người thực hiện',
              margin: const EdgeInsets.only(top: PaddingSize.normal),
              isEnable: false,
              value: _controller.user.name,
            ),
            RTextField(
              title: 'Tổ đội',
              margin: const EdgeInsets.only(top: PaddingSize.normal),
              isEnable: false,
              value: _controller.user.teamName,
            ),
            RTextField(
              title: 'Trung tâm thí nghiệm',
              margin: const EdgeInsets.only(top: PaddingSize.normal),
              isEnable: false,
              value: _controller.user.departmentName,
            ),
            RDateTime(
              title: 'Ngày tạo',
              textController: _timeController,
              margin: const EdgeInsets.only(top: PaddingSize.normal),
            ),
            RTextField(
              title: 'Địa điểm',
              isRequire: true,
              value: _controller.location,
              margin: const EdgeInsets.only(top: PaddingSize.normal),
              onChange: (value) {
                _controller.location = value;
              },
            ),
            RTextField(
              title: 'Nội dung',
              value: _controller.content,
              margin: const EdgeInsets.only(top: PaddingSize.normal),
              onChange: (value) {
                _controller.content = value;
              },
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildButton() {
    return RButton(
      maxSize: true,
      title: 'Tạo biên bản',
      borderRadius: 0,
      action: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (_controller.isHanding) {
          return;
        }

        _controller.createdReportNotPlan();
      },
    );
  }
}

