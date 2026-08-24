// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isNullOrEmpty()) {
      return newValue;
    }

    final indexFirst = text.indexOf('.');
    if (indexFirst >= 0 && indexFirst < text.length - 1) {
      final indexLast = text.indexOf('.', indexFirst + 1);
      if (indexLast > 0) return oldValue;
    }

    final indexFirstSigned = text.indexOf('-');
    if (indexFirstSigned >0 && indexFirstSigned !=0) {
      return oldValue;
    }

    final regEx = RegExp(r'^\d*\.?\-?\d*');
    final newString = regEx.stringMatch(newValue.text) ?? '';
    if (newString.isNullOrEmpty()) {
      return oldValue;
    }

    if (indexFirst >= 0 && text.length - indexFirst > 3) {
      return oldValue;
    }
    return newValue;
  }
}

