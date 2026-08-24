// @dart=2.9
import 'package:evnmobile/src/htdct/common/themes/colorx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleTextField extends StatelessWidget {
  SingleTextField(
      {this.value,
      this.textAlign,
      this.isEnable = true,
      this.line = 1,
      this.onchange,
      this.isRequire = false,
      this.hintText,
      this.horizontalPaddingContent = 14});

  final String value;
  final TextAlign textAlign;
  final bool isEnable;
  final int line;
  final String hintText;
  final bool isRequire;

  final double horizontalPaddingContent;
  final TextEditingController controller = TextEditingController();

  final Function(String) onchange;

  @override
  Widget build(BuildContext context) {
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    controller.text = value ?? '';
    return TextField(
      enabled: isEnable,
      controller: controller,
      onChanged: onchange,
      textAlign: textAlign ?? TextAlign.start,
      minLines: line,
      style: const TextStyle(fontSize: 16),
      maxLines: line,
      cursorColor: AppColor.highlightColor70,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: !(isEnable ?? true),
        hintText: hintText ?? '',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 14, horizontal: horizontalPaddingContent),
        enabledBorder: isEnable
            ? OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ) : null,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.highlightColor70),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
    );
  }
}

