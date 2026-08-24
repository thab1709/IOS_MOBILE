// @dart=2.9
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:flutter/material.dart';

import '../../../../../common/themes/colorx.dart';

class CustomDropDownMeter extends StatefulWidget {
  const CustomDropDownMeter(
      {@required this.value,
      @required this.listOption,
      @required this.onChange,
      @required this.isRefresh,
      @required this.focusNode,
      @required this.clearFocus,
      this.isRequire = false,
      this.enable = true,
      Key key})
      : super(key: key);

  final String value;
  final bool enable;
  final bool isRefresh;
  final bool isRequire;
  final FocusNode focusNode;
  final List<StringOptionModel> listOption;

  final Function(String) onChange;
  final Function clearFocus;

  @override
  State<CustomDropDownMeter> createState() => _CustomDropDownMeterState();
}

class _CustomDropDownMeterState extends State<CustomDropDownMeter> {
  String value;

  final _dropdownKey = GlobalKey();

  void openDropdown() {
    try {
      GestureDetector detector;
      void searchForGestureDetector(BuildContext element) {
        element.visitChildElements((element) {
          if (element.widget != null && element.widget is GestureDetector) {
            detector = element.widget;
          } else {
            searchForGestureDetector(element);
          }
        });
      }

      searchForGestureDetector(_dropdownKey.currentContext);
      detector.onTap();
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomDropDownMeter oldWidget) {
    if (oldWidget.value != widget.value) {
      value = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: widget.enable ? Colors.white : Colors.grey.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                    color: widget.isRequire == true &&
                            widget.isRefresh == true &&
                            (value == null || value.isEmpty)
                        ? Colors.red
                        : Colors.grey)),
            child: Focus(
              focusNode: widget.focusNode,
              onFocusChange: (val) {
                if (val) {
                  widget.focusNode.unfocus();
                  if (widget.clearFocus != null) widget.clearFocus();
                  openDropdown();
                }
              },
              child: DropdownButton(
                isExpanded: true,
                key: _dropdownKey,
                underline: Container(),
                elevation: 1,
                onTap: () {
                  if (widget.clearFocus != null) widget.clearFocus();
                },
                value: value,
                onChanged: (val) {
                  widget.onChange(val);
                  setState(() {
                    value = val;
                  });
                },
                items: widget.listOption.map((e) {
                  return DropdownMenuItem(
                      value: e.value,
                      child: Text(
                        e.title,
                        style: TextStyle(
                            fontSize: 16,
                            color: widget.value == e.value && widget.enable
                                ? RAppColor.highlightColor70
                                : Colors.black,
                            fontWeight: widget.value == e.value
                                ? FontWeight.w500
                                : FontWeight.normal),
                      ));
                })?.toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

