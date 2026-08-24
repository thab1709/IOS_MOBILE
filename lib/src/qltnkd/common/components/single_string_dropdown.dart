// @dart=2.9
import 'package:dropdown_search/dropdown_search.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:flutter/material.dart';
import 'package:tiengviet/tiengviet.dart';

class SingleStringDropDown extends StatelessWidget {
  SingleStringDropDown(this.options,
      {this.onSelected, this.isHasDefaultValue = false, this.value, this.isRequire, this.hint = '', Key key}): super(key: key);

  final List<StringOptionModel> options;
  String selectedValue;
  final Function(String) onSelected;
  final String value;
  final bool isRequire;
  final String hint;
  final bool isHasDefaultValue;

  static final Map<String, String> _parsedCache = {};

  @override
  Widget build(BuildContext context) {
    selectedValue = value;

    if (isHasDefaultValue && options?.isNotEmpty == true && value == null) {
      selectedValue = options.first.value.toString();
    }

    final modelSelected = options?.firstWhereOrNull((e) => e.value == selectedValue);

    return Container(
      color: Colors.white,
      child: DropdownSearch<StringOptionModel>(
        onChanged: (value) {
          onSelected(value?.value);
        },
        filterFn: (model, searchTerm) {
          if (searchTerm == null || searchTerm.isEmpty) return true;
          
          final lowerSearch = searchTerm.toLowerCase();
          final titleStr = model.title ?? '';
          final lowerTitle = titleStr.toLowerCase();
          
          // Fast path without parsing accents
          if (lowerTitle.contains(lowerSearch)) return true;

          String parsedSearch = _parsedCache[lowerSearch];
          if (parsedSearch == null) {
            parsedSearch = TiengViet.parse(lowerSearch);
            _parsedCache[lowerSearch] = parsedSearch;
          }

          String parsedTitle = _parsedCache[lowerTitle];
          if (parsedTitle == null) {
            parsedTitle = TiengViet.parse(lowerTitle);
            _parsedCache[lowerTitle] = parsedTitle;
          }

          return parsedTitle.contains(parsedSearch);
        },

        showSearchBox: true,
        showClearButton: true,
        clearButtonProps: const IconButtonProps(icon: Icon(Icons.close)),
        mode: Mode.DIALOG,
        searchDelay: const Duration(milliseconds: 300),
        itemAsString: (StringOptionModel u) => u.title,
        selectedItem: modelSelected,
        dropdownSearchDecoration: InputDecoration(
            hintText: hint,
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

