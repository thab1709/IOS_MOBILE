// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/item_merge_report.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/tab/tab_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchReportScreen extends StatefulWidget {
  SearchReportScreen({
    Key key,
    this.initialSearchTerm,
    this.initialStatusReport,
  }) : super(key: key);

  final String initialSearchTerm;
  final String initialStatusReport;

  @override
  State<StatefulWidget> createState() {
    return _SearchReportState();
  }
}

class _SearchReportState extends State<SearchReportScreen>
    implements ListDelegate {
  final _controller = TabReportController();
  final _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.statusReport = widget.initialStatusReport;
    if (widget.initialSearchTerm?.isNotEmpty == true) {
      _controller.listReportController.fromDate = '';
      _controller.listReportController.toDate = '';
      _controller.listReportController.unit = '0';
      _controller.listReportController.searchTerm = '';
      _searchController.text = widget.initialSearchTerm;
      _controller.searchTerm.value = widget.initialSearchTerm;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.getWorkMerge(ListTypeLoad.refresh);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: false,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            RAppStrings.search,
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: RAppColor.backgroundColorGray,
        body: SafeArea(
            child: Column(
          children: [
            searchBar(),
            Obx(() => Expanded(
                  child: Stack(
                    children: [
                      if (_controller?.workMerges?.obs?.value?.isEmpty ==
                              true &&
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
                ))
          ],
        )));
  }

  Widget searchBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
      padding: const EdgeInsets.all(16),
      child: Obx(() => TextFormField(
            onChanged: (value) {
              _controller.searchTerm.value = value.toString();
            },
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) {
              _controller.getWorkMerge(ListTypeLoad.refresh);
            },
            cursorColor: RAppColor.highlightColor70,
            decoration: InputDecoration(
                focusColor: RAppColor.highlightColor70,
                contentPadding: const EdgeInsets.all(PaddingSize.normal),
                prefixIcon: const Icon(Icons.search),
                hintText: RAppStrings.pleaseInput,
                suffixIcon: _controller?.searchTerm?.value?.isNotEmpty == true
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _controller?.searchTerm?.value = '';
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: RAppColor.highlightColor70),
                ),
                border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: RAppColor.highlightColor70),
                    borderRadius: BorderRadius.circular(30))),
          )),
    );
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
            isHasCheckbox: false,
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

  @override
  void onLoadMoreSuccess() {
    _refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess() {
    _refreshController.refreshCompleted();
  }

  Future<void> _onRefresh() async {
    await _controller.getWorkMerge(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await _controller.getWorkMerge(ListTypeLoad.loadMore);
  }
}

