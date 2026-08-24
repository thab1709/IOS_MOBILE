// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/single_text_field.dart';
import 'package:flutter/material.dart';

class ETextField extends StatefulWidget {
  const ETextField({
    this.title = '',
    this.value,
    this.margin,
    this.onChange,
    this.line = 1,
    this.hintText,
    this.isRequire = false,
    this.isEnable = true,

    Key key,
  }) : super(key: key);

  final String title;
  final String value;
  final bool isEnable;
  final bool isRequire;
  final int line;
  final String hintText;
  final EdgeInsets margin;
  final Function(String) onChange;

  @override
  _ETextFieldState createState() => _ETextFieldState();
}

class _ETextFieldState extends State<ETextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderTitle(widget.title),
          SingleTextField(
            value: widget.value ?? '',
            isEnable: widget.isEnable,
            onchange: widget.onChange,
            isRequire: widget.isRequire,
            hintText: widget.hintText,
            line: widget.line,
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
          style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400),
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

