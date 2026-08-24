// @dart=2.9
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constance/strings.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  E get firstOrNull => isEmpty ? null : first;

  E firstWhereOrNull(bool Function(E element) test) {
    final list = firstWhere(test, orElse: () => null);
    return list;
  }
}

extension StringExtensions on String {
  String toStringFormat(String format) {
    final _date = DateFormat(RAppStrings.ddMMyyyy).parse(this);
    return DateFormat(format).format(_date);
  }

  DateTime toDateFormatLocal() {
    try {
      return DateFormat(RAppStrings.utcFormat).parse(this, true).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }

  String fromFormatToFormat(String fromFormat, String toFormat) {
    try {
      final _date = DateFormat(fromFormat).parse(this);
      return DateFormat(toFormat).format(_date);
    } catch (_) {
      debugPrint(_.toString());
      return '';
    }
  }

  bool isNotNullOrEmpty() {
    return isNotEmpty == true;
  }

  bool isNullOrEmpty() {
    return this == null || isEmpty;
  }

  String fromFormatUtcToFormatLocal(String toFormat) {
    try {
      final _date = DateFormat(RAppStrings.utcFormat).parse(this, true).toLocal();
      return DateFormat(toFormat).format(_date);
    } catch (_) {
      return '';
    }
  }
  String fromFormatUtcToFormatLocalNotZ(String toFormat) {
    try {
      final _date = DateFormat(RAppStrings.yyyyMMddTHHmmss).parse(this, true).toLocal();
      return DateFormat(toFormat).format(_date);
    } catch (_) {
      return '';
    }
  }

  String fromFormatUTCToFormat(String fromFormat, String toFormat) {
    try {
      final _date = DateFormat(fromFormat).parse(this, true).toLocal();
      return DateFormat(toFormat).format(_date);
    } catch (error) {
      return '';
    }
  }

  String fromFormatServerToFormat(String format) {
    final _date = DateFormat(RAppStrings.utcFormat).parse(this);
    return DateFormat(format).format(_date);
  }

  String fromDatePickerToServerFormat() {
    return fromFormatToFormat(RAppStrings.hhmmddMMyyyy, RAppStrings.utcFormat);
  }

  dynamic toIntOrNull() {
    try{
      return int.parse(this);
    } catch (_) {
      return null;
    }
  }

  double toDoubleOrNull() {
    try{
      return double.parse(this);
    } catch (_) {
      return null;
    }
  }

  double parseDouble() {
    return double.parse(this);
  }
}

extension DateTimeExtensions on DateTime {
  String toStringFormat(String format, {bool isUtc = false}) {
    return isUtc
        ? '${DateFormat(format).format(toUtc())}Z'
        : DateFormat(format).format(this);
  }

  String formatFirstDate() {
    final date = this;
    final dateEdit = DateTime(date.year, date.month, date.day);
    return DateFormat(RAppStrings.planDate).format(dateEdit);
  }

  String formatSecondDate() {
    final date = this;
    final dateEdit = DateTime(date.year, date.month, date.day);
    return DateFormat(RAppStrings.planDate).format(dateEdit);
  }

  String toUTC() {
    final time = this;
    final value = DateFormat(RAppStrings.planDate).format(time);
    return value;
  }
}

extension IntExt on int {
  // [Localization(nameof(EvnResources.MSG_EQUIPMENTSTATUS_X5_GOOD), typeof(EvnResources))]
  // Good = 1,//Tốt
  // [Localization(nameof(EvnResources.MSG_EQUIPMENTSTATUS_X5_BROKEN), typeof(EvnResources))]
  // Broken = 2, // Hỏng
  // [Localization(nameof(EvnResources.MSG_EQUIPMENTSTATUS_X5_FAIL), typeof(EvnResources))]
  // Fail = 3, // Lỗi
  // [Localization(nameof(EvnResources.MSG_EQUIPMENTSTATUS_X5_NUMBERWRONG), typeof(EvnResources))]
  // NumberWrong = 4, // Sai số
  // [Localization(nameof(EvnResources.MSG_EQUIPMENTSTATUS_X5_OLD), typeof(EvnResources))]
  // Old = 5, // Lạc hậu

 String getStatus() {
    switch(this) {
      case 1: return 'Tốt';
      case 2: return 'Hỏng';
      case 3: return 'Lỗi';
      case 4: return 'Sai số';
      case 5: return 'Lạc hậu';
      default: return '';
  }
  }


}

