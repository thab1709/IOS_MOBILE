// @dart=2.9
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:flutter/material.dart';

import '../../../models/option_model.dart';

class ESingleDropDown extends StatelessWidget {
  ESingleDropDown(this.options,
      {this.padding,
      this.contentHorizontalPadding,
      this.onSelected,
      this.isHasDefaultValue = false,
        this.hint,
      this.value});

  final List<OptionModel> options;
  int selectedValue;
  final double padding;
  final double contentHorizontalPadding;
  Function(String) onSelected;
  final int value;
  final bool isHasDefaultValue;
  String hint;
  @override
  Widget build(BuildContext context) {
    selectedValue = value;

    if (isHasDefaultValue && options?.isNotEmpty == true) {
      selectedValue = options.first.value;
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(padding ?? 4),
      child: DropdownButtonFormField(
        value: selectedValue,
        isExpanded: true,
        itemHeight: 60,
        decoration: InputDecoration(
          hintText: hint ?? '',
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: 12, horizontal: contentHorizontalPadding ?? 12),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            )),
        elevation: 1,
        onChanged: (object) {
          onSelected(object.toString());
        },
        items: options.map((e) {
          return DropdownMenuItem(value: e.value, child: Text(e.title));
        }).toList(),
      ),
    );
  }
}

class E2SingleDropDown extends StatelessWidget {
  E2SingleDropDown(this.options,
      {this.padding,
      this.contentHorizontalPadding,
      this.onSelected,
      this.isHasDefaultValue = false,
      this.value,
      this.hint,
      this.title,
      this.childFlex});

  final List<UserOptionModel> options;
  String selectedValue;
  final String title;
  final String hint;
  final double padding;
  final double contentHorizontalPadding;
  Function(String) onSelected;
  final String value;
  final bool isHasDefaultValue;
  final int childFlex;

  @override
  Widget build(BuildContext context) {
    selectedValue = value;

    if (isHasDefaultValue && options?.isNotEmpty == true) {
      selectedValue = options.first.value.toString();
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(padding ?? 4),
      child: Row(
        children: [
          if (title != null) Expanded(child: Text(title)),
          if (title != null) const SizedBox(width: 24,),
          Expanded(
            flex: childFlex ?? 1,
            child: DropdownButtonFormField(
              value: selectedValue,
              isExpanded: true,
              itemHeight: 60,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: hint,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 12, horizontal: contentHorizontalPadding ?? 12),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
              elevation: 1,
              onChanged: onSelected ?? (object) {},
              items: options.map((e) {
                const active = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87);
                const inactive = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColor.highlightColor70);
                return DropdownMenuItem(
                  value: e.value,
                  child: Text(
                    e.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: e.isSelected ? inactive : active,
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

