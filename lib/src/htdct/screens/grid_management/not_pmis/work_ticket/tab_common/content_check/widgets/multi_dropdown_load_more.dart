// @dart=2.9
import 'package:dropdown_search/dropdown_search.dart';
import 'package:evnmobile/src/htdct/models/option_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_daytime/check_sheet/high_transformer/high_transformer.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/app_color.dart';
import '../../../../../../../common/enum/ticket_enum.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/non_pmis/template_item_model.dart';
import '../content_check_controller.dart';

class MultiDropdownLoadMore extends StatefulWidget {
  final ContentCheckController controller;
  final TemplateItemModel model;

  const MultiDropdownLoadMore({Key key, this.controller, this.model})
      : super(key: key);

  @override
  State<MultiDropdownLoadMore> createState() => _MultiDropdownLoadmoreState();
}

class _MultiDropdownLoadmoreState extends State<MultiDropdownLoadMore> {
  final _openDropDownProgKey =
      GlobalKey<DropdownSearchState<OptionModelString>>();
  final _userEditTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userEditTextController.text = widget.model.searchTerm;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.controller
          .transformerTicketController.actionTicketType ==
          ActionTicketType.view,
      child: DropdownSearch<OptionModelString>.multiSelection(
        key: _openDropDownProgKey,
        showSearchBox: true,
        searchDelay: const Duration(hours: 1),
        searchFieldProps: TextFieldProps(
          controller: _userEditTextController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                await searchFunction();
              },
            ),
          ),
        ),
        dropdownSearchDecoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: checkInValid() ? Colors.red : Colors.grey),
            )),
        onFind: getData,
        onChanged: (data) async {
          if (data == null || data.isEmpty) {
            if (widget.controller.isCustomDropdown(model: widget.model)) {
              widget.model.inputCustomDropdownValue = null;
              widget.model.inputDropdownSelectmanyValue = null;
            }
          }
          if (widget.controller.isCustomDropdown(model: widget.model)) {
            widget.model.inputCustomDropdownValue =
                data.map((e) => e.value).join(';');
          } else {
            widget.model.inputDropdownSelectmanyValue =
                data.map((e) => e.value).join(';');
          }
          widget.controller.invalid.refresh();
        },
        selectedItems: widget.controller.getOptionInitValue(model: widget.model),
        popupCustomMultiSelectionWidget: (context, list) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!widget.controller.isCustomDropdown(model: widget.model) &&
                  1 < widget.model.paging.totalPages)
              Padding(
                padding: const EdgeInsets.all(8),
                child: OutlinedButton(
                  onPressed: () async {
                    // How should I select all items in the list?
                    _openDropDownProgKey.currentState.closeDropDownSearch();
                    await loadMoreOptions();
                  },
                  child: const Text('Xem thêm'),
                ),
              ),
              // Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(8),
                child: OutlinedButton(
                  onPressed: () {
                    // How should I unselect all items in the list?
                    _openDropDownProgKey.currentState?.closeDropDownSearch();
                  },
                  child: const Text('Đóng'),
                ),
              ),

            ],
          );
        },
        dropdownBuilder: _customDropDownMultiSelection,
        popupItemBuilder: _customPopupItemBuilderExample2,
      ),
    );
  }

  Future<List<OptionModelString>> getData(filter) async {
    widget.model.options.forEach((element) {
      element.title = '${element.title};${_userEditTextController.text}';
    });
    var options = <OptionModelString>[];
    options.addAll(widget.model.options);
    return options;
  }
  Widget _customPopupItemBuilderExample2(
      BuildContext context, OptionModelString item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Text(
        '${item.title.split(';').first}',
        style: const TextStyle(
            color: Colors.black),
        softWrap: true,
      ),
    );
  }

  Future loadMoreOptions({isSearch = false}) async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      widget.model.searchTerm = _userEditTextController.text;
      widget.model.pageIndex++;
      await widget.controller
          .getMoreOptions(model: widget.model, init: isSearch);
      _openDropDownProgKey.currentState?.changeSelectedItems(
          widget.controller.getOptionInitValue(model: widget.model));
      _openDropDownProgKey.currentState?.openDropDownSearch();
    });
  }

  searchFunction() async {
    _openDropDownProgKey.currentState?.closeDropDownSearch();
    widget.model.pageIndex = 0;
    await loadMoreOptions(isSearch: true);
  }

  bool checkInValid() {
    return widget.model.required &&
        widget.controller.invalid.value &&
        widget.controller.getOptionInitValue(model: widget.model).isEmpty;
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
            child: Text(e.title.split(';').first,style: const TextStyle(color: Colors.white))
          ),
        );
      }).toList(),
    );
  }
}

