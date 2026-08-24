// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/widget/item_survey_report.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_detail/survey_report_detail_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_create/survey_report_create_screen.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';

class SurveyReportSearch extends StatefulWidget {
  @override
  _SurveyReportSearchState createState() => _SurveyReportSearchState();
}

class _SurveyReportSearchState extends State<SurveyReportSearch> {
  final TextEditingController _searchController = TextEditingController();
  final _refreshController = RefreshController(initialRefresh: false);
  final _repository = SurveyReportRepository();

  var surveyReports = <SurveyReportModel>[].obs;
  var isLoading = false.obs;
  var searchTerm = "".obs;
  var canLoadMore = true.obs;
  int pageIndex = 1;
  int pageSize = 10;
  bool isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: const Text(
          'Tìm kiếm biên bản',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: RAppColor.backgroundColorGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      padding: const EdgeInsets.all(16),
      child: Obx(() => TextFormField(
            controller: _searchController,
            onChanged: (val) => searchTerm.value = val,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) => _onRefresh(),
            decoration: InputDecoration(
              hintText: 'Nhập số phiếu hoặc tên công trình...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchTerm.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        searchTerm.value = "";
                        _onRefresh();
                      },
                    )
                  : null,
            ),
          )),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (isLoading.value && surveyReports.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (surveyReports.isEmpty && !isFirstLoad) {
        return const Center(
          child: Text('Không có dữ liệu', style: TextStyle(fontSize: 18)),
        );
      }
      return _renderList();
    });
  }

  Widget _renderList() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: canLoadMore.value,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoadMore,
      header: const WaterDropHeader(),
      footer: const ClassicFooter(loadStyle: LoadStyle.HideAlways),
      child: ListView.separated(
        itemCount: surveyReports.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
        itemBuilder: (c, i) {
          final model = surveyReports[i];
          return ItemSurveyReport(
            model: model,
            isFirst: i == 0,
            isLast: i == surveyReports.length - 1,
            onGoToDetail: () {
              Get.to(() => SurveyReportDetailScreen(surveyReportId: model.id));
            },
            onDelete: () {},
            onSend: () async {
              // Send
              ProgressHUD.show();
              final res = await _repository.sendSurveyReport(id: model.id);
              ProgressHUD.dismiss();
              if (res.isLoadSuccess) {
                SnackBarHUD.show('Thành công');
                _onRefresh();
              }
            },
            onSign: () async {
              ProgressHUD.show();
              final res = await _repository.approveSurveyReport(ids: [model.id]);
              ProgressHUD.dismiss();
              if (res.isLoadSuccess) {
                SnackBarHUD.show('Thành công');
                _onRefresh();
              }
            },
            onReject: () async {
              TextEditingController noteController = TextEditingController();
              bool confirm = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('Từ chối biên bản'),
                  content: TextField(
                    controller: noteController,
                    decoration: const InputDecoration(hintText: 'Nhập lý do từ chối'),
                    maxLines: 3,
                  ),
                  actions: [
                    TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
                    TextButton(onPressed: () => Get.back(result: true), child: const Text('Từ chối')),
                  ],
                )
              ) ?? false;
              if (!confirm) return;
              
              ProgressHUD.show();
              final res = await _repository.rejectSurveyReport(ids: [model.id], note: noteController.text);
              ProgressHUD.dismiss();
              if (res.isLoadSuccess) {
                SnackBarHUD.show('Thành công');
                _onRefresh();
              }
            },
            onExternalSign: () async {
              SnackBarHUD.show('Tính năng đang phát triển trong màn hình tìm kiếm');
            },
            onEdit: () {
              Get.to(() => SurveyReportCreateScreen(editModel: model))?.then((_) {
                _onRefresh();
              });
            },
          );
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    isFirstLoad = false;
    pageIndex = 1;
    canLoadMore.value = true;
    surveyReports.clear();
    await _fetchData();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoadMore() async {
    if (!canLoadMore.value) return;
    pageIndex++;
    await _fetchData(isLoadMore: true);
    if (canLoadMore.value) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    if (!isLoadMore) isLoading.value = true;

    final res = await _repository.getListSurveyReport(
      searchTerm: searchTerm.value,
      pageIndex: pageIndex,
      pageSize: pageSize,
      isBackgroundMode: true,
    );

    if (!isLoadMore) isLoading.value = false;

    if (res.isLoadSuccess && res.data != null) {
      if (!isLoadMore) {
        surveyReports.assignAll(res.data);
      } else {
        surveyReports.addAll(res.data);
      }
      if (res.data.length < pageSize) {
        canLoadMore.value = false;
      }
    } else {
      canLoadMore.value = false;
    }
  }
}
