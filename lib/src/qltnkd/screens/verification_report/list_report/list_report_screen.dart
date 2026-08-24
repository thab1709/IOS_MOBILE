// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/models/qr_report_result.dart';
import 'package:evnmobile/src/qltnkd/offline_service/sync_manager.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/search_report/search_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/tab/tab_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/scan_qr/scan_qr_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/detail_report/detail_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app_common/shared/app_shared.dart';
import 'filter_report/filter_report_screen.dart';
import 'list_report_controller.dart';

class ListReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListReportState();
  }
}

class ListReportState extends State<ListReportScreen>
    with SingleTickerProviderStateMixin {
  final _controller = Get.put(ListReportController());
  TabController _tabController;
  List<IntOptionModel> listTab;

  @override
  void initState() {
    super.initState();
    if (RUserRole.isLeader) {
      listTab = _controller.optionsStatus
          .where((element) => ![
                ReportStatusType.WaitingForCenterApproval,
                ReportStatusType.WaitingForTeamApproval,
                ReportStatusType.Implementing,
                ReportStatusType.Rejected
              ].contains(element.value))
          .toList();
    } else if(RUserRole.isOperator) {
      listTab = _controller.optionsStatus
          .where((element) => ![
        ReportStatusType.WaitingForCenterApproval,
      ].contains(element.value))
          .toList();
    } else {
      listTab = _controller.optionsStatus;
    }
    _tabController =
        TabController(length: listTab.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: listTab.length ?? 0,
        child: Scaffold(
          backgroundColor: RAppColor.backgroundColorGray,
          appBar: AppBar(
            backgroundColor: RAppColor.highlightColor70,
            elevation: 1,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            centerTitle: false,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: listTab
                  .map<Tab>((optionModel) => Tab(
                        text: optionModel.title,
                      ))
                  .toList(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final result = await Get.to(() => const ScanQRReportScreen());
                  if (result is QRReportResult) {
                    final searchValue = result.searchValue;
                    final match = RegExp(r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}')
                            .firstMatch(searchValue ?? '');
                    final uuid = match?.group(0);
                            
                    if (result.reportId?.isNotEmpty == true || uuid != null) {
                      Get.to(() => SearchReportScreen(
                            initialSearchTerm: result.reportId?.isNotEmpty == true ? result.reportId : uuid,
                          ));
                    } else if (searchValue?.isNotEmpty == true) {
                      Get.to(() => SearchReportScreen(
                            initialSearchTerm: searchValue,
                          ));
                    }
                  } else if (result is String && result.isNotEmpty) {
                    Get.to(() => SearchReportScreen(initialSearchTerm: result));
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.to(() => SearchReportScreen());
                },
              ),
              IconButton(
                  onPressed: () async {
                    final result = await Get.to(() => FilterReportScreen());
                    if(result == true) {
                      _controller.reloadTab(_tabController.index);
                    }
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    _controller.isNewToOld = !_controller.isNewToOld;
                    _controller.reloadTab(_tabController.index);
                  },
                  icon: Tooltip(
                    message:
                    _controller.isNewToOld ? 'Xắp xếp từ mới -> cũ' : 'Xắp xếp từ cũ -> mới',
                    child: Icon(
                      _controller.isNewToOld
                          ? Icons.arrow_circle_down_rounded
                          : Icons.arrow_circle_up_rounded,
                      color: Colors.white,
                    ),
                  )),
            ],
            title: const Text(
              RAppStrings.listReport,
              style: TextStyle(fontSize: TextSize.normal),
            ),
          ),
          floatingActionButton: (AppShared.instance.getUserProfile().isHasCreateFormReport())
              ? FloatingActionButton(
            backgroundColor: RAppColor.colorOrange,
            onPressed: () async {
              await RSyncManager.instance.doSync();
            },
            child: const Icon(Icons.sync),
          )
              : Container(),
  //        drawer: AppDrawer(index: CategoryMenu.report,),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: buildListTab(),
            ),
          ),
        ));
  }

  List<Widget> buildListTab() {
    final list = listTab
        .mapIndexed<Widget>((status, index) => TabReportScreen(
              statusReport: '${status.value}',
              index: index,
              tabController: _tabController,
            ))
        .toList();
    return list;
  }
}

