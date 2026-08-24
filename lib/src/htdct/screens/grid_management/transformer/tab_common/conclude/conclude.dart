// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../../../../app_common/utils/utils.dart';
import '../../../containers/e_text_form_field.dart';
import 'conclude_controller.dart';

class ConcludeScreen extends StatefulWidget {
  const ConcludeScreen();

  @override
  State<ConcludeScreen> createState() => _ConcludeScreenState();
}

class _ConcludeScreenState extends State<ConcludeScreen>
    with AutomaticKeepAliveClientMixin {
  final ConcludeController _controller = ConcludeController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 200), () async {
        await _controller.getResult();
      });
    });

    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible) {
        _controller.refreshView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: HighElectricAppColor.bgColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: HighElectricAppColor.nature01),
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin nhận xét',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: HighElectricAppColor.nature06,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ETextFormField(
                    value: _controller.result.value.substationSituation ?? '',
                    readOnly: !_controller.transformerTicketController
                        .isHasPermissionEdit(),
                    title:
                        'Tình hình ${_controller.transformerTicketController.testType == TestType.subStation ? 'trạm' : 'đường dây'}',
                    hint: 'Nhập thông tin',
                    onChangeInput: (value) {
                      _controller.result.value.substationSituation = value;
                    },
                    invalid: _controller.invalid.value,
                    isRequied: _controller.result.value.isAbnormal == true,
                    isMultiLine: !_controller.result.value.voltageCabinetsResult
                        .isNullOrEmpty(),
                  ),
                  ETextFormField(
                    value: _controller.result.value.solution ?? '',
                    readOnly: !_controller.transformerTicketController
                        .isHasPermissionEdit(),
                    title: 'Biện pháp đề nghị giải quyết các tồn tại',
                    hint: 'Nhập thông tin',
                    onChangeInput: (value) {
                      _controller.result.value.solution = value;
                    },
                    invalid: _controller.invalid.value,
                    isRequied: _controller.result.value.isAbnormal == true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  buildTitle(
                      title: 'Thời gian giải quyết các tồn tại',
                      required: _controller.result.value.isAbnormal == true),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (_controller.transformerTicketController
                            .isHasPermissionEdit()) {
                          _showDatePicker();
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: (_controller.invalid.value == true &&
                                          _controller.result.value.isAbnormal ==
                                              true &&
                                          _controller.result.value.dueDate
                                              .isNullOrEmpty())
                                      ? Colors.red
                                      : Colors.grey.shade300)),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller.timeController,
                                  decoration: const InputDecoration(
                                    enabled: false,
                                    border: InputBorder.none,
                                    hintText: 'Chọn khoảng thời gian',
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: HighElectricAppColor.nature05,
                                  size: 20,
                                ),
                              ),
                            ],
                          ))),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Ngày hiệu chỉnh thông tin kiểm tra ',
                    style: TextStyle(
                        color: HighElectricAppColor.nature05,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: HighElectricAppColor.nature03,
                          border: Border.all(
                              width: 1, color: Colors.grey.shade300)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller.timeController2.value,
                              decoration: const InputDecoration(
                                enabled: false,
                                border: InputBorder.none,
                                hintText: 'Chọn khoảng thời gian',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.calendar_today,
                              color: HighElectricAppColor.nature05,
                              size: 20,
                            ),
                          ),
                        ],
                      )),
                  Obx(() {
                    if (_controller?.result?.value?.sign != null && _controller.result.value.sign.isNotEmpty) {
                      return Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40,),
                              const Text('Người ký số', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                              const SizedBox(height: 10,),
                              imageFromBase64String(_controller.result.value.sign),
                              const SizedBox(height: 5,),
                              Text(_controller?.result?.value?.userComplete ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  })
                ],
              )),
        ),
      ),
      bottomNavigationBar: _buildAction(),
    );
  }

  Widget _buildAction() {
    if (_controller.transformerTicketController.isHasPermissionEdit()) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: HighElectricAppColor.nature01,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                _controller.postResult();
              },
              child: EButtonWidget(
                width: MediaQuery.of(context).size.width / 2.3,
                text: 'Lưu',
                bgColor: Colors.white,
                textColor: HighElectricAppColor.primary10,
              ),
            ),
            Obx(
              () {
                if (_controller.invalid.value) {}
                return InkWell(
                    onTap: () async {
                      if (_controller.isEnableFinishBtn()) {
                        await _controller.completeTicket();
                      }
                    },
                    child: EButtonWidget(
                      width: MediaQuery.of(context).size.width / 2.3,
                      text: 'Hoàn Thành',
                      bgColor: _controller.isEnableFinishBtn()
                          ? HighElectricAppColor.primary10
                          : HighElectricAppColor.backgroundColorGray,
                      textColor: _controller.isEnableFinishBtn()
                          ? Colors.white
                          : Colors.black,
                    ));
              },
            )
          ],
        ),
      );
    } else {
      return null;
    }
  }

  void _showDatePicker() {
    if (_controller.transformerTicketController.isHasPermissionEdit()) {
      DatePicker.showDatePicker(context,
          showTitleActions: true,
          minTime: DateTime(DateTime.now().year - 5, 1, 1),
          maxTime: DateTime(DateTime.now().year + 5, 1, 1),
          onChanged: (date) {}, onConfirm: (date) {
        _controller.timeController.text =
            date.toStringFormat(HighElectricStrings.ddMMyyyy);
        _controller.result.value.dueDate =
            date.toStringFormat(HighElectricStrings.utcFormatNotZ, isUtc: true);
        _controller.refreshView();
      },
          currentTime:
              _controller?.timeController?.text?.toDate() ?? DateTime.now(),
          locale: LocaleType.vi);
    }
  }

  Widget buildTitle({String title, bool required}) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                color: HighElectricAppColor.nature05,
                fontWeight: FontWeight.w400,
                fontSize: 16)),
        if (required)
          const Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive =>
      !_controller.transformerTicketController.isHasPermissionEdit();
}

