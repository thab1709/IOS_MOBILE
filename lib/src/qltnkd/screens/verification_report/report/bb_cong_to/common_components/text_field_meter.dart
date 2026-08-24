// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldMeter extends StatefulWidget {
  const CustomTextFieldMeter(
      {@required this.isRefresh,
      @required this.value,
      this.isRequire = false,
      this.enable = true,
      this.isOnlyInputNumber = false,
      this.onValueChange,
      this.onIconTaped,
      this.icon,
      this.focusNode,
      this.line = 1,
      Key key})
      : super(key: key);

  final bool enable;
  final bool isOnlyInputNumber;
  final int line;
  final bool isRequire;
  final bool isRefresh;
  final Icon icon;
  final String value;
  final Function(String) onValueChange;
  final Function() onIconTaped;
  final FocusNode focusNode;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFieldMeter> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomTextFieldMeter oldWidget) {
    if (oldWidget.value != widget.value) {
      controller.text = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller?.text?.length ?? 0));
    return Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: widget.enable ? Colors.white : Colors.grey.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(
                color: widget.isRequire == true &&
                        widget.isRefresh &&
                        (widget.value == null || widget.value.isEmpty)
                    ? Colors.red
                    : Colors.grey)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: widget.line,
                focusNode: widget.focusNode,
                readOnly: !widget.enable,
                minLines: widget.line,
                onChanged: (text) {
                  if (widget.onValueChange != null) {
                    widget.onValueChange(text);
                  }
                },
                keyboardType: widget.isOnlyInputNumber
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.text,
                inputFormatters: [
                  if (widget.isOnlyInputNumber)
                    FilteringTextInputFormatter.allow(RegExp(r'[\d+\.]')),
                ],
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  suffixIcon: widget.icon != null
                      ? IconButton(
                          onPressed: widget.onIconTaped,
                          icon: widget.icon,
                        )
                      : null,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                ),
              ),
            ),
          ],
        ));
  }
}

