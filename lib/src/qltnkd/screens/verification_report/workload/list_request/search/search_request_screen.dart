// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_request/search/search_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../detail_request/detail_workload.dart';
import '../widget/item_request.dart';

class SearchRequestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchRequestScreenState();
  }
  }

class _SearchRequestScreenState extends State<SearchRequestScreen>
    implements ListDelegate {
  final _controller = SearchRequestController();
  final _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: const Text(
          RAppStrings.search,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Obx(() => Stack(
          children: [
            if (_controller?.requests?.obs?.value?.isEmpty == true &&
                _controller.isFirstLoad)
              const Center(
                child: Text(
                  RAppStrings.emptyData,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            Column(
              children: [
                searchBar(),
                Expanded(child: _renderList())
              ],
            )
          ],
        )),
      ),
      backgroundColor: RAppColor.backgroundColorGray,
    );
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
              _controller.loadData(ListTypeLoad.load);
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
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
          );
        },
        itemBuilder: (context, index) {
          final model = _controller.requests[index];
          return ItemRequest(
            model: model,
            isLast: index == _controller.requests.length - 1,
            isFirst: index == 0,
            onCreate: () {
              Get.to(() => DetailWorkLoad(
                    requestModel: model,
                  ));
            },
          );
        },
        itemCount: _controller.requests.length,
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
    await _controller.loadData(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await _controller.loadData(ListTypeLoad.loadMore);
  }
}

