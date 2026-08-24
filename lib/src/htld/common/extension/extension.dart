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
}

extension StringExtensions on String {
  String toStringFormat(String format) {
    final _date = DateFormat(AppStrings.ddMMyyyy).parse(this);
    return DateFormat(format).format(_date);
  }

  DateTime toDateFormatLocal({String format = AppStrings.utcFormat}) {
    try{
      return  DateFormat(format).parse(this, true).toLocal();
    } catch (_){
      return DateTime.now();
    }
  }

  String fromFormatToFormat(String fromFormat, String toFormat) {
    try {
      final _date = DateFormat(fromFormat).parse(this);
      return DateFormat(toFormat).format(_date);
    } catch(_) {
      debugPrint(_.toString());
      return '';
    }

  }

  String fromFormatUtcToFormatLocal(String toFormat) {
    final _date = DateFormat(AppStrings.utcFormat).parse(this, true).toLocal();
    return DateFormat(toFormat).format(_date);
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
    final _date = DateFormat(AppStrings.utcFormat).parse(this);
    return DateFormat(format).format(_date);
  }

  String fromDatePickerToServerFormat() {
    return fromFormatToFormat(AppStrings.hhmmyyyyMMdd, AppStrings.utcFormat);
  }

  int parseInt() {
    final value = int.parse(this);
    return value ?? -1;
  }
  double parseDouble() {
    return double.parse(this);
  }
}

extension DateTimeExtensions on DateTime {
  String toStringFormat (String format, {bool isUtc = false}){
    return isUtc ? '${DateFormat(format).format(toUtc())}Z' : DateFormat(format).format(this);
  }

  String formatFirstDate() {
    final date = this;
    final dateEdit = DateTime(date.year, date.month, date.day - 1, 17, 1);
    return '${DateFormat(AppStrings.planDate).format(dateEdit)}Z';
  }

  String formatSecondDate() {
    final date = this;
    final dateEdit = DateTime(date.year, date.month, date.day, 16, 59);
    return '${DateFormat(AppStrings.planDate).format(dateEdit)}';
  }

  String toUTC() {
    final time = this;
    final value = DateFormat(AppStrings.planDate).format(time);
    return value;
  }
}
