// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bb_cong_to_controller.dart';
import '../common_components/dropdown_meter.dart';
import '../common_components/text_field_meter.dart';
import '../common_components/title_metter.dart';

class MaChiPhanCaiDat extends StatefulWidget {
  const MaChiPhanCaiDat({Key key}) : super(key: key);

  @override
  State<MaChiPhanCaiDat> createState() => _MaChiPhanCaiDatState();
}

class _MaChiPhanCaiDatState extends State<MaChiPhanCaiDat>
    with AutomaticKeepAliveClientMixin {
  final _controller = Get.find<BBCongToController>();
  final tinhTrangChiFN = FocusNode();
  final temKiemDinhFN = FocusNode();
  final tinhTrangTemChiPhanCaiDatFN = FocusNode();
  final soDoDauDayDoLuongFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        _controller.unFocus();
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Mã chì phần cài đặt:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller
                                .meteDetailModel.value.maChiPhanCaiDat,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value
                                  .maChiPhanCaiDat = value;
                            },
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Số lượng chỉ tai:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value:
                                _controller.meteDetailModel.value.soLuongChiTai,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.soLuongChiTai =
                                  value;
                            },
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Mã chỉ tai:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.maChiTai,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.maChiTai =
                                  value;
                            },
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Tình trạng chì:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomDropDownMeter(
                            key: const Key('tinhTrangChi'),
                            focusNode: tinhTrangChiFN,
                            clearFocus: () {
                              _controller.unFocus();
                            },
                            onChange: (val) {
                              _controller.meteDetailModel.value.tinhTrangChi =
                                  int.parse(val);
                              FocusScope.of(context)
                                  .requestFocus(temKiemDinhFN);
                            },
                            value: _controller
                                .meteDetailModel.value.tinhTrangChi
                                ?.toString(),
                            listOption: _controller.optionsStatusWrite,
                            isRefresh: _controller.isRefresh.value,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Tem kiểm định',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            focusNode: temKiemDinhFN,
                            isRefresh: _controller.isRefresh.value,
                            value:
                                _controller.meteDetailModel.value.temKiemDinh,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.temKiemDinh =
                                  value;
                            },
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Tình trạng tem',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomDropDownMeter(
                            key: const Key('tinhTrangTemChiPhanCaiDat'),
                            focusNode: tinhTrangTemChiPhanCaiDatFN,
                            clearFocus: () {
                              _controller.unFocus();
                            },
                            onChange: (val) {
                              _controller.meteDetailModel.value
                                  .tinhTrangTemChiPhanCaiDat = int.parse(val);
                              if (_controller.reportType.value == _controller.type1){
                                FocusScope.of(context).requestFocus(soDoDauDayDoLuongFN);
                              } else {
                                _controller.unFocus();
                              }
                            },
                            value: _controller
                                .meteDetailModel.value.tinhTrangTemChiPhanCaiDat
                                ?.toString(),
                            listOption: _controller.optionsStampType,
                            isRefresh: _controller.isRefresh.value,
                          )),
                    ],
                  ),
                  if (_controller.reportType.value == _controller.type1)
                    const SizedBox(
                      height: 16,
                    ),
                  if (_controller.reportType.value == _controller.type1)
                    Row(
                      children: [
                        const Expanded(
                            child: TitleMeter(
                          title: 'Sơ đồ đấu dây đo lường',
                        )),
                        Expanded(
                            flex: 2,
                            child: CustomTextFieldMeter(
                              enable: _controller.isEnable(),
                              isRefresh: _controller.isRefresh.value,
                              focusNode: soDoDauDayDoLuongFN,
                              value: _controller
                                  .meteDetailModel.value.soDoDauDayDoLuong,
                              onValueChange: (value) {
                                _controller.meteDetailModel.value
                                    .soDoDauDayDoLuong = value;
                              },
                            )),
                      ],
                    ),
                  if (_controller.reportType.value == _controller.type1)
                    const SizedBox(
                      height: 16,
                    ),
                  if (_controller.reportType.value == _controller.type1)
                    Row(
                      children: [
                        const Expanded(
                            child: TitleMeter(
                          title: 'Chỉ số công tơ kiểm cảm ứng',
                        )),
                        Expanded(
                            flex: 2,
                            child: CustomTextFieldMeter(
                              enable: _controller.isEnable(),
                              isRefresh: _controller.isRefresh.value,
                              value: _controller
                                  .meteDetailModel.value.chiSoCongToCamUng,
                              onValueChange: (value) {
                                _controller.meteDetailModel.value
                                    .chiSoCongToCamUng = value;
                              },
                            )),
                      ],
                    ),
                ],
              )),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

