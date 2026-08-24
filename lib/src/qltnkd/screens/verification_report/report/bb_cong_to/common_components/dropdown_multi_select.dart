// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../../models/option_model.dart';

class _SelectRow extends StatefulWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;
  final Function() onEditingComplete;
  final bool isLast;

  const _SelectRow(
      {Key key,
      this.onChange,
      this.selected,
      this.onEditingComplete,
      this.isLast,
      this.text})
      : super(key: key);

  @override
  State<_SelectRow> createState() => _SelectRowState();
}

class _SelectRowState extends State<_SelectRow> {
  @override
  void dispose() {
    if (widget.isLast) {
      widget.onEditingComplete();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _valueCheck = widget.selected;
    return Row(
      children: [
        StatefulBuilder(builder: (context, setState) {
          return Checkbox(
              value: _valueCheck,
              onChanged: (value) {
                widget.onChange(value);
                setState(() {
                  _valueCheck = !_valueCheck;
                });
              });
        }),
        Expanded(child: Text(widget.text))
      ],
    );
  }
}

class DropDownMultiSelectCongTo extends StatefulWidget {
  final String values;
  final bool enable;
  final bool isRefresh;
  final bool isRequire;
  final List<StringOptionModel> listOption;
  final FocusNode focusNode;
  final Function clearFocus;
  final Function onEditingComplete;

  final Function(String) onChange;

  const DropDownMultiSelectCongTo(
      {@required this.listOption,
      @required this.onChange,
      @required this.values,
      @required this.focusNode,
      @required this.clearFocus,
      @required this.onEditingComplete,
      this.enable = true,
      this.isRefresh = false,
      this.isRequire = false,
      Key key})
      : super(key: key);

  @override
  _DropDownMultiSelectState createState() => _DropDownMultiSelectState();
}

class _DropDownMultiSelectState extends State<DropDownMultiSelectCongTo> {
  final List<String> selectedValues = [];

  final _dropdownKey = GlobalKey();

  var isShow = false;

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
    selectedValues
        .addAll(widget.values == null ? [] : widget.values.split(',').toList());
  }

  @override
  Widget build(BuildContext context) {
    final selectedTitle = <String>[];
    widget.listOption.forEach((element) {
      if (selectedValues.contains(element.value)) {
        selectedTitle.add(element.title);
      }
    });
    return Container(
      height: 100,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Text(
                  selectedValues.isNotEmpty
                      ? selectedTitle.reduce((a, b) => '$a , $b')
                      : '' ?? '',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(
                      color: selectedValues.isEmpty &&
                              widget.isRefresh &&
                              widget.isRequire == true
                          ? Colors.red
                          : Colors.grey)),
              child: Focus(
                focusNode: widget.focusNode,
                onFocusChange: (val) {
                  if (val && !isShow) {
                    isShow = true;
                    widget.focusNode.unfocus();
                    if (widget.clearFocus != null) widget.clearFocus();
                    openDropdown();
                  }
                },
                child: DropdownButtonFormField<String>(
                  key: _dropdownKey,
                  onTap: () {
                    if (widget.clearFocus != null) widget.clearFocus();
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 8,
                    ),
                  ),
                  isDense: true,
                  onChanged: widget.enable ? (x) {} : null,
                  value: null,
                  selectedItemBuilder: (context) {
                    return widget.listOption
                        .map((e) => DropdownMenuItem(
                              child: Container(),
                            ))
                        .toList();
                  },
                  items: items(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> items() {
    return widget.listOption
        .mapIndexed((x, i) => DropdownMenuItem(
      value: x.value,
      onTap: () {
        if (selectedValues.contains(x.value)) {
          final ns = selectedValues;
          ns.remove(x.value);
          widget.onChange(ns.reduce((a, b) => '$a,$b'));
        } else {
          final ns = selectedValues;
          ns.add(x.value);
          widget.onChange(ns.reduce((a, b) => '$a,$b'));
        }
        setState(() {});
      },
      child: _SelectRow(
          selected: selectedValues.contains(x.value),
          text: x.title,
          isLast: i == widget.listOption.length - 1,
          onEditingComplete: () {
            if (widget.onEditingComplete != null) {
              isShow = false;
              widget.onEditingComplete();
            }
          },
          onChange: (isSelected) {
            if (isSelected) {
              final ns = selectedValues;
              ns.add(x.value);
              widget
                  .onChange(ns.reduce((a, b) => '$a,$b'));
            } else {
              final ns = selectedValues;
              ns.remove(x.value);
              widget
                  .onChange(ns.reduce((a, b) => '$a,$b'));
            }
            setState(() {});
          }),
    ))
        .toList();
  }
}

