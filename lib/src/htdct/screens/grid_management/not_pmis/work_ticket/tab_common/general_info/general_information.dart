// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/strings.dart';
import 'general_information_controller.dart';

class GeneralInformationView extends StatefulWidget {
  const GeneralInformationView();

  @override
  State<GeneralInformationView> createState() => _GeneralInformationViewState();
}

class _GeneralInformationViewState extends State<GeneralInformationView> {
  final TBAGeneralInfoController _controller = TBAGeneralInfoController();

  Widget _buildItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: HighElectricAppColor.nature05),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            value ?? '',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: HighElectricAppColor.nature06),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), getGeneralInfo);
  }

  Future getGeneralInfo() async {
    await _controller.getGeneralInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: HighElectricAppColor.bgColor,
          body: SingleChildScrollView(
            child: ListTileTheme(
              tileColor: Colors.grey.shade100,
              child: ExpansionTile(
                initiallyExpanded: true,
                title: const Text(
                  'Thông tin công việc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: HighElectricAppColor.nature06,
                  ),
                ),
                children: [
                  Container(
                    color: HighElectricAppColor.nature01,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildItem(
                            'Tên công việc',
                            _controller.transformerTicketController.workModel.name??
                                ''),
                        _buildItem(
                            'Trạm biến áp/ Đường dây(nếu có)',
                            _controller.transformerTicketController.workModel.entity.name ??
                                ''),
                        _buildItem(
                            'Thời gian tạo phiếu',
                            _controller?.tbaGeneralInfoModel?.value?.createdDate
                                ?.fromFormatUtcToFormatLocal(
                                HighElectricStrings.hhmmddMMyyyy)) ??
                            '',
                        _buildItem(
                            'Thời gian kiểm tra gần nhất',
                            _controller?.tbaGeneralInfoModel?.value?.lastestDate
                                ?.fromFormatUtcToFormatLocal(
                                HighElectricStrings.hhmmddMMyyyy)) ??
                            '',

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ));
  }
}

