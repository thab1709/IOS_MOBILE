// @dart=2.9
import 'package:flutter/material.dart';
import 'package:evnmobile/app_env.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/repository/work_registration_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/models/work_registration_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';


class ListWorkRegistrationController extends GetxController {
  final WorkRegistrationRepository _repository = WorkRegistrationRepository();

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var canLoadMore = true.obs;
  
  var registrations = <WorkRegistrationModel>[].obs;
  
  int pageIndex = 1;
  int pageSize = 15;

  var currentTabIndex = 0.obs;

  var searchTerm = ''.obs;
  var registerDateFrom = Rx<DateTime>(null);
  var registerDateTo = Rx<DateTime>(null);
  var confirmFromDate = Rx<DateTime>(null);
  var confirmToDate = Rx<DateTime>(null);
  var constructionId = ''.obs;
  var qlvhUnitId = ''.obs;
  var createdBy = ''.obs;
  var confirmBy = ''.obs;
  var patcId = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onTabChanged(int index) {
    if (currentTabIndex.value == index) return;
    currentTabIndex.value = index;
    refreshData();
  }

  Future<void> refreshData() async {
    pageIndex = 1;
    canLoadMore.value = true;
    registrations.clear();
    await fetchData();
  }

  Future<void> loadMore() async {
    if (!canLoadMore.value || isLoading.value || isLoadMore.value) return;
    pageIndex++;
    isLoadMore.value = true;
    await fetchData(isLoadMoreMode: true);
  }

  Future<void> fetchData({bool isLoadMoreMode = false}) async {
    if (!isLoadMoreMode) isLoading.value = true;

    // Status map based on tab:
    // Tab 0: Tất cả (status = null)
    // Tab 1: Mới (status = 1)
    // Tab 2: Chờ xác nhận (status = 2)
    // Tab 3: Đã xác nhận (status = 3)
    // Tab 4: Từ chối (status = 4)
    int status;
    String apiCreatedBy = createdBy.value;
    if (currentTabIndex.value == 1) {
      status = 1;
      apiCreatedBy = AppShared.instance.getUserProfile()?.name;
    }
    else if (currentTabIndex.value == 2) status = 2;
    else if (currentTabIndex.value == 3) status = 3;
    else if (currentTabIndex.value == 4) status = 4;

    final res = await _repository.getList(
      searchTerm: searchTerm.value,
      fromDate: registerDateFrom.value,
      toDate: registerDateTo.value,
      constructionId: constructionId.value,
      qlvhUnitId: qlvhUnitId.value,
      confirmDateFrom: confirmFromDate.value,
      confirmDateTo: confirmToDate.value,
      createdBy: apiCreatedBy,
      confirmBy: confirmBy.value,
      patcId: patcId.value,
      status: status,
      pageIndex: pageIndex,
      pageSize: pageSize,
      isBackgroundMode: true, // Always true to avoid duplicate ProgressHUD spinner, UI handles it
    );

    if (!isLoadMoreMode) isLoading.value = false;
    isLoadMore.value = false;

    if (res.isLoadSuccess && res.data != null) {
      var items = res.data;
      final currentUserId = AppShared.instance.getUserProfile()?.id;
      // Ẩn các phiếu Mới (status == 1) nếu không phải do mình tạo (áp dụng cho tab Tất cả)
      if (currentTabIndex.value == 0) {
        items = items.where((e) {
          if (e.status == 1) {
            return e.createdBy?.toLowerCase() == currentUserId?.toLowerCase();
          }
          return true;
        }).toList();
      }

      if (!isLoadMoreMode) {
        registrations.assignAll(items);
      } else {
        registrations.addAll(items);
      }
      if (res.data.length < pageSize) {
        canLoadMore.value = false;
      }
    } else {
      canLoadMore.value = false;
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

  Future<void> deleteRegistration(String id) async {
    bool confirm = await rShowDialogConfirm('Xóa ĐKCT', 'Bạn có chắc chắn muốn xóa đăng ký công tác này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.delete(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Xóa thành công');
      registrations.removeWhere((element) => element.id == id);
    } else {
      SnackBarHUD.show(res.message ?? 'Xóa thất bại');
    }
  }

  Future<void> sendRegistration(String id) async {
    bool confirm = await rShowDialogConfirm('Gửi duyệt', 'Bạn có chắc chắn muốn gửi duyệt đăng ký công tác này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.send(id, '');
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Gửi duyệt thành công');
      refreshData();
    } else {
      SnackBarHUD.show(res.message ?? 'Gửi duyệt thất bại');
    }
  }

  Future<void> approveRegistration(String id) async {
    bool confirm = await rShowDialogConfirm('Phê duyệt', 'Bạn có chắc chắn muốn phê duyệt đăng ký công tác này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.approve(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Phê duyệt thành công');
      refreshData();
    } else {
      SnackBarHUD.show(res.message ?? 'Phê duyệt thất bại');
    }
  }

  Future<void> rejectRegistration(String id) async {
    TextEditingController noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool confirm = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Từ chối', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () => Get.back(result: false),
                      child: const Icon(Icons.close, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Lý do từ chối *',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập lý do từ chối';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          Get.back(result: true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Từ chối'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Đóng lại'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ) ?? false;

    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.reject(id, noteController.text);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Từ chối thành công');
      refreshData();
    } else {
      SnackBarHUD.show(res.message ?? 'Từ chối thất bại');
    }
  }

  void exportExcel() async {
    String baseUrl = '${AppEnv.getServerUrl()}/workregistration';
    if (AppEnv.getAppEnv() == ENV.dev) {
      baseUrl = 'http://125.212.226.94:5006/tnkd/api/workregistration';
    }
    final url = '$baseUrl/export?pageIndex=$pageIndex&pageSize=$pageSize';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      SnackBarHUD.show('Không thể mở liên kết');
    }
  }
}
