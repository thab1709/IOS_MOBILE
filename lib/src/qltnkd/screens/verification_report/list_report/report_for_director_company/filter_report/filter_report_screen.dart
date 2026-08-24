// @dart=2.9
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/report_for_director_company/report_director_company_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FilterReportDirectorCompanyScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FilterReportState();
  }
}

class FilterReportState extends State<FilterReportDirectorCompanyScreen> {
  final _timeController = TextEditingController();
  final controller = Get.put(ReportDirectorCompanyController());

  @override
  void initState() {
    super.initState();
      _timeController.text =
          'Từ ${controller.fromDateTime.toStringFormat(RAppStrings.ddMMyyyy)} đến ${controller.toDateTime.toStringFormat(RAppStrings.ddMMyyyy)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Get.back();
            },
          ),
          title: const Text(
            'Bộ lọc',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: _buildBody());
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
                RDateTime(
                  title: 'Khoảng thời gian',
                  onTap: () {
                    _showTimePicker(context);
                  },
                  textController: _timeController,
                ),
                RDropDown(
                  title: 'Đơn vị',
                  value: controller.unitId,
                  options: controller.unitOptions,
                  parentMargin: const EdgeInsets.only(bottom: 16),
                  isHasDefaultValue: true,
                  onSelected: (value) {
                    controller.unitId = value;
                  },
                ),
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
        context, controller.fromDateTime, controller.toDateTime);
    if (arrDateSearch != null) {
      _timeController.text =
      'Từ ${arrDateSearch.start.toStringFormat(RAppStrings.ddMMyyyy)} đến ${arrDateSearch.end.toStringFormat(RAppStrings.ddMMyyyy)}';
      controller.fromDateTime = arrDateSearch.start;
      controller.toDateTime = arrDateSearch.end;
      controller.fromDate = arrDateSearch.start.formatFirstDate();
      controller.toDate = arrDateSearch.end.formatSecondDate();
    }
  }
}

