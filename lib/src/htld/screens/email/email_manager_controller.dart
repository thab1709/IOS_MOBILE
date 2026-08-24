// @dart=2.9
import 'package:evnmobile/src/htld/models/email_model.dart';
import 'package:evnmobile/src/htld/services/responsitory/email_repository.dart';
import 'package:get/get.dart';

class EmailManagerController extends GetxController {
  final EmailRepository _repo = EmailRepository();
  final emails = <EmailModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchEmails();
  }

  Future<void> fetchEmails() async {
    isLoading.value = true;
    final res = await _repo.getEmails();
    isLoading.value = false;
    if (res.isLoadSuccess && res.data != null) {
      emails.value = res.data;
    } else {
      Get.snackbar('Lỗi', res.message ?? 'Có lỗi xảy ra',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addEmail(String email) async {
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Lỗi', 'Email không đúng định dạng',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final res = await _repo.addEmail(email);
    if (res.isLoadSuccess) {
      // Get.back(); // Close dialog
      Get.snackbar('Thành công', 'Thêm email thành công',
          snackPosition: SnackPosition.BOTTOM);
      fetchEmails();
    } else {
      Get.snackbar('Lỗi', res.message ?? 'Thêm email thất bại',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteEmail(String id) async {
    final res = await _repo.deleteEmail(id);
    if (res.isLoadSuccess) {
      // Get.back();
      Get.snackbar('Thành công', 'Xóa email thành công',
          snackPosition: SnackPosition.BOTTOM);
      fetchEmails();
    } else {
      Get.snackbar('Lỗi', res.message ?? 'Xóa email thất bại',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

