// @dart=2.9
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htld/common/components/count_down_view.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/line_general.dart';
import 'package:evnmobile/src/htld/screens/grid_management/choose_line/choose_line_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/choose_line/list_line_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/line_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../app_env.dart';
import '../../../../../../routes.dart';
import '../../../../../app_common/shared/app_shared.dart';
import '../../../../common/components/app_button.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../models/day_night/ticket.dart';
import '../../containers/e_datetime_picker.dart';
import '../../containers/e_label.dart';
import '../../containers/e_text_field.dart';
import 'line_ticket_screen.dart';

mixin MediumGeneralInformationDelegate {
  void onCreateTicketSuccess();
}

class MediumGeneralInformationController extends GetxController {
  final repository = LineTicketRepository();
  final LineTicketController _ticketController = Get.find();
  Rx<LineGeneral> lineGeneral = LineGeneral().obs;
  RxBool loadDataSuccess = false.obs;
  final time = 0.obs;

  MediumGeneralInformationDelegate delegate;

  Future updateInfo() async {
    if (_ticketController.ticketId == null) {
      return;
    }

    Future offline({bool isOffline = true}) async {
      lineGeneral.value.isUpdateOffline = isOffline;
      final result = await LocalDataManager.shared.saveLineGeneral(
          general: lineGeneral.value,
          ticketId: _ticketController.ticketId,
          workId: _ticketController?.argument?.workModel?.workId,
          ticketType: _ticketController.argument.ticketType,
          isOffline: isOffline);

      if (isOffline) {
        if (!result) {
          SnackBarHUD.show(AppStrings.updateOfflineFalse);
          return;
        }

        delegate.onCreateTicketSuccess();
      }
    }

    Future online() async {
      final response = await repository.updateInfo(
          _ticketController.ticketId, lineGeneral.value);
      LocationServiceBackground.shared
          .updateLocationToServer(_ticketController.line.lineId);
      if (response.isLoadSuccess) {
        await offline(isOffline: false);
        delegate.onCreateTicketSuccess();
      } else {
        await showDialogError(response.message);
      }
    }

    final isHandleDataOnline = await _ticketController.isHandleDataOnline();
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      if (isHandleDataOnline) {
        await online();
      } else {
        await offline();
      }
    }
  }

  Future getGeneral() async {
    final isHandleDataOnline = await _ticketController.isHandleDataOnline();
    if (isHandleDataOnline) {
      final response = await repository.getGeneral(_ticketController.ticketId);

      if (response.isLoadSuccess) {
        lineGeneral.value = response.data;
        time.value = lineGeneral.value?.expireRemainingTime ?? 0;
        _ticketController.listLineBranchInfo =
            lineGeneral?.value?.listLineBranchInfo ?? [];
        _ticketController.line = lineGeneral.value;
        _ticketController.isSelectedAllLine = lineGeneral.value.isAll;
      } else {
        await showDialogError(response.message);
      }
    } else {
      final response = await LocalDataManager.shared
          .getLineGeneral(ticketId: _ticketController.ticketId);
      lineGeneral.value = response;
      _ticketController.listLineBranchInfo =
          lineGeneral?.value?.listLineBranchInfo ?? [];
      _ticketController.line = lineGeneral.value;
      _ticketController.isSelectedAllLine = lineGeneral.value.isAll;
    }

    loadDataSuccess.value = true;
    update();
  }

  Future deleteLineBranch(String lineBranchInspect) async {
    final connection = await Connection.shared.checkConnection();

    Future offline({bool isOffline = true}) async {
      await LocalDataManager.shared.removeBranch(
          _ticketController.ticketId,
          lineBranchInspect,
          _ticketController.argument.workModel.workId,
          _ticketController.argument.ticketType,
          isOffline: isOffline);
    }

    if (connection) {
      final response = await repository.deleteLineBranch(
          _ticketController.ticketId, lineBranchInspect);

      if (response.isLoadSuccess) {
        await offline(isOffline: false);
        await getGeneral();
      } else {
        await showDialogError(response.message);
      }
    } else {
      await offline();
      await getGeneral();
    }

    update();
  }
}

class MediumGeneralInformationScreen extends StatefulWidget {
  final Function next;
  const MediumGeneralInformationScreen({this.next});

  @override
  _MediumGeneralInformationScreenState createState() =>
      _MediumGeneralInformationScreenState();
}

class _MediumGeneralInformationScreenState
    extends State<MediumGeneralInformationScreen>
    implements MediumGeneralInformationDelegate {
  final MediumGeneralInformationController _controller =
      MediumGeneralInformationController();

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    Future.delayed(const Duration(milliseconds: 200), _controller.getGeneral);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(child: _renderContent()),
            if (_controller._ticketController.argument.actionType !=
                ActionType.view)
              Container(
                margin: const EdgeInsets.all(16),
                child: EButton(
                  title: 'Lưu và thực hiện kiểm tra',
                  maxSize: true,
                  action: () {
                    if (_controller._ticketController.ticketId != null) {
                      _controller.updateInfo();
                      return;
                    }
                  },
                ),
              ),
          ],
        ),
        floatingActionButton: AppShared.instance.getAppType() != AppType.HTLDHT
            ? Obx(() {
                if (_controller.loadDataSuccess.value != null) {}
                if (_controller._ticketController.argument.actionType ==
                        ActionType.view ||
                    _controller?.lineGeneral?.value?.isAll == true ||
                    _controller?.lineGeneral?.value?.isSingleBranch == true) {
                  return Container();
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: FloatingActionButton(
                    onPressed: () async {
                      final listBranchSelected = _controller
                          ?.lineGeneral?.value?.listLineBranchInfo
                          ?.map((e) => e.lineBranchId)
                          ?.toList();
                      await Get.toNamed(Routes.chooseLine,
                          arguments: BranchArgument(
                              chooseLineEnum: ChooseLineEnum.addNewBranch,
                              listBranchSelected: listBranchSelected));
                      await _controller.getGeneral();
                    },
                    backgroundColor: AppColor.colorOrange,
                    child: const Icon(Icons.add),
                  ),
                );
              })
            : Container(),
      ),
    );
  }

  Widget _renderContent() {
    const _paddingHorizontal = 16.0;
    return SingleChildScrollView(
      child: Obx(() {
        if (_controller.loadDataSuccess.value) {}
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ESectionTitle(
                    AppShared.instance.getAppType() == AppType.HTLDHT
                        ? "Thông tin công trình"
                        : 'Thông tin đường dây'),
              ),
              const SizedBox(
                height: 10,
              ),
              //build code
              if (_controller?.lineGeneral?.value?.code != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Obx(() => ELabel(
                              title:
                                  '${_controller?.lineGeneral?.value?.code == null ? '' : '${AppStrings.workNumber}: ${_controller?.lineGeneral?.value?.code}'}',
                            ))),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              //build time
              Obx(
                () => Stack(
                  children: [
                    if (_controller?.time?.value != null &&
                        _controller?.time?.value != 0)
                      Countdown(
                        duration: Duration(seconds: _controller?.time?.value),
                        onFinish: () {
                          debugPrint('finished!');
                        },
                        builder: (ctx, remaining) {
                          return Center(
                            child: Text(
                                AppShared.instance.getAppType() ==
                                        AppType.HTLDHT
                                    ? 'Hết hạn: ${formatDDHHMMSS(remaining.inSeconds)}'
                                    : 'Hết hạn: ${formatHHMMSS(remaining.inSeconds)}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red)),
                          );
                        },
                      )
                    else
                      Container()
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              ELabel(
                title: AppShared.instance.getAppType() == AppType.HTLDHT
                    ? 'Thông tin công trình/nút'
                    : 'Thông tin đường dây/nhánh đường dây',
                padding: EdgeInsets.symmetric(horizontal: _paddingHorizontal),
              ),
              if (AppShared.instance.getAppType() == AppType.HTLDHT &&
                  _controller._ticketController.argument.ticketType ==
                      TicketType.incidentDay)
                ETextField(
                  title: 'Loại kiểm tra',
                  value: _controller.lineGeneral.value.isNight
                      ? "Kiểm tra sự cố đêm"
                      : "Kiểm tra sự cố ngày",
                  weight: FontWeight.bold,
                  enable: false,
                ),

              ETextField(
                title: 'Chu kỳ kiểm tra',
                value: _controller._ticketController.argument.ticketType.title
                        .capitalizeFirst ??
                    '',
                weight: FontWeight.bold,
                enable: false,
              ),
              ETextField(
                title: AppShared.instance.getAppType() == AppType.HTLDHT
                    ? 'Công trình'
                    : 'Đường dây',
                value: _controller.lineGeneral.value.lineName,
                weight: FontWeight.bold,
                enable: false,
              ),
              ETextField(
                title: 'Kiểu kiểm tra',
                value: _controller.lineGeneral.value.isAll
                    ? 'Cả đường dây'
                    : AppShared.instance.getAppType() == AppType.HTLDHT
                        ? 'Theo nút'
                        : 'Theo nhánh',
                weight: FontWeight.bold,
                enable: false,
              ),
              if (AppShared.instance.getAppType() != AppType.HTLDHT)
                ELabel(
                  title: AppShared.instance.getAppType() == AppType.HTLDHT
                      ? 'Danh sách nút công trình'
                      : 'Danh sách nhánh đường dây',
                  padding: EdgeInsets.symmetric(horizontal: _paddingHorizontal),
                ),
              if (AppShared.instance.getAppType() != AppType.HTLDHT)
                Column(
                    children: _controller
                            ?.lineGeneral?.value?.listLineBranchInfo
                            ?.map(_renderMenu)
                            ?.toList() ??
                        List<Widget>.empty()),

              if (AppShared.instance.getAppType() != AppType.HTLDHT)
                ETextField(
                    title: 'Kết cấu lưới điện được kiểm tra',
                    weight: FontWeight.bold,
                    enable: false,
                    value: _controller.lineGeneral?.value?.structureName ?? ''),

              if (AppShared.instance.getAppType() != AppType.HTLDHT)
                ETextField(
                  title: 'Sở hữu',
                  value: _controller.lineGeneral?.value?.owned ?? '',
                  weight: FontWeight.bold,
                  enable: false,
                ),

              if (AppShared.instance.getAppType() != AppType.HTLDHT)
                ETextField(
                  title: 'Nhiệt độ 1',
                  enable: _controller._ticketController.argument.isEdit(),
                  value: _controller.lineGeneral?.value?.temperature ?? '',
                  weight: FontWeight.bold,
                  onChange: (value) {
                    _controller.lineGeneral?.value?.temperature = value;
                  },
                ),

              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const SizedBox.shrink()
              else
                ETextField(
                    title: 'Thời tiết 1',
                    enable: _controller._ticketController.argument.isEdit(),
                    value: _controller.lineGeneral?.value?.weather ?? '',
                    weight: FontWeight.bold,
                    onChange: (value) {
                      _controller.lineGeneral?.value?.weather = value;
                    }),

              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const SizedBox.shrink()
              else
                ETextField(
                  title: 'Nhiệt độ 2',
                  //enable: !(_controller.lineGeneral.value.isGroupOne ?? true),
                  enable: false,
                  value: _controller.lineGeneral?.value?.temperature2 ?? '',
                  weight: FontWeight.bold,
                  onChange: (value) {
                    _controller.lineGeneral?.value?.temperature2 = value;
                  },
                ),

              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const SizedBox.shrink()
              else
                ETextField(
                    title: 'Thời tiết 2',
                    //enable: !(_controller.lineGeneral.value.isGroupOne ?? true),
                    enable: false,
                    value: _controller.lineGeneral?.value?.weather2 ?? '',
                    weight: FontWeight.bold,
                    onChange: (value) {
                      _controller.lineGeneral?.value?.weather2 = value;
                    }),

              if (AppShared.instance.getAppType() != AppType.HTLDHT)
                ETextField(
                  title: 'Yêu cầu định kỳ kiểm tra',
                  weight: FontWeight.bold,
                  enable: false,
                  value: _controller._ticketController?.argument?.fre ??
                      _controller.lineGeneral.value.inspectionRequest ??
                      '',
                ),
              EDateTimePicker(
                enable: false,
                title: AppShared.instance.getAppType() == AppType.HTLDHT
                    ? 'Tạo phiếu'
                    : 'Ngày, giờ kiểm tra',
                currentDate: _controller.lineGeneral?.value?.inspectTime
                    ?.fromFormatToFormat(
                        AppStrings.utcFormatNotZ, AppStrings.ddmmyyyyHHmm),
                weight: FontWeight.bold,
                horizontalPadding: _paddingHorizontal,
                dateSelected: (newDate) {},
              ),
              EDateTimePicker(
                enable: false,
                title: AppShared.instance.getAppType() == AppType.HTLDHT
                    ? 'Kỳ kiểm tra gần nhất'
                    : 'Thời gian kiểm tra gần nhất',
                currentDate: _controller.lineGeneral?.value?.lastInspection
                    ?.fromFormatToFormat(
                        AppStrings.utcFormatNotZ, AppStrings.ddmmyyyyHHmm),
                weight: FontWeight.bold,
                horizontalPadding: _paddingHorizontal,
                dateSelected: (newDate) {},
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _renderMenu(LineBranchInfo info) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 8),
      child: ListTileTheme(
        tileColor: Colors.grey.shade100,
        child: ExpansionTile(
          key: GlobalKey(),
          initiallyExpanded: false,
          childrenPadding: const EdgeInsets.only(bottom: 10),
          title: _renderHeaderTitle(info?.lineBranchName ?? ''),
          children: [_renderMenuItem(info)],
        ),
      ),
    );
  }

  Widget _renderHeaderTitle(String title) {
    const _headerTitleStyle = TextStyle(
        fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black);
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: _headerTitleStyle,
      ),
    );
  }

  @override
  void onCreateTicketSuccess() {
    widget.next();
  }

  Widget _renderMenuItem(LineBranchInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: Text(
            'Đoạn đường dây kiểm tra',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (AppShared.instance.getAppType() != AppType.HTLDHT)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ETextArea(
                  title: 'Thông tin nhánh cha',
                  minLine: 1,
                  enable: false,
                  value: info.getParentsName(),
                  weight: FontWeight.w500,
                ),
              ),
            if (AppShared.instance.getAppType() != AppType.HTLDHT)
              ETextField(
                  title: 'Từ vị trí',
                  enable: false,
                  value: info.startNode,
                  weight: FontWeight.w500,
                  titlePadding: const EdgeInsets.symmetric(horizontal: 16)),
            if (AppShared.instance.getAppType() != AppType.HTLDHT)
              ETextField(
                  title: 'Đến',
                  enable: false,
                  value: info.endNode,
                  weight: FontWeight.w500,
                  titlePadding: const EdgeInsets.symmetric(horizontal: 16)),
            ETextField(
                title: 'Thuộc xuất tuyến',
                enable: false,
                value: info.outOfLine,
                weight: FontWeight.w500,
                titlePadding: const EdgeInsets.symmetric(horizontal: 16)),
            const SizedBox(
              height: 16,
            ),
            if (_controller._ticketController.argument.actionType !=
                    ActionType.view &&
                _controller?.lineGeneral?.value?.isAll == false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: EButton(
                      title: 'Xoá',
                      action: () {
                        if (_controller
                                .lineGeneral.value.listLineBranchInfo.length ==
                            1) {
                          showDialogOneButton(
                              'Bạn không thể xóa nhánh đường dây này.');
                        } else {
                          showMyDialogOkCancel(
                              'Bạn chắc chắn muốn xóa nhánh này không?',
                              secondFunction: () {
                            _controller.deleteLineBranch(info.id);
                          });
                        }
                      },
                      color: AppColor.colorOrange,
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: EButton(
                      title: 'Sửa',
                      action: () async {
                        await Get.toNamed(Routes.chooseLine,
                            arguments: BranchArgument(
                                chooseLineEnum: ChooseLineEnum.editBranch,
                                lineBranchInfo: info));
                        await _controller.getGeneral();
                      },
                      color: AppColor.highlightColor70,
                    )),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }
}

