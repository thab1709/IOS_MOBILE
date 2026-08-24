// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_text_field.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/tabs/result/result_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/medium_conclude_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../app_env.dart';
import '../../../../../../routes.dart';
import '../../../../common/components/app_button.dart';

import '../../../../common/utils/alert_dialog_utils.dart';
import '../../containers/e_label.dart';
import '../../containers/e_single_datetime_picker.dart';
import '../../containers/e_single_text_area.dart';

class MediumConcludeHTScreen extends StatefulWidget {
  @override
  _MediumConcludeHTScreenState createState() => _MediumConcludeHTScreenState();
}

class _MediumConcludeHTScreenState extends State<MediumConcludeHTScreen>
    implements ResultDelegate {
  final MediumConcludeController _controller = MediumConcludeController();
  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    Future.delayed(const Duration(milliseconds: 100), _controller.getResult);
  }

  var forceMajeure = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Dừng kiểm tra bất khả kháng",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Checkbox(
                            value: forceMajeure,
                            onChanged: (value) {
                              setState(() {
                                forceMajeure = value;
                              });
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const ESectionTitle('Nhận xét'),
                    const SizedBox(
                      height: 10,
                    ),
                    if (AppShared.instance.getAppType() != AppType.HTLDHT)
                      _renderTimeProblem(
                          'Thời gian dự kiến giải quyết các tồn tại'),
                    const SizedBox(height: 16),
                    if (AppShared.instance.getAppType() == AppType.HTLDHT)
                      _renderTimeUpdate(
                          'Ngày cập nhật thông tin và hồ sơ quản lý công trình')
                    else
                      _renderTimeUpdate(
                          'Ngày cập nhật thông tin và hồ sơ quản lý đường dây'),
                    const SizedBox(height: 16),
                    Obx(
                      () => _renderTextSection(
                          'Ngày hiệu chỉnh thông tin kiểm tra', 2,
                          isEnable: false,
                          defaultText: _controller.dateConfig.value),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (_controller.ticketController.argument.actionType !=
                ActionType.view)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (AppShared.instance.getAppType() != AppType.HTLDHT)
                    Expanded(
                        child: EButton(
                      title: 'Lưu',
                      maxSize: true,
                      action: () {
                        _controller.saveResult();
                      },
                    )),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  Expanded(
                    child: EButton(
                      title: 'Hoàn thành',
                      maxSize: true,
                      action: () {
                        showMyDialogOkCancel(
                            'Công việc sau khi hoàn thành không thể sửa. Bạn có chắc muốn hoàn thành không?',
                            secondFunction: () {
                          _controller.completeTicketHT(isForceMajeure: forceMajeure);
                        });
                      },
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  // - Time Section
  Widget _renderTimeProblem(String title) {
    const _paddingHorizontal = 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ELabel(
          title: title,
          padding: const EdgeInsets.symmetric(vertical: _paddingHorizontal),
        ),
        Obx(
          () => ESingleDateTimePicker(
              currentDate: _controller.date.value,
              enable: _controller.ticketController.argument.isEdit(),
              dateSelected: (newDate) {
                setState(() {
                  _controller.date.value = newDate;
                });
              }),
        )
      ],
    );
  }

  Widget _renderTimeUpdate(String title) {
    const _paddingHorizontal = 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ELabel(
          title: title,
          padding: const EdgeInsets.symmetric(vertical: _paddingHorizontal),
        ),
        Obx(() => ESingleTextField(
              value: _controller?.resultModel?.value?.updateInformationAt ?? '',
              isEnable: false,
            ))
      ],
    );
  }

  // - Text Section
  Widget _renderTextSection(String title, int section,
      {String defaultText, bool isEnable}) {
    const _paddingHorizontal = 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ELabel(
          title: title,
          padding: const EdgeInsets.symmetric(vertical: _paddingHorizontal),
        ),
        ESingleTextArea(
          value: defaultText,
          isEnable: isEnable,
        ),
      ],
    );
  }

  @override
  void saveCompleted() {
    showMyDialogOkCancel(
        'Cập nhật thành công!\nBạn có muốn tiếp tục hoàn thành không?',
        firstTitle: 'Quay lại', firstAction: () {
      completeTicket();
    }, secondTitle: 'Tiếp tục');
  }

  @override
  void completeTicket() {
    backToRoot();
  }

  void backToRoot() {
    Get.until((route) => [
          Routes.periodicInspectionPlanView,
          Routes.historyCheck,
          Routes.home
        ].contains(route.settings.name));
  }
}

