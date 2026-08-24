// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bb_cong_to_controller.dart';
import '../common_components/dropdown_meter.dart';
import '../common_components/text_field_meter.dart';
import '../common_components/title_metter.dart';

class IndexMeter extends StatefulWidget {
  const IndexMeter({Key key}) : super(key: key);

  @override
  State<IndexMeter> createState() => _IndexMeterState();
}

class _IndexMeterState extends State<IndexMeter>
    with AutomaticKeepAliveClientMixin {
  final _controller = Get.find<BBCongToController>();

  final tinhTrangTemChiSoFN = FocusNode();
  final ptGiaoFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        _controller.unFocus();
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Obx(() => Column(
                children: [
                  _chiSoCongToTruocKiemTra(),
                  CheckboxListTile(
                    value: _controller.isChiSoSauKiem,
                    onChanged: (val) {
                      _controller.isChiSoSauKiem = val;
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Chỉ số công tơ sau kiểm tra'),
                  ),
                  _chiSoSauKiem()
                ],
              )),
        ),
      ),
    );
  }

  Widget _chiSoCongToTruocKiemTra() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleMeter(
          title: 'Chỉ số công tở trước kiểm tra:',
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'Pt(giao):',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller.meteDetailModel.value.ptGiao,
                  onValueChange: (value) {
                    _controller.meteDetailModel.value.ptGiao = value;
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
              title: 'Qt(giao):',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller.meteDetailModel.value.qtGiao,
                  onValueChange: (value) {
                    _controller.meteDetailModel.value.qtGiao = value;
                  },
                )),
          ],
        ),
        if (_controller.reportType.value != _controller.type2)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Expanded(
                      child: TitleMeter(
                    title: 'R1(giao):',
                  )),
                  Expanded(
                      flex: 2,
                      child: CustomTextFieldMeter(
                        enable: _controller.isEnable(),
                        isRefresh: _controller.isRefresh.value,
                        value: _controller.meteDetailModel.value.r1Giao,
                        onValueChange: (value) {
                          _controller.meteDetailModel.value.r1Giao = value;
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
                    title: 'R2(giao):',
                  )),
                  Expanded(
                      flex: 2,
                      child: CustomTextFieldMeter(
                        enable: _controller.isEnable(),
                        isRefresh: _controller.isRefresh.value,
                        value: _controller.meteDetailModel.value.r2Giao,
                        onValueChange: (value) {
                          _controller.meteDetailModel.value.r2Giao = value;
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
                    title: 'R3(giao):',
                  )),
                  Expanded(
                      flex: 2,
                      child: CustomTextFieldMeter(
                        enable: _controller.isEnable(),
                        isRefresh: _controller.isRefresh.value,
                        value: _controller.meteDetailModel.value.r3Giao,
                        onValueChange: (value) {
                          _controller.meteDetailModel.value.r3Giao = value;
                        },
                      )),
                ],
              ),
            ],
          ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'Pt(nhận):',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller.meteDetailModel.value.ptNhan,
                  onValueChange: (value) {
                    _controller.meteDetailModel.value.ptNhan = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'Qt(nhận):',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller.meteDetailModel.value.qtNhan,
                  onValueChange: (value) {
                    _controller.meteDetailModel.value.qtNhan = value;
                  },
                )),
          ],
        ),
        if (_controller.reportType.value != _controller.type3)
          const SizedBox(
            height: 16,
          ),
        if (_controller.reportType.value != _controller.type3)
          Row(
            children: [
              const Expanded(
                  child: TitleMeter(
                title: 'HSN:',
              )),
              Expanded(
                  flex: 2,
                  child: CustomTextFieldMeter(
                    enable: _controller.isEnable(),
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.hsn,
                    onValueChange: (value) {
                      _controller.meteDetailModel.value.hsn = value;
                    },
                  )),
            ],
          ),
        if (_controller.reportType.value != _controller.type3)
          const SizedBox(
            height: 16,
          ),
        if (_controller.reportType.value != _controller.type3)
          const TitleMeter(
            title: 'Tỉ số biến:',
          ),
        if (_controller.reportType.value != _controller.type3)
          const SizedBox(
            height: 10,
          ),
        if (_controller.reportType.value != _controller.type3)
          Row(
            children: [
              const Expanded(
                  child: TitleMeter(
                title: 'TU:',
              )),
              Expanded(
                  flex: 2,
                  child: CustomTextFieldMeter(
                    enable: _controller.isEnable(),
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.tySoBienTU,
                    onValueChange: (value) {
                      _controller.meteDetailModel.value.tySoBienTU = value;
                    },
                  )),
            ],
          ),
        if (_controller.reportType.value != _controller.type3)
          const SizedBox(
            height: 16,
          ),
        if (_controller.reportType.value != _controller.type3)
          Row(
            children: [
              const Expanded(
                  child: TitleMeter(
                title: 'TI:',
              )),
              Expanded(
                  flex: 2,
                  child: CustomTextFieldMeter(
                    enable: _controller.isEnable(),
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.tySoBienTI,
                    onValueChange: (value) {
                      _controller.meteDetailModel.value.tySoBienTU = value;
                    },
                  )),
            ],
          ),
        if (_controller.reportType.value != _controller.type3)
          const SizedBox(
            height: 16,
          ),
        if (_controller.reportType.value != _controller.type3)
          Row(
            children: [
              const Expanded(
                  child: TitleMeter(
                title: 'Tem cổng quang:',
              )),
              Expanded(
                  flex: 2,
                  child: CustomTextFieldMeter(
                    enable: _controller.isEnable(),
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.temCongQuang,
                    onValueChange: (value) {
                      _controller.meteDetailModel.value.temCongQuang = value;
                    },
                  )),
            ],
          ),
        if (_controller.reportType.value != _controller.type3)
          const SizedBox(
            height: 16,
          ),
        if (_controller.reportType.value != _controller.type3)
          Row(
            children: [
              const Expanded(
                  child: TitleMeter(
                title: 'Tình trạng tem:',
              )),
              Expanded(
                  flex: 2,
                  child: CustomDropDownMeter(
                    enable: _controller.isEnable(),
                    focusNode: tinhTrangTemChiSoFN,
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.tinhTrangTemChiSo
                        ?.toString(),
                    listOption: _controller.optionsStampType,
                    clearFocus: () {
                      _controller.unFocus();
                    },
                    onChange: (val) {
                      _controller.meteDetailModel.value.tinhTrangTemChiSo =
                          int.parse(val);
                      if (_controller.isChiSoSauKiem) {
                       FocusScope.of(context).requestFocus(ptGiaoFN);
                      } else {
                        _controller.unFocus();
                      }
                    },
                  )),
            ],
          ),
      ],
    );
  }

  Widget _chiSoSauKiem() {
    if (_controller.isChiSoSauKiem) {
      return Column(
        children: [
          Row(
            children: [
              const Expanded(
                  child: TitleMeter(
                title: 'Pt(giao):',
              )),
              Expanded(
                  flex: 2,
                  child: CustomTextFieldMeter(
                    enable: _controller.isEnable(),
                    focusNode: ptGiaoFN,
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.chiSoSauKiemPtGiao,
                    onValueChange: (value) {
                      _controller.meteDetailModel.value.chiSoSauKiemPtGiao =
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
                title: 'Qt(giao):',
              )),
              Expanded(
                  flex: 2,
                  child: CustomTextFieldMeter(
                    enable: _controller.isEnable(),
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.chiSoSauKiemQtGiao,
                    onValueChange: (value) {
                      _controller.meteDetailModel.value.chiSoSauKiemQtGiao =
                          value;
                    },
                  )),
            ],
          ),
          if (_controller.reportType.value != _controller.type2)
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Expanded(
                        child: TitleMeter(
                      title: 'R1(giao):',
                    )),
                    Expanded(
                        flex: 2,
                        child: CustomTextFieldMeter(
                          enable: _controller.isEnable(),
                          isRefresh: _controller.isRefresh.value,
                          value: _controller
                              .meteDetailModel.value.chiSoSauKiemR1Giao,
                          onValueChange: (value) {
                            _controller.meteDetailModel.value
                                .chiSoSauKiemR1Giao = value;
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
                      title: 'R2(giao):',
                    )),
                    Expanded(
                        flex: 2,
                        child: CustomTextFieldMeter(
                          enable: _controller.isEnable(),
                          isRefresh: _controller.isRefresh.value,
                          value: _controller
                              .meteDetailModel.value.chiSoSauKiemR2Giao,
                          onValueChange: (value) {
                            _controller.meteDetailModel.value
                                .chiSoSauKiemR2Giao = value;
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
                      title: 'R3(giao):',
                    )),
                    Expanded(
                        flex: 2,
                        child: CustomTextFieldMeter(
                          enable: _controller.isEnable(),
                          isRefresh: _controller.isRefresh.value,
                          value: _controller
                              .meteDetailModel.value.chiSoSauKiemR3Giao,
                          onValueChange: (value) {
                            _controller.meteDetailModel.value
                                .chiSoSauKiemR3Giao = value;
                          },
                        )),
                  ],
                ),
              ],
            ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Expanded(
                  child: TitleMeter(
                title: 'Pt(nhận):',
              )),
              Expanded(
                  flex: 2,
                  child: CustomTextFieldMeter(
                    enable: _controller.isEnable(),
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.chiSoSauKiemPtNhan,
                    onValueChange: (value) {
                      _controller.meteDetailModel.value.chiSoSauKiemPtNhan =
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
                title: 'Qt(nhận):',
              )),
              Expanded(
                  flex: 2,
                  child: CustomTextFieldMeter(
                    enable: _controller.isEnable(),
                    isRefresh: _controller.isRefresh.value,
                    value: _controller.meteDetailModel.value.chiSoSauKiemQtNhan,
                    onValueChange: (value) {
                      _controller.meteDetailModel.value.chiSoSauKiemQtNhan =
                          value;
                    },
                  )),
            ],
          ),
          if (_controller.reportType.value != _controller.type2) _buildRNhan()
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildRNhan() {
    return Column(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Expanded(
                    child: TitleMeter(
                  title: 'R1(nhận):',
                )),
                Expanded(
                    flex: 2,
                    child: CustomTextFieldMeter(
                      enable: _controller.isEnable(),
                      isRefresh: _controller.isRefresh.value,
                      value:
                          _controller.meteDetailModel.value.chiSoSauKiemR1Nhan,
                      onValueChange: (value) {
                        _controller.meteDetailModel.value.chiSoSauKiemR1Nhan =
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
                  title: 'R2(nhận):',
                )),
                Expanded(
                    flex: 2,
                    child: CustomTextFieldMeter(
                      enable: _controller.isEnable(),
                      isRefresh: _controller.isRefresh.value,
                      value:
                          _controller.meteDetailModel.value.chiSoSauKiemR2Nhan,
                      onValueChange: (value) {
                        _controller.meteDetailModel.value.chiSoSauKiemR2Nhan =
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
                  title: 'R3(nhận):',
                )),
                Expanded(
                    flex: 2,
                    child: CustomTextFieldMeter(
                      enable: _controller.isEnable(),
                      isRefresh: _controller.isRefresh.value,
                      value:
                          _controller.meteDetailModel.value.chiSoSauKiemR3Nhan,
                      onValueChange: (value) {
                        _controller.meteDetailModel.value.chiSoSauKiemR3Nhan =
                            value;
                      },
                    )),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

