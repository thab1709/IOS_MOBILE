// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../models/day_night/ticket.dart';
import 'line_information_controller.dart';

class LineGeneralInformationView extends StatefulWidget {
  const LineGeneralInformationView();

  @override
  State<LineGeneralInformationView> createState() =>
      _LineGeneralInformationViewState();
}

class _LineGeneralInformationViewState
    extends State<LineGeneralInformationView> with AutomaticKeepAliveClientMixin {
  final LineGeneralInfoController _controller = LineGeneralInfoController();

  Widget _buildItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                        _controller?.lineGeneralInfoModel?.value?.code ?? '',
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
                          'Thông tin đường dây',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: HighElectricAppColor.nature06),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _buildItem(
                            'Tên đường dây',
                            _controller.lineGeneralInfoModel.value.lineName ??
                                ''),
                        const SizedBox(
                          height: 8,
                        ),
                        if(_controller.transformerTicketController.ticketType == TicketType.periodicMonth)
                        _buildItem(
                            'Tổng thiết bị có trong đường dây',
                            _controller.lineGeneralInfoModel.value.totalEquipment
                                .toString() ??
                                ''),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                            'Đường dây chung cột',
                            _controller
                                .lineGeneralInfoModel.value.lineWithPole),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem('Vùng miền',
                            '${_controller.lineGeneralInfoModel.value.regions ?? ''}'),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                            'Tổng chiều dài',
                            '${_controller.lineGeneralInfoModel.value.totalLength} Km' ??
                                ''),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                            'Số mạch',
                            _controller
                                    .lineGeneralInfoModel.value.circuitNumber ??
                                ''),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                            'Điện áp thiết kế',
                            _controller
                                    .lineGeneralInfoModel.value.designVoltage ??
                                ''),
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        _buildItem(
                            'Ngày vận hành',
                            _controller
                                ?.lineGeneralInfoModel?.value?.operationDate
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
                                ?.lineGeneralInfoModel?.value?.createdDate
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
                                ?.lineGeneralInfoModel?.value?.lastestDate
                                ?.fromFormatUtcToFormatLocal(
                                HighElectricStrings.hhmmddMMyyyy)) ?? '',
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                              color: HighElectricAppColor.nature02),
                        ),
                        // _buildItem(
                        //     'Tình trạng vận hành gần nhất',
                        //     _controller.lineGeneralInfoModel.value
                        //             .operationStatus ??
                        //         ''),
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

