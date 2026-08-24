// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/r_single_text_field.dart';
import 'package:flutter/material.dart';

class RTextField extends StatefulWidget {
  const RTextField({
    this.title = '',
    this.value,
    this.margin,
    this.onChange,
    this.line = 1,
    this.hintText,
    this.isRequire = false,
    this.isEnable = true,
    this.keyboardType,
    this.textController,
    Key key,
  }) : super(key: key);

  final String title;
  final String value;
  final bool isEnable;
  final bool isRequire;
  final int line;
  final String hintText;
  final EdgeInsets margin;
  final TextInputType keyboardType;
  final Function(String) onChange;
  final TextEditingController textController;


  @override
  _RTextFieldState createState() => _RTextFieldState();
}

class _RTextFieldState extends State<RTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderTitle(widget.title),
          RSingleTextField(
            value: widget.value ?? '',
            isEnable: widget.isEnable,
            onchange: widget.onChange,
            isRequire: widget.isRequire,
            hintText: widget.hintText,
            line: widget.line,
            keyboardType: widget.keyboardType,
            textController: widget.textController,
          ),
        ],
      ),
    );
  }

  Widget _renderTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        if (widget.isRequire)
          const Text(
            '*',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
      ],),
    );
  }
}

