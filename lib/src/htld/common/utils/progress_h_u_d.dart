// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressHUD {
  static bool _isShowingProgressHUD = false;
  static const String _progressHUDRouteName = '/progress_hud_loading';

  static void show() {
    if (!_isShowingProgressHUD) {
      _isShowingProgressHUD = true;
      Get.dialog(
        Center(
          child: Container(
            width: 70,
            height: 70,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        barrierDismissible: false,
        name: _progressHUDRouteName,
      ).then((_) {
        // Khi dialog bị đóng (bằng bất kỳ cách nào), reset flag
        _isShowingProgressHUD = false;
      });
    }
  }

  static void showAlway() {
    _isShowingProgressHUD = true;
    Get.dialog(
      Center(
        child: Container(
          width: 70,
          height: 70,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      barrierDismissible: false,
      name: _progressHUDRouteName,
    ).then((_) {
      _isShowingProgressHUD = false;
    });
  }

  static void dismiss() {
    if (_isShowingProgressHUD) {
      _isShowingProgressHUD = false;
      // Đóng dialog loading bằng cách tìm route có tên _progressHUDRouteName
      // Sử dụng Get.until để pop tất cả các route cho đến khi tìm thấy route cần đóng
      Get.until((route) {
        // Trả về true để dừng pop khi:
        // 1. Đã đóng được ProgressHUD (route trước đó là ProgressHUD)
        // 2. Hoặc đã về tới route đầu tiên (không tìm thấy ProgressHUD)
        final routeName = route.settings.name;
        return routeName != _progressHUDRouteName &&
            (route.isFirst ||
                routeName == null ||
                !routeName.contains('progress_hud'));
      });
    }
  }
}

