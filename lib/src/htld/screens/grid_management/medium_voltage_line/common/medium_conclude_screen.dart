// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/result_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_text_field.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/tabs/result/result_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/ticket_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../app_env.dart';
import '../../../../../../routes.dart';
import '../../../../common/components/app_button.dart';
import '../../../../common/extension/extension.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../containers/e_label.dart';
import '../../containers/e_single_datetime_picker.dart';
import '../../containers/e_single_text_area.dart';

class MediumConcludeController extends GetxController {
  final repository = TicketRepository();

  final LineTicketController ticketController = Get.find();

  final resultModel = LineResultModel().obs;
  final date = DateTime.now().add(const Duration(days: 1)).obs;

  final dateConfig = ''.obs;

  ResultDelegate delegate;

  Future<void> saveResult() async {
    final time =
        date.value.toStringFormat(AppStrings.utcFormatNotZ, isUtc: true);
    resultModel.value.settlementTime = time;
    Future offline({bool isOffline = true}) async {
      final result = await LocalDataManager.shared.updateLineResultOffline(
          time,
          ticketController.ticketId,
          ticketController?.argument?.workModel?.workId,
          ticketController.argument.ticketType,
          isOffline: isOffline);

      if (isOffline) {
        if (!result) {
          SnackBarHUD.show(AppStrings.updateOfflineFalse);
          return;
        }

        SnackBarHUD.show('Cập nhật offline thành công');
      }
    }

    Future online() async {
      final isLocationGranted = await checkLocationPermission();
      if (isLocationGranted) {
        final response = await repository.saveLineResult(
            resultModel.value, ticketController.ticketId);
        LocationServiceBackground.shared
            .updateLocationToServer(ticketController.line.lineId);
        if (response.isLoadSuccess) {
          await offline(isOffline: false);
          delegate.saveCompleted();
        } else {
          await showDialogError(response.message);
        }
      }
    }

    final isHandleDataOnline = await ticketController.isHandleDataOnline();
    if (isHandleDataOnline) {
      await online();
    } else {
      await offline();
    }
  }

  Future<void> completeTicket() async {
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      final response =
          await repository.completeLineTicket(ticketController.ticketId);
      LocationServiceBackground.shared
          .updateLocationToServer(ticketController.line.lineId);
      if (response.isLoadSuccess) {
        SnackBarHUD.show('Hoàn thành công việc kiểm tra thành công');

        Future.delayed(const Duration(milliseconds: 200), () {
          delegate.completeTicket();
        });
      } else {
        await showDialogError(response.message);
      }
    }
  }

  Future<void> completeTicketHT({bool isForceMajeure}) async {
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      final response = await repository.completeLineTicketHT(
          ticketController.ticketId, isForceMajeure);
      LocationServiceBackground.shared
          .updateLocationToServer(ticketController.line.lineId);
      if (response.isLoadSuccess) {
        SnackBarHUD.show('Hoàn thành công việc kiểm tra thành công');

        Future.delayed(const Duration(milliseconds: 200), () {
          delegate.completeTicket();
        });
      } else {
        await showDialogError(response.message);
      }
    }
  }

  Future<void> getResult() async {
    if (ticketController.ticketId == null) {
      return;
    }

    final isHandleDataOnline = await ticketController.isHandleDataOnline();
    final userProfile = AppShared.instance.getUserProfile();

    if (isHandleDataOnline) {
      final response = await repository.getLineResult(
        ticketController.ticketId,
      );

      if (response.isLoadSuccess) {
        resultModel.value = response.data.resultModel;
        final userProfile = AppShared.instance.getUserProfile();

        if (resultModel.value.settlementTime == null) {
          date.value = DateTime.now().add(const Duration(days: 1));
        } else {
          date.value = resultModel.value.settlementTime.toDateFormatLocal();
        }

        if (resultModel.value.updateDate != null) {
          dateConfig.value =
              '${resultModel.value.updateBy} - ${resultModel.value.updateDate.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm)}';
        } else {
          dateConfig.value =
              '${userProfile.name} - ${DateTime.now().toStringFormat(AppStrings.ddmmyyyyHHmm)}';
        }
        update();
      } else {
        await showDialogError(response.message);
      }
    } else {
      final result =
          await LocalDataManager.shared.getResult(ticketController.ticketId);
      if (result != null) {
        resultModel.value = LineResultModel.fromJson(result);
      } else {
        resultModel.value = LineResultModel();
      }

      if (resultModel?.value?.settlementTime == null) {
        date.value = DateTime.now().add(const Duration(days: 1));
      } else {
        date.value = resultModel.value.settlementTime.toDateFormatLocal();
      }

      if (resultModel?.value?.updateInformationAt != null) {
        resultModel.value.updateInformationAt = resultModel
            .value.updateInformationAt
            .fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm);
      }

      if (resultModel.value.updateDate != null) {
        dateConfig.value =
            '${resultModel.value.updateBy} - ${resultModel.value.updateDate.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm)}';
      } else if (UserRole.hasPermissionCreate()) {
        dateConfig.value =
            '${userProfile.name} - ${DateTime.now().toStringFormat(AppStrings.ddmmyyyyHHmm)}';
      }
      update();
    }
  }
}

class MediumConcludeScreen extends StatefulWidget {
  @override
  _MediumConcludeScreenState createState() => _MediumConcludeScreenState();
}

class _MediumConcludeScreenState extends State<MediumConcludeScreen>
    implements ResultDelegate {
  final MediumConcludeController _controller = MediumConcludeController();
  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    Future.delayed(const Duration(milliseconds: 100), _controller.getResult);
  }

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
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: EButton(
                      title: 'Hoàn thành',
                      maxSize: true,
                      action: () {
                        showMyDialogOkCancel(
                            'Công việc sau khi hoàn thành không thể sửa. Bạn có chắc muốn hoàn thành không?',
                            secondFunction: () {
                          _controller.completeTicket();
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

