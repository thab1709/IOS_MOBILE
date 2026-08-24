// @dart=2.9
import 'package:dropdown_search/dropdown_search.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:flutter/material.dart';
import 'package:tiengviet/tiengviet.dart';

class SingleIntDropDown extends StatelessWidget {
  SingleIntDropDown(this.options,
      {this.onSelected, this.isHasDefaultValue = false, this.value});

  final List<IntOptionModel> options;
  int selectedValue;
  Function(String) onSelected;
  final int value;
  final bool isHasDefaultValue;

  @override
  Widget build(BuildContext context) {
    selectedValue = value;

    if (isHasDefaultValue && options?.isNotEmpty == true && value == null) {
      selectedValue = options.first.value;
    }

    final modelSelected = options?.firstWhereOrNull((e) => e.value == selectedValue);

    return Container(
      color: Colors.white,
      child: DropdownSearch<IntOptionModel>(
        onChanged: (value) {
          onSelected(value?.value?.toString());
        },
        filterFn : (model, searchTerm){
          if(searchTerm == '') return true;
          final a = TiengViet.parse(searchTerm.toLowerCase());
          final b = TiengViet.parse(model.title.toLowerCase());
          final c = b.contains(a);
          return c;
        },

        showSearchBox: true,
        showClearButton: true,
        clearButtonProps: const IconButtonProps(icon: Icon(Icons.close)),
        mode: Mode.DIALOG,
        searchDelay: const Duration(milliseconds: 300),
        itemAsString: (IntOptionModel u) => u.title,
        selectedItem: modelSelected,
        dropdownSearchDecoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)))),
        items: options,
      ),
    );
  }
}

