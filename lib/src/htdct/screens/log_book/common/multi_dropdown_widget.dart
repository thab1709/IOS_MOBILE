// @dart=2.9
import 'package:dropdown_search/dropdown_search.dart';
import 'package:evnmobile/src/htdct/models/option_model.dart';
import 'package:flutter/material.dart';

import '../../../common/constance/app_color.dart';
import 'option_type.dart';

class MultiDropdownWidget extends StatelessWidget {
  final List<OptionModelString> optionModelString;
  final List<OptionModelString> defaultOptionModelString;
  final Function(List<OptionModelString>) onSelected;
  final bool invalid;
  final bool disable;
  final bool isNumber;
  final String title;

  const MultiDropdownWidget(
      {Key key,
      this.optionModelString,
      this.onSelected,
      this.invalid,
      this.disable,
      this.isNumber,
      this.title, this.defaultOptionModelString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disable,
      child: DropdownSearch<OptionModelString>.multiSelection(
              popupTitle: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ),
              showSearchBox: true,
              searchDelay: const Duration(seconds: 1),
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
              dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: (invalid && defaultOptionModelString == null && defaultOptionModelString.isEmpty )
                            ? Colors.red
                            : Colors.grey),
                  )),
              items: optionModelString,
              onChanged: (data) async {
                onSelected(data);
              },
            selectedItems: defaultOptionModelString??[],
        dropdownBuilder: _customDropDownMultiSelection,
            ),
    );
  }
  Widget _customDropDownMultiSelection(
      BuildContext context, List<OptionModelString> selectedItems) {
    if (selectedItems.isEmpty) {
      return const Text("Chọn");
    }
    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: HighElectricAppColor.highlightColor,
              ),
              child: Text(e.title,style: const TextStyle(color: Colors.white))
          ),
        );
      }).toList(),
    );
  }
}

