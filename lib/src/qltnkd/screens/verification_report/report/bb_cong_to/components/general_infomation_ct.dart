// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import '../../../../../common/constance/strings.dart';
import '../bb_cong_to_controller.dart';
import '../common_components/text_field_meter.dart';
import '../common_components/title_metter.dart';

class GeneralInformationCT extends StatefulWidget {
  const GeneralInformationCT({Key key}) : super(key: key);

  @override
  State<GeneralInformationCT> createState() => _GeneralInformationCTState();
}

class _GeneralInformationCTState extends State<GeneralInformationCT> with AutomaticKeepAliveClientMixin {
  final _controller = Get.find<BBCongToController>();



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
                  _buildListRadio(context),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Mã KH:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: false,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.maKH = value;
                            },
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.maKH,
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Số công tơ:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: false,
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.soCongTo,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.soCongTo = value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Tên KH:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.tenKH,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.tenKH = value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Địa chỉ:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.diaChi,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.diaChi = value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Nước SX:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.nuocSanXuat,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.nuocSanXuat =
                                  value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'K:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.k,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.k = value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Loại:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.loai,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.loai = value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Dòng điện:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.dongDien,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.dongDien = value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Điện áp:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value: _controller.meteDetailModel.value.dienAp,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.dienAp = value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Cấp chính xác P:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value:
                                _controller.meteDetailModel.value.capChinhXacP,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.capChinhXacP =
                                  value;
                            },
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: TitleMeter(
                        title: 'Cấp chính xác Q:',
                      )),
                      Expanded(
                          flex: 2,
                          child: CustomTextFieldMeter(
                            enable: _controller.isEnable(),
                            isRefresh: _controller.isRefresh.value,
                            value:
                                _controller.meteDetailModel.value.capChinhXacQ,
                            onValueChange: (value) {
                              _controller.meteDetailModel.value.capChinhXacQ =
                                  value;
                            },
                          ))
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildListRadio(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleMeter(
          title: 'Địa điểm',
          isRequire: true,
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: _buildRadioButton(
                isEnable: _controller.isEnable(),
                value: int.parse(_controller.optionsPlace[0].value),
                groupValue: _controller.groupValuePlace,
                title: 'Công tơ ngoài hiên trường',
                onChange: (val) {
                  _controller.groupValuePlace = val;
                },
              ),
            ),
            Expanded(
              child: _buildRadioButton(
                isEnable: _controller.isEnable(),
                value: int.parse(_controller.optionsPlace[1].value),
                groupValue: _controller.groupValuePlace,
                title: 'Công tơ tại phòng',
                onChange: (val) {
                  _controller.groupValuePlace = val;
                },
              ),
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
                  title: 'Ngày kiểm tra',
                  isRequire: true,
                )),
            Expanded(
                flex: 2,
                child: CustomTextFieldMeter(
                  enable: false,
                  isRefresh: _controller.isRefresh.value,
                  focusNode: _controller.focusNode,
                  value:
                  _controller?.meteDetailModel?.value?.dateInFormReport?.fromFormatUtcToFormatLocal(RAppStrings.ddMMyyyy),
                  icon: const Icon(Icons.date_range),
                  onIconTaped: _controller.isEnable() ? () {
                    _controller.unFocus();

                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        locale: LocaleType.vi,
                        currentTime: _controller.meteDetailModel.value.dateInFormReport.toDateFormatLocal() ?? DateTime.now(),
                        onConfirm: (date){
                          _controller.setDateReport(date);
                        });
                  } : null,
                  onValueChange: (value) {
                    _controller.meteDetailModel.value.dateInFormReport =
                        value;
                  },
                ))
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const TitleMeter(
          title: 'Loại lỗi',
          isRequire: true,
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: _buildRadioButton(
                isEnable: _controller.isEnable(),
                value: _controller.byRequire,
                groupValue: _controller.groupErrorType,
                title: 'Theo yêu cầu',
                onChange: (val) {
                  _controller.groupErrorType = val;
                },
              ),
            ),
            Expanded(
              child: _buildRadioButton(
                isEnable: _controller.isEnable(),
                value: _controller.customerQA,
                groupValue: _controller.groupErrorType,
                title: 'KH thắc mắc',
                onChange: (val) {
                  _controller.groupErrorType = val;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildRadioButton(
                isEnable: _controller.isEnable(),
                value: _controller.meterError,
                groupValue: _controller.groupErrorType,
                title: 'Lỗi công tơ',
                onChange: (val) {
                  _controller.groupErrorType = val;
                },
              ),
            ),
            Expanded(
              child: _buildRadioButton(
                isEnable: _controller.isEnable(),
                value: _controller.errorViolate,
                groupValue: _controller.groupErrorType,
                title: 'Lỗi vi phạm',
                onChange: (val) {
                  _controller.groupErrorType = val;
                },
              ),
            ),
          ],
        ),
        if (_controller.reportType.value != _controller.type1)
       Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const SizedBox(
             height: 16,
           ),
           const TitleMeter(
             title: 'Loại pha',
             isRequire: true,
           ),
           const SizedBox(height: 10,),
           Row(
             children: [
               Expanded(
                 child: _buildRadioButton(
                   isEnable: _controller.isEnable(),
                   value: _controller.phase1FC,
                   groupValue: _controller.groupValuePhase,
                   title: '1FC',
                   onChange: (val) {
                     _controller.groupValuePhase = val;
                   },
                 ),
               ),
               Expanded(
                 child: _buildRadioButton(
                   isEnable: _controller.isEnable(),
                   value: _controller.phase1F1G,
                   groupValue: _controller.groupValuePhase,
                   title: '1F1G',
                   onChange: (val) {
                     _controller.groupValuePhase = val;
                   },
                 ),
               ),
               Expanded(
                 child: _buildRadioButton(
                   isEnable: _controller.isEnable(),
                   value: _controller.phase1F3G,
                   groupValue: _controller.groupValuePhase,
                   title: '1F3G',
                   onChange: (val) {
                     _controller.groupValuePhase = val;
                   },
                 ),
               ),
             ],
           ),
           Row(
             children: [
               Expanded(
                 child: _buildRadioButton(
                   isEnable: _controller.isEnable(),
                   value: _controller.phase3FC,
                   groupValue: _controller.groupValuePhase,
                   title: '3FC',
                   onChange: (val) {
                     _controller.groupValuePhase = val;
                   },
                 ),
               ),
               Expanded(
                 child: _buildRadioButton(
                   isEnable: _controller.isEnable(),
                   value: _controller.phase3F1G,
                   groupValue: _controller.groupValuePhase,
                   title: '3F1G',
                   onChange: (val) {
                     _controller.groupValuePhase = val;
                   },
                 ),
               ),
               Expanded(
                 child: _buildRadioButton(
                   isEnable: _controller.isEnable(),
                   value: _controller.phase3F3GTT,
                   groupValue: _controller.groupValuePhase,
                   title: '3F3GTT',
                   onChange: (val) {
                     _controller.groupValuePhase = val;
                   },
                 ),
               ),
             ],
           ),
           Row(
             children: [
               Expanded(
                 child: _buildRadioButton(
                   isEnable: _controller.isEnable(),
                   value: _controller.phase3F3GGT,
                   groupValue: _controller.groupValuePhase,
                   title: '3F3GGT',
                   onChange: (val) {
                     _controller.groupValuePhase = val;
                   },
                 ),
               ),
             ],
           ),
         ],
       )
      ],
    );
  }

  Widget _buildRadioButton(
      {@required int value,
      @required int groupValue,
      @required String title,
      @required bool isEnable,
      @required Function(int) onChange}) {
    return RadioListTile(
      value: value,
      title: Text(title),
      groupValue: groupValue,
      onChanged: isEnable ? onChange : null,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

