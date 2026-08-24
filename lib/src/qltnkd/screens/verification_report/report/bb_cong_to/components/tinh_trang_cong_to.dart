// @dart=2.9
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../dialog/dialog_list_error.dart';
import '../../../../../dialog/popup.dart';
import '../../../../../models/option_model.dart';
import '../bb_cong_to_controller.dart';
import '../common_components/dropdown_meter.dart';
import '../common_components/text_field_meter.dart';
import '../common_components/title_metter.dart';

class TinhTrangCongTo extends StatefulWidget {
  const TinhTrangCongTo({Key key}) : super(key: key);

  @override
  State<TinhTrangCongTo> createState() => _TinhTrangCongToState();
}

class _TinhTrangCongToState extends State<TinhTrangCongTo> with AutomaticKeepAliveClientMixin {
  final _controller = Get.find<BBCongToController>();

  final thietBiKiemFN = FocusNode();
  final dieuKienMoiTruongFN = FocusNode();

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
                  EButton(
                      title: 'Lấy thông tin lỗi',
                      action: () async {
                        await showDialogListError(
                            onSelect: (errors) {
                              _controller.setListError(errors);
                            },
                            ids: _controller.meteDetailModel.value
                                .tinhTrangCongToTruocKiemDinhCode,
                            context: context);
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Tình trạng công tơ trước khi kiểm định',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            line: 5,
                            enable: false,
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value
                                .tinhTrangCongToTruocKiemDinh,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value
                                  .tinhTrangCongToTruocKiemDinh = value;
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
                          flex: 2,
                          child: TitleMeter(
                            title: 'Thiết bị kiểm',
                          )),
                      Expanded(
                          flex: 3,
                          child: CustomDropDownMeter(
                            key: const Key('thietBiKiemModel'),
                            focusNode: thietBiKiemFN,
                            onChange: (value) {
                              _controller.setEquipmentInspection(value);
                              FocusScope.of(context).requestFocus(dieuKienMoiTruongFN);
                            },
                            value: _controller
                                ?.meteDetailModel?.value?.thietBiKiemModel?.id,
                            listOption: _controller?.listEquipmentInspection
                                    ?.map((element) => StringOptionModel(
                                        element.name, element.id))
                                    ?.toList() ??
                                [],
                            isRefresh: _controller.isRefresh.value,
                          )),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            shoDialogAddEquipmentInspection(
                                (equipmentName, number, ccx) async {
                              await _controller.createEquipment(
                                  equipmentName, number, ccx);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Số',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: false,
                            isRefresh: _controller.isRefresh.value,
                            value: _controller?.meteDetailModel?.value
                                ?.thietBiKiemModel?.code,
                            onValueChange: (value) {
                              _controller?.meteDetailModel?.value
                                  ?.thietBiKiemModel?.code = value;
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
                        title: 'Cấp chính xác',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: false,
                            isRefresh: _controller.isRefresh.value,
                            value: _controller
                                ?.meteDetailModel?.value?.thietBiKiemModel?.ccx,
                            onValueChange: (value) {
                              _controller?.meteDetailModel?.value
                                  ?.thietBiKiemModel?.ccx = value;
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
                        title: 'Điều kiện môi trường',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            focusNode: dieuKienMoiTruongFN,
                            value: _controller
                                ?.meteDetailModel?.value?.dieuKienMoiTruong,
                            onValueChange: (value) {
                              _controller?.meteDetailModel?.value
                                  ?.dieuKienMoiTruong = value;
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
                        title: 'Nhiệt độ',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller?.meteDetailModel?.value?.nhietDo,
                            onValueChange: (value) {
                              _controller?.meteDetailModel?.value?.nhietDo =
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
                        title: 'Độ ẩm',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller?.meteDetailModel?.value?.doAm,
                            onValueChange: (value) {
                              _controller?.meteDetailModel?.value?.doAm = value;
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

