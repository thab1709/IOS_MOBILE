// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/single_int_drop_down.dart';
import 'package:evnmobile/src/qltnkd/common/components/single_string_dropdown.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:flutter/material.dart';

class DynamicDropDown extends StatelessWidget {
  const DynamicDropDown(
      {@required this.options,
      @required this.title,
      Key key,
      this.onSelected,
      this.value,
      this.isHasDefaultValue,
      this.parentMargin,
      this.isRequire = false,
      this.selectedValue})
      : super(key: key);

  final List<dynamic> options;
  final String selectedValue;
  final Function(String) onSelected;
  final dynamic value;
  final bool isHasDefaultValue;
  final String title;
  final bool isRequire;
  final EdgeInsets parentMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: parentMargin ?? const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_renderTitle(title), _buildDropdown()],
      ),
    );
  }

  Widget _buildDropdown() {
    if (options is List<StringOptionModel>) {
      return SingleStringDropDown(
        options,
        onSelected: onSelected,
        isRequire: isRequire,
        value: value is String ? value : null,
        isHasDefaultValue: isHasDefaultValue,
      );
    } else if (options is List<IntOptionModel>) {
      return SingleIntDropDown(
        options,
        onSelected: onSelected,
        value: value is int ? value : null,
        isHasDefaultValue: isHasDefaultValue,
      );
    } else {
      return Container();
    }
  }

  Widget _renderTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        if (isRequire)
        const Text(
          '*',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ],),
    );
  }
}

