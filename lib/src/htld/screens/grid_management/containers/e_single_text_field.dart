// @dart=2.9
import 'package:flutter/material.dart';

class ESingleTextField extends StatelessWidget {
  ESingleTextField({this.value, this.textAlign, this.isEnable = true, this.onchange, this.horizontalPaddingContent = 6});

  final String value;
  final TextAlign textAlign;
  final bool isEnable;
  final double horizontalPaddingContent;
  final TextEditingController controller = TextEditingController();

  final Function(String) onchange;

  @override
  Widget build(BuildContext context) {
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller?.text?.length ?? 0));
    controller.text = value ?? '';
    return TextField(
      enabled: isEnable,
      controller: controller,
      onChanged: onchange,
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: horizontalPaddingContent),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}
