// @dart=2.9

import 'dart:ui';

import 'package:evnmobile/src/htld/common/themes/colorx.dart';

import '../../models/option_model.dart';

class AbnormalStatus{
  static const notImplement = 1;
  static const implementing = 2;

  static String getName(int status) {
    switch(status) {
      case notImplement: return 'Chưa xử lý';
      case implementing: return 'Đã xử lý';
    }
    return '';
  }

  static Color getColor(int status) {
    switch(status) {
      case notImplement: return AppColor.redStatus;
      case implementing: return AppColor.greenColor;
    }
    return AppColor.redStatus;
  }

 static List<OptionModelString> listStatus = [
    OptionModelString('Chưa xử lý', AbnormalStatus.notImplement.toString()),
    OptionModelString('Đã xử lý', AbnormalStatus.implementing.toString()),
  ];
}

class TTypeItem {

  static const textBox = 1;
  static const singleDropdown = 2;
  static const multiDropdown = 3;
  static const textArea = 4;
  static const checkbox = 5;
  static const timePicker = 6;
  static const images = 7;
  static const datePicker = 8;
  static const periodTime = 9;

  // static const numberSingleDropdown = 10;
  static const title = 11;
  static const dateTimePicker = 12;
}

