// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../dialog/popup.dart';
import '../bb_cong_to_controller.dart';
import '../common_components/dropdown_multi_select.dart';
import '../common_components/text_field_meter.dart';
import '../common_components/title_metter.dart';

class TestResult extends StatefulWidget {
  const TestResult({Key key}) : super(key: key);

  @override
  State<TestResult> createState() => _TestResultState();
}

class _TestResultState extends State<TestResult>
    with AutomaticKeepAliveClientMixin {
  final _controller = Get.find<BBCongToController>();

  final congToDienIdsFN = FocusNode();
  final machDoLuongIdsFN = FocusNode();
  final cacYKienKhacIdsFN = FocusNode();

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
                  if (_controller.reportType.value == _controller.type1)
                    _buildKiemTra(),
                  if (_controller.reportType.value != _controller.type1)
                    _buildSaiSoCos(),
                  _buildDoNhayTuQuayTST(),
                  if (_controller.reportType.value == _controller.type1)
                    _buildMachDoluongDienNang(),
                  _buildKetLuanChung(),
                  if (_controller.reportType.value == _controller.type1)
                    _buildKetLuan(),
                  Row(
                    children: [
                      Expanded(
                          child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Đạt'),
                        onChanged: _controller.isEnable()
                            ? (val) {
                                _controller.groupConclusion = val;
                              }
                            : null,
                        value: _controller.pass,
                        groupValue: _controller.groupConclusion,
                      )),
                      Expanded(
                          child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Không đạt'),
                        onChanged: _controller.isEnable()
                            ? (val) {
                                _controller.groupConclusion = val;
                              }
                            : null,
                        value: _controller.fail,
                        groupValue: _controller.groupConclusion,
                      )),
                      Expanded(
                          child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Khác'),
                        onChanged: _controller.isEnable()
                            ? (val) {
                                _controller.groupConclusion = val;
                              }
                            : null,
                        value: _controller.other,
                        groupValue: _controller.groupConclusion,
                      )),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildKiemTra() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'U Kiểm tra',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.uKiemTra,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.uKiemTra = value;
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
              title: 'I Kiểm tra',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.iKiemTra,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.iKiemTra = value;
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
              title: 'Hệ số Cosφ',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.heSoCos,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.heSoCos = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _buildSaiSoCos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleMeter(
          title: 'Sai số:',
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: '100% cos1:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.cos1100,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.cos1100 = value;
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
              title: '100% cos 0.5:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.cos05100,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.cos05100 = value;
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
              title: '10% cos1:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.cos110,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.cos110 = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _buildDoNhayTuQuayTST() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'Độ nhạy:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.doNhay,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.doNhay = value;
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
              title: 'Tự quay:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.tuQuay,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.tuQuay = value;
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
              title: 'Tỉ số chuyền:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.tySoTruyen,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.tySoTruyen = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _buildMachDoluongDienNang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleMeter(
          title: 'Dòng điện sơ cấp:',
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'IA',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dongDienSCIA,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dongDienSCIA = value;
                  },
                )),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
                child: TitleMeter(
              title: 'IB',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dongDienSCIB,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dongDienSCIB = value;
                  },
                )),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
                child: TitleMeter(
              title: 'IC',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dongDienSCIC,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dongDienSCIC = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const TitleMeter(
          title: 'Dòng điện thứ cấp:',
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'ia',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dongDienTCIa,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dongDienTCIa = value;
                  },
                )),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
                child: TitleMeter(
              title: 'ib',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dongDienTCIb,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dongDienTCIb = value;
                  },
                )),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
                child: TitleMeter(
              title: 'ic',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dongDienTCIb,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dongDienTCIb = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const TitleMeter(
          title: 'Điện áp sơ cấp:',
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'UA',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dienApSCUA,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dienApSCUA = value;
                  },
                )),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
                child: TitleMeter(
              title: 'UB',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dienApSCUB,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dienApSCUB = value;
                  },
                )),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
                child: TitleMeter(
              title: 'UC',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dienApSCUC,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dienApSCUC = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const TitleMeter(
          title: 'Điện áp thứ cấp:',
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'ua',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dienApTCUa,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dienApTCUa = value;
                  },
                )),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
                child: TitleMeter(
              title: 'ub',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dienApTCUb,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dienApTCUb = value;
                  },
                )),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
                child: TitleMeter(
              title: 'uc',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.dienApTCUc,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.dienApTCUc = value;
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
              title: 'Góc lệch pha:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.gocLechPha,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.gocLechPha = value;
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
              title: 'Thứ tự pha:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.thuTuPha,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.thuTuPha = value;
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
              title: 'Sơ đồ véc tơ:',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.soDoVecTo,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.soDoVecTo = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _buildKetLuanChung() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: TitleMeter(
              title: 'Kết luận',
            )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: _controller.isEnable(),
                  line: 4,
                  isRefresh: _controller.isRefresh.value,
                  value: _controller?.meteDetailModel?.value?.ketLuan,
                  onValueChange: (value) {
                    _controller?.meteDetailModel?.value?.ketLuan = value;
                  },
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _buildKetLuan() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                flex: 2,
                child: TitleMeter(
                  title: 'Công tơ điện',
                )),
            Expanded(
                flex: 3,
                child: DropDownMultiSelectCongTo(
                  key: const Key('congToDienIds'),
                  enable: _controller.isEnable(),
                  isRefresh: _controller.isRefresh.value,
                  values: _controller?.meteDetailModel?.value?.congToDienIds,
                  onChange: (value) {
                    _controller?.meteDetailModel?.value?.congToDienIds = value;
                  },
                  listOption: _controller.listMeasuringCommentMeterElectric,
                  focusNode: congToDienIdsFN,
                  clearFocus: () {
                    _controller.unFocus();
                  },
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .requestFocus(machDoLuongIdsFN);
                  },
                )),
            Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await shoDialogAddMeasuringComment((name) {
                      _controller.addMeterMeasuringComment(
                          _controller.meterElectric, name);
                    });
                  },
                ))
          ],
        ),
        Row(
          children: [
            const Expanded(
                flex: 2,
                child: TitleMeter(
                  title: 'Mạch đo lường',
                )),
            Expanded(
                flex: 3,
                child: DropDownMultiSelectCongTo(
                  enable: _controller.isEnable(),
                  key: const Key('machDoLuongIds'),
                  isRefresh: _controller.isRefresh.value,
                  focusNode: machDoLuongIdsFN,
                  clearFocus: () {
                    _controller.unFocus();
                  },
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .requestFocus(cacYKienKhacIdsFN);
                  },
                  values: _controller?.meteDetailModel?.value?.machDoLuongIds,
                  onChange: (value) {
                    _controller?.meteDetailModel?.value?.machDoLuongIds = value;
                  },
                  listOption: _controller.listMeasuringCommentCircuit,
                )),
            Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await shoDialogAddMeasuringComment((name) {
                      _controller.addMeterMeasuringComment(
                          _controller.meterElectric, name);
                    });
                  },
                ))
          ],
        ),
        Row(
          children: [
            const Expanded(
                flex: 2,
                child: TitleMeter(
                  title: 'Các ý kiến khác',
                )),
            Expanded(
                flex: 3,
                child: DropDownMultiSelectCongTo(
                  enable: _controller.isEnable(),
                  key: const Key('cacYKienKhacIds'),
                  isRefresh: _controller.isRefresh.value,
                  values: _controller?.meteDetailModel?.value?.cacYKienKhacIds,
                  focusNode: cacYKienKhacIdsFN,
                  clearFocus: () {
                    _controller.unFocus();
                  },
                  onEditingComplete: () {
                    _controller.unFocus();
                  },
                  onChange: (value) {
                    _controller?.meteDetailModel?.value?.cacYKienKhacIds =
                        value;
                  },
                  listOption: _controller.listMeasuringCommentAnotherIdea,
                )),
            Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await shoDialogAddMeasuringComment((name) {
                      _controller.addMeterMeasuringComment(
                          _controller.otherComment, name);
                    });
                  },
                ))
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

