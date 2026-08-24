// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/repository/patc_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/list_patc/widget/item_patc.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_detail/patc_detail_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_create/patc_create_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/widget/patc_history_dialog.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_create/work_registration_create_screen.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/list_patc/list_patc_controller.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';

class PatcSearch extends StatefulWidget {
  @override
  _PatcSearchState createState() => _PatcSearchState();
}

class _PatcSearchState extends State<PatcSearch> {
  final TextEditingController _searchController = TextEditingController();
  final _refreshController = RefreshController(initialRefresh: false);
  final _repository = PatcRepository();

  var patcs = <PatcModel>[].obs;
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
          'Tìm kiếm phương án thi công',
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
              hintText: 'Nhập số PATC, công trình, người lập...',
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
      if (isLoading.value && patcs.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (patcs.isEmpty && !isFirstLoad) {
        return const Center(
          child: Text('Không có dữ liệu', style: TextStyle(fontSize: 16)),
        );
      }
      if (isFirstLoad && patcs.isEmpty) {
        return const Center(
          child: Text('Nhập từ khóa để tìm kiếm', style: TextStyle(fontSize: 16, color: Colors.grey)),
        );
      }

      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: canLoadMore.value,
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
            final model = patcs[i];
            return ItemPatc(
              model: model,
              isFirst: i == 0,
              isLast: i == patcs.length - 1,
              onGoToDetail: () {
                Get.to(() => PatcDetailScreen(id: model.id, initialModel: model))?.then((_) => _onRefresh());
              },
              onDelete: () => _deletePatc(model.id),
              onSend: () => _sendPatc(model.id),
              onSign: () => _approvePatc(model.id),
              onReject: () => _rejectPatc(model.id),
              onExternalSign: () async {
                SnackBarHUD.show('Tính năng đang phát triển trong màn hình tìm kiếm');
              },
              onEdit: () {
                Get.to(() => PatcCreateScreen(editModel: model))?.then((_) => _onRefresh());
              },
              onHistory: () {
                Get.bottomSheet(
                  PatcHistoryBottomSheet(id: model.id),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
              onExportPdf: () => _viewPdf(model),
              onDownload: () => _downloadFiles(model),
              onCreateWorkRegistration: () {
                Get.to(() => WorkRegistrationCreateScreen(initialPatcId: model.id));
              },
            );
          },
          itemCount: patcs.length,
        ),
      );
    });
  }

  Future<void> _onRefresh() async {
    isFirstLoad = false;
    if (searchTerm.value.isEmpty) {
      patcs.clear();
      _refreshController.refreshCompleted();
      return;
    }
    pageIndex = 1;
    isLoading.value = true;
    final res = await _repository.getListPatc(
      searchTerm: searchTerm.value,
      pageIndex: pageIndex,
      pageSize: pageSize,
      isBackgroundMode: true,
    );
    isLoading.value = false;

    if (res.isLoadSuccess && res.data != null) {
      patcs.value = res.data;
      canLoadMore.value = res.data.length == pageSize;
      _refreshController.refreshCompleted();
    } else {
      patcs.clear();
      _refreshController.refreshFailed();
    }
  }

  Future<void> _onLoadMore() async {
    if (!canLoadMore.value) {
      _refreshController.loadNoData();
      return;
    }
    pageIndex++;
    final res = await _repository.getListPatc(
      searchTerm: searchTerm.value,
      pageIndex: pageIndex,
      pageSize: pageSize,
      isBackgroundMode: true,
    );

    if (res.isLoadSuccess && res.data != null) {
      patcs.addAll(res.data);
      canLoadMore.value = res.data.length == pageSize;
      _refreshController.loadComplete();
    } else {
      pageIndex--;
      _refreshController.loadFailed();
    }
  }

  Future<bool> rShowDialogConfirm(String title, String content) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Đồng ý')),
        ],
      ),
    ) ?? false;
  }

  // --- ACTIONS --- //
  Future<void> _deletePatc(String id) async {
    bool confirm = await rShowDialogConfirm('Xóa PATC', 'Bạn có chắc chắn muốn xóa phương án thi công này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.deletePatc(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Xóa PATC thành công');
      patcs.removeWhere((e) => e.id == id);
    } else {
      SnackBarHUD.show(res.message ?? 'Xóa PATC thất bại');
    }
  }

  Future<void> _sendPatc(String id) async {
    bool confirm = await rShowDialogConfirm('Gửi xác nhận', 'Bạn có chắc chắn muốn gửi xác nhận phương án thi công này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.sendPatc(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Gửi xác nhận PATC thành công');
      _onRefresh();
    } else {
      SnackBarHUD.show('Gửi xác nhận PATC thất bại');
    }
  }

  Future<void> _approvePatc(String id) async {
    bool confirm = await rShowDialogConfirm('Xác nhận PATC', 'Bạn có chắc chắn muốn xác nhận phương án thi công này?');
    if (!confirm) return;

    ProgressHUD.show();
    try {
      final res = await _repository.approvePatc(ids: [id]);
      ProgressHUD.dismiss();

      if (res.isLoadSuccess) {
        await rShowDialogOneButton('Xác nhận PATC thành công');
        _onRefresh();
      } else {
        SnackBarHUD.show('Xác nhận PATC thất bại');
      }
    } catch (e) {
      debugPrint('Error _approvePatc: $e');
      SnackBarHUD.show('Có lỗi xảy ra khi xác nhận PATC');
    } finally {
      ProgressHUD.dismiss();
    }
  }

  Future<void> _rejectPatc(String id) async {
    TextEditingController reasonCtrl = TextEditingController();
    bool confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Từ chối PATC', style: TextStyle(fontSize: 16)),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(hintText: 'Nhập lý do từ chối', border: OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Đồng ý', style: TextStyle(color: Colors.red))),
        ],
      )
    ) ?? false;

    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.rejectPatc(ids: [id], note: reasonCtrl.text);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Từ chối PATC thành công');
      _onRefresh();
    } else {
      SnackBarHUD.show('Từ chối PATC thất bại');
    }
  }

  Future<void> _downloadFiles(PatcModel model) async {
    // Implement if needed or let controller handle
    SnackBarHUD.show('Đang phát triển');
  }

  Future<void> _viewPdf(PatcModel model) async {
    try {
      Get.find<ListPatcController>().viewPdf(model);
    } catch (e) {
      SnackBarHUD.show('Không thể xem PDF lúc này');
    }
  }
}
