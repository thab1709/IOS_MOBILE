// @dart=2.9
import 'package:flutter/material.dart';
import 'package:evnmobile/app_env.dart';
import 'package:get/get.dart';
import 'package:evnmobile/app_env.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/repository/work_registration_repository.dart';
import 'package:photo_view/photo_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/models/work_registration_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_history_model.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';

class WorkRegistrationDetailController extends GetxController {
  final String id;
  final WorkRegistrationRepository _repository = WorkRegistrationRepository();

  WorkRegistrationDetailController(this.id);

  var isLoading = false.obs;
  var detail = WorkRegistrationDetailModel().obs; // reuse history model from SurveyReport

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final res = await _repository.getDetail(id);
      if (res.isLoadSuccess && res.data != null) {
        if (Get.arguments != null && Get.arguments is Map) {
          res.data.isAllowApprove = Get.arguments['canApprove'] ?? res.data.isAllowApprove;
          res.data.isAllowReject = Get.arguments['canReject'] ?? res.data.isAllowReject;
        }
        detail.value = res.data;
      } else {
        SnackBarHUD.show(res.message ?? 'Không thể lấy thông tin chi tiết');
      }
    } finally {
      isLoading.value = false;
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

  Future<void> downloadFile(String path) async {
    if (path == null || path.isEmpty) return;
    String url = path;
    if (path.startsWith('/')) {
      url = '${AppEnv.getServerUrl().replaceAll('/api', '')}$path';
    }
    
    if (!url.contains('access_token=')) {
      final token = AppShared.instance.getUserToken();
      final separator = url.contains('?') ? '&' : '?';
      url = '$url${separator}access_token=$token';
    }

    final nameLower = url.toLowerCase();
    final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');
    
    if (isImage) {
      Get.to(() => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Ảnh đính kèm', style: TextStyle(fontSize: 16)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: PhotoView(
          imageProvider: NetworkImage(url, headers: {
            'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'
          }),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ));
      return;
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      SnackBarHUD.show('Không thể mở liên kết');
    }
  }

  Future<void> send() async {
    if (detail.value == null) return;
    bool confirm = await rShowDialogConfirm('Ký số & Gửi duyệt', 'Bạn có chắc chắn muốn ký số và gửi duyệt đăng ký công tác này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.send(id, detail.value.receiverNote);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Ký số & Gửi duyệt thành công');
      fetchData(); // reload
    } else {
      SnackBarHUD.show(res.message ?? 'Gửi duyệt thất bại');
    }
  }

  Future<void> approve() async {
    if (detail.value == null) return;
    bool confirm = await rShowDialogConfirm('Phê duyệt', 'Bạn có chắc chắn muốn phê duyệt đăng ký công tác này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.approve(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await Get.dialog(
        AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Phê duyệt thành công!'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Đóng')),
          ],
        ),
      );
      Get.back(result: true); // return to list and trigger reload
    } else {
      SnackBarHUD.show(res.message ?? 'Phê duyệt thất bại');
    }
  }

  Future<void> reject() async {
    if (detail.value == null) return;
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
      await Get.dialog(
        AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Từ chối thành công!'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Đóng')),
          ],
        ),
      );
      Get.back(result: true); // return to list and trigger reload
    } else {
      SnackBarHUD.show(res.message ?? 'Từ chối thất bại');
    }
  }

  Future<void> delete() async {
    if (detail.value == null) return;
    bool confirm = await rShowDialogConfirm('Xóa ĐKCT', 'Bạn có chắc chắn muốn xóa đăng ký công tác này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.delete(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Xóa thành công');
      Get.back(result: true); // return true to refresh list
    } else {
      SnackBarHUD.show(res.message ?? 'Xóa thất bại');
    }
  }
}
