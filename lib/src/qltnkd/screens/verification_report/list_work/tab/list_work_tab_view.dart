// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/item_driver.dart';
import 'package:evnmobile/src/qltnkd/common/components/item_work.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'list_work_controller.dart';

class ListWorkTab extends StatefulWidget {
  final String status;
  final int index;

  const ListWorkTab({
    this.status,
    this.index,
  });

  @override
  State<StatefulWidget> createState() {
    return _ListWorkTabState();
  }
}

class _ListWorkTabState extends State<ListWorkTab> implements ListDelegate {
  final controller = ListWorkController();
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    controller.delegate = this;
    controller.workStatus = widget.status;
    Future.delayed(const Duration(milliseconds: 100),
        () => {
      controller.loadData(ListTypeLoad.load)
    });
    controller.listReportController.filterController.stream.listen((event) {
      if(event == widget.index) {
        controller.loadData(ListTypeLoad.load);
      }
    });
    controller.listReportController.groupTypeController.stream.listen((event) {
      if(mounted) {
        controller.loadData(ListTypeLoad.load);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isShowLoading.value) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(top: 30),
                child: const CircularProgressIndicator(),
              )
            ],
          ),
        );
      } else {
        return Stack(
          children: [
            if (controller?.works?.isEmpty == true &&
                controller.isFirstLoad)
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
      enablePullUp: controller.isHasLoadMore.value ?? false,
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
          return RUserRole.isDriver
              ? ItemDriver(
                  reportWorkItem: controller.works[index],
                  index: index,
                  isLast: index == controller.works.length - 1,
                )
              : ItemWork(
                  reportWorkItem: controller.works[index],
                  index: index,
                  isLast: index == controller.works.length - 1,
                  isForX: controller.listReportController.workGroupType.value == 1,
                  callbackLoadData: () {
                    controller.loadData(ListTypeLoad.load);
                  },
                  callbackCreateReport: () async {
                    final workModel = controller.works[index];
                   await controller.handleCreateFormReport(workModel, isSearch: false);
                  },
                );
        },
        itemCount: controller.works.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await controller.loadData(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await controller.loadData(ListTypeLoad.loadMore);
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

