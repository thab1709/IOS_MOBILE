// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/constance/strings.dart';
import 'general_information_controller.dart';

class GeneralInformationView extends StatefulWidget {
  const GeneralInformationView();

  @override
  State<GeneralInformationView> createState() => _GeneralInformationViewState();
}

class _GeneralInformationViewState extends State<GeneralInformationView> with AutomaticKeepAliveClientMixin {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getGeneralInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => Scaffold(
          backgroundColor: HighElectricAppColor.bgColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: HighElectricAppColor.nature01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Công việc số',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: HighElectricAppColor.nature06),
                      ),
                      Text(
                        _controller?.tbaGeneralInfoModel?.value?.code ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: HighElectricAppColor.nature06),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: HighElectricAppColor.nature01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin trạm biến áp',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: HighElectricAppColor.nature06),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _buildItem(
                            'Tên trạm',
                            _controller
                                    .tbaGeneralInfoModel.value.substationName ??
                                ''),
                        const SizedBox(
                          height: 8,
                        ),
                          _buildItem(
                            'Tổng thiết bị có trong trạm',
                            _controller.tbaGeneralInfoModel.value.totalEquipment
                                    .toString() ??
                                ''),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem('Phân loại theo CBM',
                            _controller.tbaGeneralInfoModel.value.cbm),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem('Tỉnh/TP - Quận/Huyện - Phường/Xã',
                            '${_controller.tbaGeneralInfoModel.value.province ?? ''} - ${_controller.tbaGeneralInfoModel.value.district ?? ''} - ${_controller.tbaGeneralInfoModel.value.ward ?? ''}'),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem('Công suất', _controller.getWatt()),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                            'Chế độ vận hành',
                            _controller.tbaGeneralInfoModel.value.operation ??
                                ''),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                            'Điểm đầu nối',
                            _controller.tbaGeneralInfoModel.value.firstPoint ??
                                ''),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                                'Ngày vận hành',
                                _controller
                                    ?.tbaGeneralInfoModel?.value?.operateDate
                                    ?.fromFormatUtcToFormatLocal(
                                        HighElectricStrings.ddMMyyyy)) ??
                            '',
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                                'Thời gian tạo phiếu',
                                _controller
                                    ?.tbaGeneralInfoModel?.value?.createdDate
                                    ?.fromFormatUtcToFormatLocal(
                                        HighElectricStrings.hhmmddMMyyyy)) ??
                            '',
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                                'Thời gian kiểm tra gần nhất',
                                _controller
                                    ?.tbaGeneralInfoModel?.value?.lastestDate
                                    ?.fromFormatUtcToFormatLocal(
                                        HighElectricStrings.hhmmddMMyyyy)) ??
                            '',
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

