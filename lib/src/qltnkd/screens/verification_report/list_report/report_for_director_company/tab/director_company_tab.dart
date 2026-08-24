// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/item_merge_report.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/report_for_director_company/tab/director_company_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DirectorCompanyTab extends StatefulWidget {
  const DirectorCompanyTab({this.loadType, this.index, this.tabController});

  final int loadType;
  final int index;
  final TabController tabController;

  @override
  State<StatefulWidget> createState() {
    return TabReportState();
  }
}

class TabReportState extends State<DirectorCompanyTab> implements ListDelegate {
  final _controller = ReportDirectorCompanyTabController();
  final _refreshController = RefreshController(initialRefresh: false);
  StreamSubscription<int> _filterSubscription;

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.loadType = widget.loadType;
    if (widget.loadType == StatusReportForDirectorCompany.needSign) {
      _controller.renderTextBtn();
    }

    if (widget.tabController != null) {
      widget.tabController.addListener(_handleTabSelection);
    }

    if (widget.tabController == null ||
        widget.tabController.index == widget.index) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _loadReports();
      });
    }

    _filterSubscription = _controller
        .reportDirectorCompanyController.filterController.stream
        .listen((event) {
      if (event == widget.index) {
        _loadReports();
      }
    });
  }

  Future<void> _loadReports() async {
    if (!mounted) {
      return;
    }
    await _controller.getWorkMerge(ListTypeLoad.load);
  }

  void _handleTabSelection() {
    if (widget.tabController.index == widget.index &&
        _controller.workMerges.isEmpty) {
      _loadReports();
    }
  }

  @override
  void dispose() {
    if (widget.tabController != null) {
      widget.tabController.removeListener(_handleTabSelection);
    }
    _filterSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBody(),
          if (widget.loadType == StatusReportForDirectorCompany.needSign)
            Row(
              children: [
                if (_controller.isHasReject)
                  Expanded(
                    child: RButton(
                        title: 'Từ chối',
                        borderRadius: 0,
                        color: RAppColor.colorOrange,
                        action: _controller.actionReject),
                  ),
                if (_controller.isHasApproval)
                  Expanded(
                    child: RButton(
                        title: _controller.textBtn,
                        borderRadius: 0,
                        action: _controller.actionApproval),
                  )
              ],
            )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(child: Obx(() {
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
            if (_controller?.workMerges?.obs?.value?.isEmpty == true &&
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
    }));
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
          final workMergeModel = _controller.workMerges[index];
          return ItemMergeReport(
            workMergeModel: workMergeModel,
            isLast: index == _controller.workMerges.length - 1,
            isHasCheckbox: _controller.isHasApproval,
            onSelect: (workId, isChecked) {
              _controller.selectItem(workId, isChecked: isChecked);
            },
            index: index,
            expandItem: () {
              _controller.expandItem(workMergeModel);
            },
            recall: (id) {
              _controller.recall(id);
            },
          );
        },
        itemCount: _controller.workMerges.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _controller.getWorkMerge(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await _controller.getWorkMerge(ListTypeLoad.loadMore);
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

