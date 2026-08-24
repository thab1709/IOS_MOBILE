// @dart=2.9
import 'package:evnmobile/src/htld/models/notification_model.dart';
import 'package:evnmobile/src/htld/services/responsitory/notification_repository.dart';
import 'package:get/get.dart';

class NotificationManagerController extends GetxController {
  final NotificationRepository _repo = NotificationRepository();
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  /// Lấy số lượng notification chưa đọc
  Future<void> fetchUnreadCount() async {
    final res = await _repo.getUnreadCount();
    if (res.isLoadSuccess && res.data != null) {
      unreadCount.value = res.data;
    }
  }

  /// Lấy danh sách notification
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    final res = await _repo.getNotifications();
    isLoading.value = false;
    if (res.isLoadSuccess && res.data != null) {
      notifications.value = res.data;
    } else {
      Get.snackbar('Lỗi', res.message ?? 'Có lỗi xảy ra',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Refresh cả count và list
  Future<void> refreshAll() async {
    await Future.wait([
      fetchUnreadCount(),
      fetchNotifications(),
    ]);
  }
}

