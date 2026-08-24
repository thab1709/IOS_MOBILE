// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/repository/work_registration_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/models/work_registration_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/widget/item_work_registration.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';

class WorkRegistrationSearch extends StatefulWidget {
  @override
  _WorkRegistrationSearchState createState() => _WorkRegistrationSearchState();
}

class _WorkRegistrationSearchState extends State<WorkRegistrationSearch> {
  final TextEditingController _searchController = TextEditingController();
  final _refreshController = RefreshController(initialRefresh: false);
  final _repository = WorkRegistrationRepository();

  var items = <WorkRegistrationModel>[].obs;
  var isLoading = false.obs;
  var searchTerm = "".obs;
  var canLoadMore = true.obs;
  int pageIndex = 1;
  int pageSize = 15;
  bool isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: const Text(
          'Tìm kiếm đăng ký công tác',
          style: TextStyle(color: Colors.black, fontSize: 16),
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
              hintText: 'Nhập số ĐKCT, tên phiếu ĐKCT...',
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
      if (isLoading.value && items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (items.isEmpty && !isFirstLoad) {
        return _buildEmpty();
      }
      if (isFirstLoad) {
        return Container(); // Trạng thái ban đầu chưa search
      }
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: canLoadMore.value,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ItemWorkRegistration(item: items[index]);
          },
        ),
      );
    });
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text('Không tìm thấy kết quả', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    isFirstLoad = false;
    pageIndex = 1;
    canLoadMore.value = true;
    items.clear();
    await _fetchData();
    _refreshController.refreshCompleted();
    if (!canLoadMore.value) {
      _refreshController.loadNoData();
    }
  }

  Future<void> _onLoadMore() async {
    if (!canLoadMore.value) {
      _refreshController.loadComplete();
      return;
    }
    pageIndex++;
    await _fetchData();
    _refreshController.loadComplete();
    if (!canLoadMore.value) {
      _refreshController.loadNoData();
    }
  }

  Future<void> _fetchData() async {
    if (searchTerm.value.trim().isEmpty) {
      items.clear();
      canLoadMore.value = false;
      return;
    }

    if (pageIndex == 1) isLoading.value = true;
    final res = await _repository.getList(
      searchTerm: searchTerm.value.trim(),
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
    if (pageIndex == 1) isLoading.value = false;

    if (res.isLoadSuccess) {
      final list = res.data ?? [];
      if (pageIndex == 1) {
        items.assignAll(list);
      } else {
        items.addAll(list);
      }
      canLoadMore.value = list.length == pageSize;
    } else {
      canLoadMore.value = false;
      SnackBarHUD.show(res.message ?? 'Không thể tải dữ liệu');
    }
  }
}
