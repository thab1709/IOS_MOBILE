// @dart=2.9
import 'package:flutter/material.dart';

import '../../../../../../common/constance/app_color.dart';

class TextFormFieldMulti extends StatefulWidget {
  const TextFormFieldMulti({this.formKey});
  final formKey;
  @override
  State<TextFormFieldMulti> createState() => _TextFormFieldMultiState();
}

class _TextFormFieldMultiState extends State<TextFormFieldMulti> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        height: 80,
        child: TextFormField(
            maxLines: null,
            expands: true, // allow user to enter 5 line in textfield
            keyboardType: TextInputType.multiline,
            key: widget.formKey,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: HighElectricAppColor.borderColor1),
                ),
                hintText: 'Nhập thông tin'
            )// user keyboard will have a button to move cursor to next line
        )
    );
  }
}


