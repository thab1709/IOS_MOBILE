// @dart=2.9
import 'package:evnmobile/src/htdct/common/utils/global_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarHUD {
  static void show(String message) {
    final context = Get.context;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 1),));
  }
}

