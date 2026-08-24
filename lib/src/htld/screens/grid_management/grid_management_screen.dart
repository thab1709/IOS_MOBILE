// @dart=2.9
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/image_path.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket_of_manager/ticket_of_manager.dart';
import 'package:evnmobile/src/htld/services/offline_service/sync_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../routes.dart';
import '../../common/extension/extension.dart';
import '../../common/themes/colorx.dart';
import '../../models/day_night/ticket.dart';
import 'grid_management_controller.dart';
import 'medium_voltage_line/common/line_ticket_screen.dart';

class GridManagementScreen extends StatelessWidget {
  final _headerTitleStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: AppColor.highlightColor);
  final GridManagementController _controller =
      Get.put(GridManagementController());
  @override
  Widget build(BuildContext context) {
    final appType = AppShared.instance.getAppType();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Container(
            alignment: Alignment.centerLeft,
            child:
                Image.asset(ImagePath.logoEVN, fit: BoxFit.contain, height: 40),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                final hasInternet = await Connection.shared.checkConnection();

                if (hasInternet) {
                  await EasyLoading.show(
                      status:
                          'Đang đồng bộ công việc xuống, sẽ mất một khoảng thời gian. Vui lòng chờ...',
                      maskType: EasyLoadingMaskType.custom);

                  final result = await SyncManager.shared.syncDown();
                  if (!result) {
                    await EasyLoading.dismiss(animation: true);
                  }
                  Future.delayed(const Duration(seconds: 5), () async {
                    await EasyLoading.showSuccess('Đồng bộ xuống thành công');
                  });
                } else {
                  await showDialogError('Vui lòng kiểm tra kết nối Internet');
                }
              },
              child: Container(
                  color: Colors.white.withAlpha(0),
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  child: const Icon(
                    Icons.download_rounded,
                    color: Colors.black,
                  )),
            ),
            GestureDetector(
              onTap: () async {
                final hasInternet = await Connection.shared.checkConnection();

                if (hasInternet) {
                  await EasyLoading.show(
                      status:
                          'Đang đồng bộ công việc lên, sẽ mất một khoảng thời gian. Vui lòng chờ...',
                      maskType: EasyLoadingMaskType.custom);
                  await SyncManager.shared.syncUp();
                  Future.delayed(const Duration(seconds: 5), () async {
                    await EasyLoading.showSuccess('Đồng bộ lên thành công');
                  });
                } else {
                  await showDialogError('Vui lòng kiểm tra kết nối Internet');
                }
              },
              child: Container(
                  color: Colors.white.withAlpha(0),
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  child: const Icon(
                    Icons.upload_rounded,
                    color: Colors.black,
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                if (appType != AppType.HTLDHT)
                  _renderMenu(SubStationType.distribution)
                else
                  const SizedBox.shrink(),
                if (appType != AppType.HTLDHT)
                  _renderMenu(SubStationType.intermediate)
                else
                  const SizedBox.shrink(),
                if (appType == AppType.HTLDHT)
                  _renderMenu(SubStationType.lowVoltage)
                else
                  _renderMenu(SubStationType.mediumVoltage),
              ],
            ),
          ),
        ));
  }

  Widget _renderHeaderTitle(String title) {
    return Row(
      children: [
        Container(
          height: 50,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: _headerTitleStyle,
          ),
        ),
      ],
    );
  }

  Widget _renderMenu(SubStationType type) {
    return ListTileTheme(
      tileColor: Colors.grey.shade100,
      child: ExpansionTile(
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.only(bottom: 10),
        title: _renderHeaderTitle(type.title),
        children: type.tickets
            .mapIndexed((ticketType, i) => _renderMenuItem(type, ticketType))
            .toList(),
      ),
    );
  }

  Widget _renderMenuItem(SubStationType subStationType, TicketType ticketType) {
    return InkWell(
      onTap: () {
        _handleMenuTap(subStationType, ticketType);
      },
      child: ListTileTheme(
        tileColor: Colors.white,
        child: ListTile(
          trailing: UserRole.hasPermissionCreate()
              ? IconButton(
                  icon: Icon(
                    (ticketType == TicketType.periodicDay ||
                            ticketType == TicketType.periodicNight)
                        ? Icons.calendar_today_outlined
                        : Icons.add_circle_outline_outlined,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    _controller.setTicketType(subStationType, ticketType);
                    // NOTE(hau): khi click vào 1 menu
                    final argument = TicketScreenArgument(
                        ticketType: ticketType,
                        subStationType: subStationType,
                        actionType: ActionType.create);
                    final user = AppShared.instance.getUserProfile();
                    if (user.username == 'managerquocoai@gmail.com') {
                      await Get.to(() => TicketOfManagerScreen(),
                          arguments: argument);
                    } else {
                      if (ticketType == TicketType.periodicDay ||
                          ticketType == TicketType.periodicNight) {
                        debugPrint('haudau123 periodicDay or periodicNight');
                        await Get.toNamed(Routes.periodicInspectionPlanView,
                            arguments: argument);
                      } else {
                        debugPrint('haudau123 else ${subStationType.title}');
                        if (subStationType == SubStationType.mediumVoltage ||
                            subStationType == SubStationType.lowVoltage) {
                          final _lineTicketController =
                              Get.put(LineTicketController());
                          final argument = LineTicketArgument(
                              ticketType: ticketType,
                              actionType: ActionType.create);
                          _lineTicketController.argument = argument;
                          await Get.toNamed(Routes.chooseLine);
                        } else {
                          await Get.toNamed(Routes.chooseSubstation,
                              arguments: argument);
                        }
                      }
                    }
                  },
                )
              : Container(
                  width: 30,
                ),
          title: Text(
            AppStrings.ticketTitle + ticketType.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          //   subtitle: const Text('29/3/2021'),
        ),
      ),
    );
  }

  Future _handleMenuTap(
      SubStationType subStationType, TicketType ticketType) async {
    final argument = TicketScreenArgument(
        ticketType: ticketType,
        subStationType: subStationType,
        actionType: ActionType.create);
    _controller.setTicketType(subStationType, ticketType);
    final user = AppShared.instance.getUserProfile();
    if (user.username == 'managerquocoai@gmail.com') {
      await Get.to(() => TicketOfManagerScreen(), arguments: argument);
    } else {
      if (ticketType == TicketType.periodicDay ||
          ticketType == TicketType.periodicNight) {
        debugPrint('haudau123456 periodicDay or periodicNight');
        await Get.toNamed(Routes.periodicInspectionPlanView,
            arguments: argument);
      } else {
        debugPrint('haudau123456 else');
        await Get.toNamed(Routes.historyCheck);
      }
    }
  }
}

