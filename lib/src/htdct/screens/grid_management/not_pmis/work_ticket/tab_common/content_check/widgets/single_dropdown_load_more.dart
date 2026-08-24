// @dart=2.9
import 'package:dropdown_search/dropdown_search.dart';
import 'package:evnmobile/src/htdct/models/option_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/enum/ticket_enum.dart';
import '../../../../../../../models/non_pmis/template_item_model.dart';
import '../content_check_controller.dart';

class SingleDropdownLoadMore extends StatefulWidget {
  final ContentCheckController controller;
  final TemplateItemModel model;

  const SingleDropdownLoadMore({Key key, this.controller, this.model})
      : super(key: key);

  @override
  State<SingleDropdownLoadMore> createState() => _SingleDropdownLoadmoreState();
}

class _SingleDropdownLoadmoreState extends State<SingleDropdownLoadMore> {
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
      child: DropdownSearch<OptionModelString>(
        key: _openDropDownProgKey,
        showSearchBox: true,
        searchDelay: const Duration(hours: 1),
        // filterFn: (model, filter) {
        //   // searchFunction()
        //   _userEditTextController.text = filter;
        //   // searchFunction();
        //   return true;
        // },
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
          if (data.value == 'key_load_more') {
            await loadMoreOptions();
          } else {
            if (widget.controller.isCustomDropdown(model: widget.model)) {
              widget.model.inputCustomDropdownValue = data.value;
            } else {
              widget.model.inputDropdownValue = data.value;
            }
            widget.controller.invalid.refresh();
          }
        },
        selectedItem: getOptionInit(),
        popupItemBuilder: _customPopupItemBuilderExample2,
        dropdownBuilder: _customDropDownMultiSelection,
      ),
    );
  }

  Future<List<OptionModelString>> getData(filter) async {
    // var options = <OptionModelString>[];
    // options.addAll(widget.model.options);

    widget.model.options.forEach((element) {
      element.title = '${element.title};${_userEditTextController.text}';
    });
    var options = <OptionModelString>[];
    options.addAll(widget.model.options);
    // return options;

    if (!widget.controller.isCustomDropdown(model: widget.model) &&
        1 < widget.model.paging.totalPages) {
      options.add(OptionModelString('Xem thêm;${_userEditTextController.text}', 'key_load_more'));
    }
    return options;
  }

  Future loadMoreOptions({isSearch = false}) async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      widget.model.searchTerm = _userEditTextController.text;
      widget.model.pageIndex++;
      await widget.controller
          .getMoreOptions(model: widget.model, init: isSearch);
      _openDropDownProgKey.currentState?.changeSelectedItem(getOptionInit());
      _openDropDownProgKey.currentState?.openDropDownSearch();
    });
  }

  OptionModelString getOptionInit() {
    final options = widget.controller.getOptionInitValue(model: widget.model);
    return options.isNotEmpty ? options[0] : null;
  }


  Widget _customPopupItemBuilderExample2(
      BuildContext context, OptionModelString item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Text(
        '${item.title.contains('Xem thêm')?'Xem thêm':item.title.split(';').first}',
        style: TextStyle(
            color: item.value == 'key_load_more'
                ? Colors.lightBlue
                : Colors.black),
        softWrap: true,
      ),
    );
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
      BuildContext context, OptionModelString selectedItems) {
    if (selectedItems == null) {
      return const Text("Chọn");
    } else {
      return Text('${selectedItems.title.split(';').first}');
    }
  }
}

