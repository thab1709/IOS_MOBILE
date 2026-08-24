// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressHUD {
  static void show() {
    if (!Get.isDialogOpen) {
      Get.dialog(Center(
          child: Container(
              width: 70,
              height: 70,
              child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          )
      ), barrierDismissible: false);
    }

  }

  static void showAlway() {
      Get.dialog(Center(
          child: Container(
              width: 70,
              height: 70,
              child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          )
      ), barrierDismissible: false);
  }

  static void dismiss() {
   if (Get.isDialogOpen) {
     Get.back();
   }
  }
}

