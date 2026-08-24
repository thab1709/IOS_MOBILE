// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/item_driver.dart';
import 'package:evnmobile/src/qltnkd/common/components/item_work.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../tab/list_work_controller.dart';

class SearchWorkScreen extends StatefulWidget {
  const SearchWorkScreen({Key key, this.initialSearchTerm}) : super(key: key);
  final String initialSearchTerm;

  @override
  State<StatefulWidget> createState() {
    return SearchWorkScreenState();
  }
}

class SearchWorkScreenState extends State<SearchWorkScreen>
    implements ListDelegate {
  final _controller = ListWorkController();
  final _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    if (widget.initialSearchTerm != null && widget.initialSearchTerm.isNotEmpty) {
      _searchController.text = widget.initialSearchTerm;
      _controller.searchTerm.value = widget.initialSearchTerm;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.searchData(ListTypeLoad.load);
      });
    }
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
                if (_controller?.works?.obs?.value?.isEmpty == true &&
                    _controller.isFirstLoad)
                  const Center(
                    child: Text(
                      RAppStrings.emptyData,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                Column(
                  children: [searchBar(), Expanded(child: _renderList())],
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
              _controller.searchData(ListTypeLoad.load);
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
          final workItem = _controller.works[index];

          return RUserRole.isDriver
              ? ItemDriver(
                  reportWorkItem: workItem,
                  index: index,
                  isLast: index == _controller.works.length - 1,
                )
              : ItemWork(
                  reportWorkItem: workItem,
                  index: index,
                  isLast: index == _controller.works.length - 1,
                  callbackLoadData: () {
                    _controller.searchData(ListTypeLoad.load);
                  },
                  callbackCreateReport: () async {
                    final workModel = _controller.works[index];
                    await _controller.handleCreateFormReport(workModel,
                        isSearch: true);
                  },
                );
        },
        itemCount: _controller.works.length,
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
    await _controller.searchData(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await _controller.searchData(ListTypeLoad.loadMore);
  }
}

