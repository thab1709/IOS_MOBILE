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
    final _date = DateFormat(HighElectricStrings.ddMMyyyy).parse(this);
    return DateFormat(format).format(_date);
  }

  DateTime toDateFormatLocal({String format = HighElectricStrings.utcFormat}) {
    try{
      return  DateFormat(format).parse(this, true).toLocal();
    } catch (_){
      return DateTime.now();
    }
  }

  DateTime toDate({String format = HighElectricStrings.ddMMyyyy}) {
    try {
      return DateFormat(format).parse(this, false);
    } catch (_) {
      return null;
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
    if(contains('0001-01-01T')){
      return '';
    }

    if(this?.isNotEmpty == true) {
      final _date = DateFormat(HighElectricStrings.utcFormat).parse(this, true).toLocal();
      return DateFormat(toFormat).format(_date);
    }
    return '';
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
    final _date = DateFormat(HighElectricStrings.utcFormat).parse(this);
    return DateFormat(format).format(_date);
  }

  String fromDatePickerToServerFormat() {
    return fromFormatToFormat(HighElectricStrings.hhmmyyyyMMdd, HighElectricStrings.utcFormat);
  }

  int parseInt() {
    final value = int.parse(this);
    return value ?? -1;
  }
  double parseDouble() {
    return double.parse(this);
  }

  bool isNullOrEmpty() {
    return this == null || isEmpty;
  }

  bool isNullOrBlank() {
    return this == null || trim().isEmpty;
  }

  dynamic toIntOrNull() {
    try {
      return int.parse(this);
    } catch (_) {
      return null;
    }
  }

  dynamic toDoubleOrNull() {
    try {
      return double.parse(this);
    } catch (_) {
      return null;
    }
  }
}

extension DateTimeExtensions on DateTime {
  String toStringFormat (String format, {bool isUtc = false}){
    return isUtc ? '${DateFormat(format).format(toUtc())}Z' : DateFormat(format).format(this);
  }

  String formatFirstDate() {
    final date = this;
    final dateEdit = DateTime(date.year, date.month, date.day);
    return '${DateFormat(HighElectricStrings.planDate).format(dateEdit)}Z';
  }

  String formatSecondDate() {
    final date = this;
    final dateEdit = DateTime(date.year, date.month, date.day);
    return '${DateFormat(HighElectricStrings.planDate).format(dateEdit)}';
  }

  String toUTC() {
    final time = this;
    final value = DateFormat(HighElectricStrings.planDate).format(time);
    return value;
  }
  double toDouble() {
    final time = this;
    final _dateString = (DateFormat('yyyy-MM-dd')
        .format(time)).toString().replaceAll('-', '');
    return double.parse(_dateString);
  }
}

