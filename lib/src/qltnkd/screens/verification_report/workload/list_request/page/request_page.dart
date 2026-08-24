// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../delegate/list_delegate.dart';
import '../../detail_request/detail_workload.dart';
import '../widget/item_request.dart';
import 'request_page_controller.dart';

class RequestPage extends StatefulWidget {
  final int status;
  final int index;
  final TabController tabController;

  const RequestPage({
    this.status,
    this.index,
    this.tabController,
  });

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> implements ListDelegate {
  final _refreshController = RefreshController(initialRefresh: false);
  final _controller = RequestPageController();


  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.requestStatus = widget.status;
    
    if (widget.tabController != null) {
      widget.tabController.addListener(_handleTabSelection);
    }

    if (widget.tabController == null || widget.tabController.index == widget.index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.loadData(ListTypeLoad.load);
      });
    }

    _controller.listWorkloadController.filterController.stream.listen((event) {
      if(event == widget.index) {
        _controller.loadData(ListTypeLoad.load);
      }
    });
  }

  void _handleTabSelection() {
    if (widget.tabController.index == widget.index && _controller.requests.isEmpty) {
      _controller.loadData(ListTypeLoad.load);
    }
  }

  @override
  void dispose() {
    if (widget.tabController != null) {
      widget.tabController.removeListener(_handleTabSelection);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isShowLoading.value) {
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
            if (_controller?.requests?.obs?.value?.isEmpty == true && _controller.isFirstLoad)
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
          return ItemRequest(
            model: model,
            isLast: index == _controller.requests.length - 1,
            isFirst: index == 0,
            onCreate: () async {
             await Get.to(() => DetailWorkLoad(requestModel: model,));
             await _controller.loadData(ListTypeLoad.load);
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

  void loadData() {
    _controller.loadData(ListTypeLoad.load);
  }
}

