// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constance/app_color.dart';
import '../../../common/themes/styles.dart';
import '../../../models/option_model.dart';
import '../transformer/transformer_ticket_controller.dart';

class HDropDown extends StatelessWidget {
  HDropDown(this.options,
      {
        @required this.title,
        this.padding,
        this.contentHorizontalPadding,
        this.onSelected,
        this.isRequire = false,
        this.isHasDefaultValue = false,
        this.hint,
        this.value,
        this.invalid = false,
        this.keyDropdown,
        this.isDisable = false});

  final List<OptionModel> options;
  int selectedValue;
  final double padding;
  final String title;
  final double contentHorizontalPadding;
  Function(String) onSelected;
  final int value;
  final bool isHasDefaultValue;
  final bool isRequire;
  bool isDisable;
  final bool invalid;
  final GlobalKey<FormFieldState> keyDropdown;
  String hint;
  bool isHasTransformerTicketController = Get.isRegistered<TransformerTicketController>();
  TransformerTicketController transformerTicketController;

  @override
  Widget build(BuildContext context) {
    selectedValue = value;

    if(isHasTransformerTicketController && !isDisable) {
      transformerTicketController = Get.find();
      isDisable = !transformerTicketController.isHasPermissionEdit();
    }

    if (isHasDefaultValue && options?.isNotEmpty == true) {
      selectedValue = options.first.value;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(
                title,
                style: Styles.titleTextField,
              ),
              if (isRequire)
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                )
            ],
          ),
        ),
        Container(
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
        ),
      ],
    );
  }
}
