// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/global_app.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SnackBarHUD {
  static void show(String message) {
    if (Get.context != null) {
      Get.rawSnackbar(
        message: message,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }
}

