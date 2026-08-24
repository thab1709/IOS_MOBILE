// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/list_survey_report_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/widget/item_survey_report.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_detail/survey_report_detail_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_create/survey_report_create_screen.dart';

class SurveyReportPage extends StatefulWidget {
  final ListSurveyReportController controller;

  const SurveyReportPage({Key key, this.controller}) : super(key: key);

  @override
  _SurveyReportPageState createState() => _SurveyReportPageState();
}

class _SurveyReportPageState extends State<SurveyReportPage> {
  ListSurveyReportController _controller;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? Get.find<ListSurveyReportController>();
  }

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
      if (_controller.isLoading.value && _controller.surveyReports.isEmpty) {
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
              if (_controller.surveyReports.isEmpty)
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

  Widget _renderList() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _controller.canLoadMore.value,
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
          return Divider(
            height: 1,
            color: Colors.grey.shade300,
          );
        },
        itemBuilder: (c, i) {
          final model = _controller.surveyReports[i];
          return Obx(() => ItemSurveyReport(
            model: model,
            isFirst: i == 0,
            isLast: i == _controller.surveyReports.length - 1,
            onGoToDetail: () async {
              final result = await Get.to(() => SurveyReportDetailScreen(
                  surveyReportId: model.id, initialModel: model));
              if (result == true) {
                _controller.refreshData();
              }
            },
            onDelete: () {
              _controller.deleteReport(model.id);
            },
            onSend: () {
              _controller.sendReport(model.id);
            },
            onSign: () {
              _controller.approveReport(model.id);
            },
            onReject: () {
              _controller.rejectReport(model.id);
            },
            onExternalSign: () {
              _controller.handleExternalSign(model.id);
            },
            onEdit: () {
              Get.to(() => SurveyReportCreateScreen(editModel: model))?.then((_) {
                _controller.refreshData();
              });
            },
            onExportPdf: () {
              _controller.exportPdf(model.id);
            },
            isSelectMode: _controller.isSelectMode.value,
            isSelected: _controller.selectedReports.any((e) => e.id == model.id),
            onSelectChanged: (val) {
              _controller.toggleSelect(model);
            },
          ));
        },
        itemCount: _controller.surveyReports.length,
      ),
    );
  }
}
