// @dart=2.9
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/detail_request/detail_workload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../common/components/app_button.dart';
import '../../../../../delegate/list_delegate.dart';
import '../../common/constance_workload.dart';
import '../widget/item_workload.dart';
import 'workload_page_controller.dart';

class WorkloadPage extends StatefulWidget {
  final int status;
  final int index;

  const WorkloadPage({
    this.status,
    this.index,
  });

  @override
  State<WorkloadPage> createState() => _WorkloadPageState();
}

class _WorkloadPageState extends State<WorkloadPage> implements ListDelegate {
  final _refreshController = RefreshController(initialRefresh: false);
  final _controller = WorkloadPageController();

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.requestStatus = widget.status;

    _controller.listWorkloadController.filterController.stream.listen((event) {
      if (event == widget.index) {
        _controller.loadData(ListTypeLoad.load);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadData(ListTypeLoad.load);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [_buildBody(), _buildButton()],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (_controller.isShowLoading.value) {
        return Expanded(
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
        return Expanded(
          child: Stack(
            children: [
              if (_controller?.requests?.isEmpty == true &&
                  _controller.isFirstLoad)
                const Center(
                  child: Text(
                    RAppStrings.emptyData,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              _renderList()
            ],
          ),
        );
      }
    });
  }

  Widget _buildButton() {
    if (widget.status == WorkloadStatusCode.waitConfirm &&
        _controller.listWorkloadController.userProfile
            .isHasPermissionApproveConfirmSheet()) {
      return Row(
        children: [
          Expanded(
            child: RButton(
                title: 'Từ chối',
                borderRadius: 0,
                color: RAppColor.colorOrange,
                action: () async {
                  await _controller.reject();
                }),
          ),
          Expanded(
            child: RButton(
                title: 'Xác nhận',
                borderRadius: 0,
                action: () async {
                  await _controller.approval();
                }),
          )
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _renderList() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _controller.isHasLoadMore.value,
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
          return const SizedBox(
            height: 20,
          );
        },
        itemBuilder: (context, index) {
          final model = _controller.requests[index];
          return ItemWorkload(
            model: model,
            isLast: index == _controller.requests.length - 1,
            isFirst: index == 0,
            onSelect: (id, isChecked) {
              _controller.selectItem(id, isChecked: isChecked);
            },
            isShowCheckBox: widget.status == WorkloadStatusCode.waitConfirm,
            onGoToDetail: () async {
              await Get.to(() => DetailWorkLoad(workloadModel: model));
              await _controller.loadData(ListTypeLoad.load);
            },
            onSend: () {
              _controller.sendRequest(model.id);
            },
            onSign: () {
              _controller.openHandwrittenSignature(model);
            },
            onDelete: () {
              rShowMyDialogOkCancel('Bạn có chắc muốn xóa phiếu này không?',
                  secondFunction: () {
                _controller.deleteRequest(model.id);
              });
            },
          );
        },
        itemCount: _controller.requests.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _controller.loadData(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await _controller.loadData(ListTypeLoad.loadMore);
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

