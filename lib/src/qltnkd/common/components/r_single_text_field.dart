// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RSingleTextField extends StatefulWidget {
  final String value;
  final TextAlign textAlign;
  final bool isEnable;
  final int line;
  final Function(String) onchange;
  final bool isRequire;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController textController;
  final double horizontalPaddingContent;

  const RSingleTextField({
    this.value,
    this.textAlign,
    this.isEnable = true,
    this.line = 1,
    this.onchange,
    this.isRequire = false,
    this.hintText,
    this.keyboardType,
    this.textController,
    this.horizontalPaddingContent = 14,
    Key key,
  }) : super(key: key);

  @override
  _RSingleTextFieldState createState() => _RSingleTextFieldState();
}

class _RSingleTextFieldState extends State<RSingleTextField> {
  TextEditingController _internalController;

  TextEditingController get _controller => widget.textController ?? _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.textController == null) {
      _internalController = TextEditingController(text: widget.value ?? '');
    }
  }

  @override
  void didUpdateWidget(RSingleTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textController == null) {
      if (oldWidget.value != widget.value) {
        if (_internalController.text != widget.value) {
          _internalController.text = widget.value ?? '';
          _internalController.selection = TextSelection.fromPosition(
              TextPosition(offset: _internalController.text.length));
        }
      }
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isEnable,
      controller: _controller,
      onChanged: widget.onchange,
      textAlign: widget.textAlign ?? TextAlign.start,
      minLines: widget.line,
      style: const TextStyle(fontSize: 16),
      maxLines: widget.line,
      keyboardType: widget.keyboardType,
      cursorColor: RAppColor.highlightColor70,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: !(widget.isEnable ?? true),
        hintText: widget.hintText ?? '',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 14, horizontal: widget.horizontalPaddingContent),
        enabledBorder: widget.isEnable
            ? OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ) : null,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: RAppColor.highlightColor70),
        ),
        border: widget.isEnable
            ? OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300))
            : null,
      ),
    );
  }
}
