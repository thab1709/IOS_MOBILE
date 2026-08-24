// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoHeightTextField extends StatefulWidget {
  AutoHeightTextField({this.textFieldController, this.maxHeight, this.hintText = '', this.isEnable = true, this.onChange, this.invalid = false}){
    textFieldController.selection = TextSelection.fromPosition(TextPosition(offset: textFieldController.text.length));
}
  TextEditingController textFieldController;
  double maxHeight;
  String hintText;
  bool isEnable;
  Function(String) onChange;
  bool invalid;
  @override
  State<AutoHeightTextField> createState() => _AutoHeightTextFieldState();
}

class _AutoHeightTextFieldState extends State<AutoHeightTextField> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
      ),
      child: TextField(
        autofocus: false,
        readOnly: !widget.isEnable,
        onChanged: (value) {
          if(widget.onChange != null) {
            widget.onChange(value);
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: widget.invalid? Colors.red:HighElectricAppColor.nature03),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: widget.invalid? Colors.red:HighElectricAppColor.nature03),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: widget.invalid? Colors.red:HighElectricAppColor.nature03),
          ),
        ),
        maxLines: null,
        controller: widget.textFieldController,
      ),
    );
  }
}

