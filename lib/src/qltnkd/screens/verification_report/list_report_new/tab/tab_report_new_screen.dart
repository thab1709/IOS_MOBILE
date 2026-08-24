// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/item_work_new.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../list_report/tab/tab_report_controller.dart';

class TabReportNewScreen extends StatefulWidget {
  final String statusReport;
  final int index;

  const TabReportNewScreen({
    this.statusReport,
    this.index,
  });

  @override
  State<StatefulWidget> createState() {
    return TabReportNewState();
  }
}

class TabReportNewState extends State<TabReportNewScreen>
    implements ListDelegate {
  final _controller = TabReportController();
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.statusReport = widget.statusReport;
    _controller.renderTextBtn();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getWorkMerge(ListTypeLoad.load);
    });

    _controller.listReportController.filterController.stream.listen((event) {
      if (event == widget.index) {
        _controller.getWorkMerge(ListTypeLoad.load);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBody(),
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
      enablePullUp: _controller?.isHasLoadMore?.value ?? false,
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
          return ItemWorkNew(
            workMergeModel: workMergeModel,
            reportStatus: _controller.statusReport,
            isHasCheckbox: _controller.isHasApproval,
            isLast: index == _controller.workMerges.length - 1,
            exportCertificate: (id, type) {
              _controller.exportCertificate(id, type, workMergeModel);
            },
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
            cancelReport: (id) {
              _controller.cancelReport(id);
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

