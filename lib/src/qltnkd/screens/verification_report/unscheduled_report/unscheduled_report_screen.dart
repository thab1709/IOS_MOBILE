// @dart=2.9
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/components/item_report.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/map/map_page.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/unscheduled_report/search/search_unscheduled_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app_common/shared/app_shared.dart';
import 'add/add_scheduled_screen.dart';
import 'filter/filter_unscheduled_report_screen.dart';
import 'unscheduled_report_controller.dart';

class UnscheduledReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListReportState();
  }
}

class ListReportState extends State<UnscheduledReportScreen> implements ListDelegate {
  final _controller = Get.put(UnscheduledReportController());
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    Future.delayed(const Duration(milliseconds: 100),
            () => {_controller.getFormReport(ListTypeLoad.load)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RAppColor.backgroundColorGray,
      appBar: AppBar(
        backgroundColor: RAppColor.highlightColor70,
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(() => SearchUnscheduledReportScreen());
            },
          ),
          IconButton(
              onPressed: () {
                Get.to(() => FilterUnscheduledReportScreen());
              },
              icon: const Icon(
                Icons.filter_list,
                color: Colors.white,
              )),

          if (AppShared.instance.getUserProfile().isHasCreateFormReport() && !RUserRole.isOperator)
            IconButton(
                onPressed: () async {
                  final result = await Get.to(() => AddUnScheduleScreen());
                  if (result == true) {
                    _controller.reloadLoad();
                  }
                },
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: Colors.white,
                )),
        ],
        title: const Text(
          RAppStrings.listUnscheduledReport,
          style: TextStyle(fontSize: TextSize.normal),
        ),
      ),
      drawer: AppDrawer(index: CategoryMenu.unscheduledReport,),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (_controller.isShowLoading.value) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(top: 30),
                  child: const CircularProgressIndicator(),
                ),
              ),
            )
          ],
        );
      } else {
        return Stack(
          children: [
            if (_controller?.listReport?.obs?.value?.isEmpty == true &&
                _controller.isFirstLoad)
              const Center(
                child: Text(
                  RAppStrings.emptyData,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            _renderList()
          ],
        );
      }
    });
  }

  Widget _renderList() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _controller.isHasLoadMore.value ?? false,
      header: WaterDropHeader(
        refresh: Container(),
        complete: const Icon(
          Icons.done,
          color: RAppColor.highlightColor70,
        ),
      ),
      footer: const ClassicFooter(
        loadStyle: LoadStyle.HideAlways,
        loadingText: '',
        noDataText: '',
        canLoadingText: '',
        failedText: '',
        idleText: '',
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoadMore,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Container(

            margin: const EdgeInsets.symmetric(horizontal: 16),
          );
        },
        itemBuilder: (context, index) {
          final report = _controller.listReport[index];
          return ItemReport(
            report: report,
            isHasCheckBox: false,
            isLast: index == _controller.listReport.length - 1,
            reloadData: () {
              _controller.getFormReport(ListTypeLoad.refresh);
            },
            showMap: () async {
              final isLocationGranted = await LocationServiceBackground.shared.requestPermission();
              if (isLocationGranted) {
                await Get.to(() =>
                    RMapPage(
                      equipmentDetail: report.equipmentDetail,
                      location: report.reportNumber,
                      createDate: report.createdDate,
                      scheduledId: report.id,
                      workType: report.reportTypeName,
                    ));
              }
            },
            index: index,
          );
        },
        itemCount: _controller.listReport.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _controller.getFormReport(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await _controller.getFormReport(ListTypeLoad.loadMore);
  }

  @override
  void onLoadMoreSuccess() {
    _refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess() {
    _refreshController.refreshCompleted();
  }
}
