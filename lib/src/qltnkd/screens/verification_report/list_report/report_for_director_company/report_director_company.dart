// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/report_for_director_company/report_director_company_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/report_for_director_company/search_report/search_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/report_for_director_company/tab/director_company_tab.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/scan_qr/scan_qr_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/detail_report/detail_report_screen.dart';
import 'package:evnmobile/src/qltnkd/models/qr_report_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/constance/report_work_status_type.dart';
import 'filter_report/filter_report_screen.dart';

class ReportDirectorCompany extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReportDirectorCompanyState();
  }
}

class ReportDirectorCompanyState extends State<ReportDirectorCompany>
    with SingleTickerProviderStateMixin {
  final _controller = Get.put(ReportDirectorCompanyController());
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _controller.optionsStatus.length, vsync: this);
    _controller.getUnitsOnline();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _controller.optionsStatus.length ?? 0,
        child: Scaffold(
          backgroundColor: RAppColor.backgroundColorGray,
          appBar: AppBar(
            backgroundColor: RAppColor.highlightColor70,
            elevation: 1,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            centerTitle: false,
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: _controller.optionsStatus
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
                      Get.to(() => SearchReportDirectorCompanyScreen(
                            loadType: StatusReportForDirectorCompany.listStatus[_tabController.index],
                            initialSearchTerm: result.reportId?.isNotEmpty == true ? result.reportId : uuid,
                          ));
                    } else if (searchValue?.isNotEmpty == true) {
                      Get.to(() => SearchReportDirectorCompanyScreen(
                            loadType: StatusReportForDirectorCompany.listStatus[_tabController.index],
                            initialSearchTerm: searchValue,
                          ));
                    }
                  } else if (result is String && result.isNotEmpty) {
                    Get.to(() => SearchReportDirectorCompanyScreen(
                          loadType: StatusReportForDirectorCompany.listStatus[_tabController.index],
                          initialSearchTerm: result,
                        ));
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.to(() => SearchReportDirectorCompanyScreen(
                        loadType: StatusReportForDirectorCompany.listStatus[_tabController.index],
                      ));
                },
              ),
              IconButton(
                  onPressed: () async {
                    final result = await Get.to(() => FilterReportDirectorCompanyScreen());
                    if(result == true) {
                      _controller.reloadPage(_tabController.index);
                    }
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    _controller.isNewToOld = !_controller.isNewToOld;
                    _controller.reloadPage(_tabController.index);
                  },
                  icon: Tooltip(
                    message: _controller.isNewToOld
                        ? 'Xắp xếp từ mới -> cũ'
                        : 'Xắp xếp từ cũ -> mới',
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
          drawer: AppDrawer(
            index: CategoryMenu.reportForDirectorCompany,
          ),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: buildListTab(),
            ),
          ),
        ));
  }

  List<Widget> buildListTab() {
    final list = _controller.optionsStatus
        .mapIndexed<Widget>((status, index) => DirectorCompanyTab(
              loadType: status.value,
              index: index,
              tabController: _tabController,
            ))
        .toList();
    return list;
  }
}

