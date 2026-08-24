// @dart=2.9
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../models/option_model.dart';

class TSingleDropdownWidget extends StatelessWidget {
  final List<OptionModelString> optionModelString;
  final List<OptionModel> optionModelNumber;
  final int defaultOptionsNumber;
  final String defaultSingleOptionsString;
  final Function(String) onSelected;
  final bool invalid;
  final bool disable;
  final bool isNumber;
  final String title;

  const TSingleDropdownWidget(
      {Key key,
      this.optionModelString,
      this.optionModelNumber,
      this.defaultOptionsNumber,
      this.defaultSingleOptionsString,
      this.onSelected,
      this.invalid,
      this.disable,
      this.isNumber,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disable,
      child: isNumber
          ? DropdownSearch<OptionModel>(
              popupTitle: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ),
              showSearchBox: true,
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
              searchDelay: const Duration(seconds: 1),
              dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: (invalid && defaultOptionsNumber == null)
                            ? Colors.red
                            : Colors.grey),
                  )),
              items: optionModelNumber,
              onChanged: (data) async {
                onSelected(data.value.toString());
              },
              selectedItem: getDefaultOption(),
              dropdownBuilder: _customDropDownNumber,
            )
          : DropdownSearch<OptionModelString>(
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
                        color: (invalid && defaultSingleOptionsString == null)
                            ? Colors.red
                            : Colors.grey),
                  )),
              items: optionModelString,
              onChanged: (data) async {
                onSelected(data.value);
              },
            selectedItem: getDefaultOption(),
          dropdownBuilder: _customDropDownString,
            ),
    );
  }
  getDefaultOption()
  {
    if(isNumber)
      {
        final list = optionModelNumber.where((element) => element.value==defaultOptionsNumber);
        return list.isEmpty?null:list.first;
      }
    else
      {
        final list =  optionModelString.where((element) => element.value==defaultSingleOptionsString);
        return list.isEmpty?null:list.first;
      }
  }

  Widget _customDropDownNumber(
      BuildContext context, OptionModel selectedItems) {

    return Text(selectedItems==null?'Chọn':selectedItems.title);
  }
  Widget _customDropDownString(
      BuildContext context, OptionModelString selectedItems) {

    return Text(selectedItems==null?'Chọn':selectedItems.title);
  }
}

