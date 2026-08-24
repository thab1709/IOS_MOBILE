// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/list_patc/list_patc_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/list_patc/widget/item_patc.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_create/patc_create_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_detail/patc_detail_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/widget/patc_history_dialog.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_create/work_registration_create_screen.dart';

class PatcPage extends StatefulWidget {
  @override
  _PatcPageState createState() => _PatcPageState();
}

class _PatcPageState extends State<PatcPage> {
  final _controller = Get.find<ListPatcController>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _controller.refreshData();
    _refreshController.refreshCompleted();
  }

  void _onLoadMore() async {
    await _controller.loadMore();
    if (_controller.canLoadMore.value) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [_buildBody()],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (_controller.isLoading.value && _controller.patcs.isEmpty) {
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
              if (_controller.patcs.isEmpty)
                const Center(
                  child: Text(RAppStrings.emptyData, style: TextStyle(fontSize: 20)),
                ),
              _renderList()
            ],
          ),
        );
      }
    });
  }

  Widget _renderList() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _controller.canLoadMore.value,
      header: WaterDropHeader(
        refresh: Container(),
        complete: const Icon(Icons.done, color: RAppColor.highlightColor70),
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
          return Divider(height: 1, color: Colors.grey.shade300);
        },
        itemBuilder: (c, i) {
          final model = _controller.patcs[i];
          return ItemPatc(
            model: model,
            isFirst: i == 0,
            isLast: i == _controller.patcs.length - 1,
            onGoToDetail: () {
              Get.to(() => PatcDetailScreen(id: model.id, initialModel: model))?.then((_) {
                _controller.refreshData();
              });
            },
            onDelete: () => _controller.deletePatc(model.id),
            onSend: () => _controller.sendPatc(model.id),
            onSign: () => _controller.approvePatc(model.id),
            onReject: () => _controller.rejectPatc(model.id),
            onExternalSign: () => _controller.handleExternalSign(model.id),
            onEdit: () {
              Get.to(() => PatcCreateScreen(editModel: model))?.then((_) {
                _controller.refreshData();
              });
            },
            onHistory: () {
              Get.bottomSheet(
                PatcHistoryBottomSheet(id: model.id),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            onExportPdf: () => _controller.viewPdf(model),
            onDownload: () => _controller.downloadFiles(model),
            onCreateWorkRegistration: () {
              Get.to(() => WorkRegistrationCreateScreen(initialPatcId: model.id));
            },
          );
        },
        itemCount: _controller.patcs.length,
      ),
    );
  }
}
