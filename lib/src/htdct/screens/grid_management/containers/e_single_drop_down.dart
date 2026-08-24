// @dart=2.9
import 'package:evnmobile/src/htdct/common/themes/colorx.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/transformer_ticket_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constance/app_color.dart';
import '../../../models/option_model.dart';

class ESingleDropDown extends StatelessWidget {
  ESingleDropDown(this.options,
      {this.padding,
      this.contentHorizontalPadding,
      this.onSelected,
      this.isHasDefaultValue = false,
      this.hint,
      this.value,
      this.invalid = false,
      this.isInTicket = true,
      this.keyDropdown,
      this.isDisable = false,
      this.hasTransformerTicketController=true});

  final List<OptionModel> options;
  int selectedValue;
  final double padding;
  final double contentHorizontalPadding;
  Function(String) onSelected;
  final int value;
  final bool isHasDefaultValue;
  bool isDisable;
  final bool invalid;
  final bool isInTicket;
  final GlobalKey<FormFieldState> keyDropdown;
  String hint;
  bool isHasTransformerTicketController = Get.isRegistered<TransformerTicketController>();
  TransformerTicketController transformerTicketController;
  final bool hasTransformerTicketController;

  @override
  Widget build(BuildContext context) {
    selectedValue = value;

    if(isInTicket) {
      if(isHasTransformerTicketController && !isDisable && hasTransformerTicketController) {
        transformerTicketController = Get.find();
        isDisable = !transformerTicketController.isHasPermissionEdit();
      }
    }


    if (isHasDefaultValue && options?.isNotEmpty == true) {
      selectedValue = options.first.value;
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(padding ?? 4),
      child: DropdownButtonFormField(
        value: selectedValue,
        key: keyDropdown,
        isExpanded: true,
        itemHeight: 60,
        decoration: InputDecoration(
            hintText: hint ?? '',
            hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: HighElectricAppColor.nature04),
            isDense: true,
            fillColor: isDisable ? Colors.grey.shade100 : Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
                vertical: 12, horizontal: contentHorizontalPadding ?? 12),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: selectedValue == null && invalid
                      ? Colors.red.shade700
                      : Colors.grey.shade300,
                  width: 1),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            )),
        elevation: 1,
        onChanged: isDisable
            ? null
            : (object) {
                onSelected(object.toString());
              },
        items: options.map((e) {
          return DropdownMenuItem(value: e.value, child: Text(e.title));
        }).toList(),
      ),
    );
  }
}

class ESingleDropDownString extends StatelessWidget {

  ESingleDropDownString(this.options,
      {this.padding,
      this.contentHorizontalPadding,
      this.onSelected,
      this.isHasDefaultValue = false,
      this.hint,
      this.invalid = true,
      this.value,
      this.isDisable = false,
      this.keyDropdown});

  final List<OptionModelString> options;
  String selectedValue;
  bool isDisable;
  final double padding;
  final double contentHorizontalPadding;
  Function(String) onSelected;
  final String value;
  final bool invalid;
  final bool isHasDefaultValue;
  final GlobalKey<FormFieldState> keyDropdown;
  String hint;
  @override
  Widget build(BuildContext context) {
    selectedValue = value;

    if (isHasDefaultValue && options?.isNotEmpty == true && value == null) {
      selectedValue = options.first.value;
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(padding ?? 4),
      child: DropdownButtonFormField(
        key: keyDropdown,
        value: selectedValue,
        isExpanded: true,
        itemHeight: 60,
        decoration: InputDecoration(
            hintText: hint ?? '',
            fillColor: Colors.white,
            filled: true,
            isDense: false,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: selectedValue == null && invalid
                      ? Colors.red.shade700
                      : Colors.grey.shade300,
                  width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: 12, horizontal: contentHorizontalPadding ?? 12),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            )),
        elevation: 1,
        onChanged: isDisable
            ? null
            : (object) {
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
  const E2SingleDropDown(this.options,
      {this.padding,
      this.contentHorizontalPadding,
      this.onSelected,
      this.value,
      this.hint,
      this.title,
      this.childFlex});

  final List<UserOptionModel> options;
  final String title;
  final String hint;
  final double padding;
  final double contentHorizontalPadding;
  final Function(String) onSelected;
  final String value;
  final int childFlex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(padding ?? 4),
      child: Row(
        children: [
          if (title != null) Expanded(child: Text(title)),
          if (title != null)
            const SizedBox(
              width: 24,
            ),
          Expanded(
            flex: childFlex ?? 1,
            child: DropdownButtonFormField(
              value: value?.isNotEmpty == true ? value : null,
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
                const active = TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87);
                const inactive = TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColor.highlightColor70);
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

