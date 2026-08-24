// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';

class _SelectRow extends StatefulWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;
  final Function() onEditingComplete;
  final bool isLast;

  const _SelectRow({
    Key key,
    this.onChange,
    this.selected,
    this.onEditingComplete,
    this.isLast,
    this.text,
  }) : super(key: key);

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
        StatefulBuilder(
          builder: (context, setState) {
            return Checkbox(
              value: _valueCheck,
              onChanged: (value) {
                widget.onChange(value);
                setState(() {
                  _valueCheck = !_valueCheck;
                });
              },
            );
          },
        ),
        Text(widget.text)
      ],
    );
  }
}

///
/// A Dropdown multiselect menu
///
///
class DropDownMultiSelect extends StatefulWidget {
  /// defines whether the widget is enabled;
  final bool enabled;

  final FieldModel fieldModel;
  final Function() onEditingComplete;
  final bool isEdit;

  const DropDownMultiSelect({
    Key key,
    this.fieldModel,
    this.enabled = true,
    this.onEditingComplete,
    this.isEdit = false,
  }) : super(key: key);

  @override
  _DropDownMultiSelectState createState() => _DropDownMultiSelectState();
}

class _DropDownMultiSelectState extends State<DropDownMultiSelect> {
  final GlobalKey _dropdownButtonKey = GlobalKey();

  void openDropdown() {
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

    searchForGestureDetector(_dropdownButtonKey.currentContext);

    detector.onTap();
  }

  @override
  Widget build(BuildContext context) {
    var selectedValues = widget.fieldModel.value == null
        ? []
        : widget.fieldModel.value.split(',').toList();

    if (widget.fieldModel.isFieldTester() && widget.enabled) {
      if (!widget.isEdit || widget.fieldModel.value.isNullOrEmpty()) {
        widget.fieldModel.additionalData.options.forEach((option) {
          option.isSelected = true;
        });

        selectedValues = widget.fieldModel.additionalData.options
            .map((e) => e.value)
            .toList();
        widget.fieldModel.value = selectedValues.map((e) => e).join(',');
      } else {
        final listSelected = widget.fieldModel.value.split(',');
        widget.fieldModel.additionalData.options.forEach((option) {
          option.isSelected = listSelected.contains(option.value);
        });
      }
    }

    final selectedTitle = <String>[];
    widget.fieldModel.additionalData.options.forEach((element) {
      if (selectedValues.contains(element.value)) {
        selectedTitle.add(element.title);
      }
    });
    return Container(
      height: 100,
      child: Focus(
        focusNode: widget?.fieldModel?.focusNode,
        onFocusChange: (val) {
          if (val) {
            widget?.fieldModel?.focusNode?.unfocus();
            FocusScope.of(context).requestFocus(FocusNode());
            openDropdown();
          }
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: widget.enabled ? Colors.white : Colors.grey.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButtonFormField<String>(
                  key: _dropdownButtonKey,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
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
                  onChanged: widget.enabled ? (x) {} : null,
                  value: null,
                  selectedItemBuilder: (context) {
                    return widget.fieldModel.additionalData.options
                        .map((e) => DropdownMenuItem(
                              child: Container(),
                            ))
                        .toList();
                  },
                  items: widget.fieldModel.additionalData.options
                      .mapIndexed((x, i) => DropdownMenuItem(
                            value: x.value,
                            onTap: () {
                              if (selectedValues.contains(x.value)) {
                                final ns = selectedValues;
                                ns.remove(x.value);
                                widget.fieldModel.value =
                                    ns.reduce((a, b) => '$a,$b');
                              } else {
                                final ns = selectedValues;
                                ns.add(x.value);
                                widget.fieldModel.value =
                                    ns.reduce((a, b) => '$a,$b');
                              }
                              setState(() {});
                            },
                            child: _SelectRow(
                              selected: selectedValues.contains(x.value),
                              text: x.title,
                              isLast: i ==
                                  widget.fieldModel.additionalData.options
                                          .length -
                                      1,
                              onEditingComplete: () {
                                if (widget.onEditingComplete != null) {
                                  widget.onEditingComplete();
                                }
                              },
                              onChange: (isSelected) {
                                widget.fieldModel.additionalData.options[i]
                                    .isSelected = isSelected;
                                if (isSelected) {
                                  final ns = selectedValues;
                                  ns.add(x.value);
                                  widget.fieldModel.value =
                                      ns.reduce((a, b) => '$a,$b');
                                } else {
                                  final ns = selectedValues;
                                  ns.remove(x.value);
                                  widget.fieldModel.value =
                                      ns.reduce((a, b) => '$a,$b');
                                }
                                setState(() {});
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                openDropdown();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Text(
                    selectedValues.isNotEmpty
                        ? selectedTitle.reduce((a, b) => '$a , $b')
                        : 'Vui lòng chọn' ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

