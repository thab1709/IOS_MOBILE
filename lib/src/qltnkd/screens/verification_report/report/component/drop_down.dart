// @dart=2.9
import 'package:dropdown_search/dropdown_search.dart';
import 'package:evnmobile/src/qltnkd/common/constance/api_code_general.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/dialog/add_option_dialog.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../common/themes/colorx.dart';
import '../report_controller.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    this.fieldModel,
    this.onEditingComplete,
    this.enable = true,
    this.refresh,
    Key key,
  }) : super(key: key);

  final FieldModel fieldModel;
  final bool enable;
  final Function() onEditingComplete;
  final Function() refresh;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool isEmpty = false;
  String valueFill = '';
  static final Map<String, String> _parsedCache = {};

  final ReportController _controller = Get.find();
  final GlobalKey _dropdownButtonKey = GlobalKey();

  bool get _isShowClear =>
      widget.enable &&
      widget.fieldModel.isRequire != true &&
      widget.fieldModel.isDisable != true;

  void openDropdown() {
    GestureDetector detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget != null && element.widget is GestureDetector) {
          detector = element.widget;
          return false;
        } else {
          searchForGestureDetector(element);
        }

        return true;
      });
    }

    searchForGestureDetector(_dropdownButtonKey.currentContext);
    assert(detector != null);

    detector.onTap();
  }

  @override
  void didUpdateWidget(covariant CustomDropDown oldWidget) {
    if (widget.fieldModel.value != oldWidget.fieldModel.value) {
      oldWidget.fieldModel.value = widget.fieldModel.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    if (widget.fieldModel.defaultValue != null &&
        (widget.fieldModel.value == null || widget.fieldModel.value.isEmpty)) {
      widget.fieldModel.value = widget.fieldModel.defaultValue;
    }

    if (!_controller.reportResponse.value.isPmis &&
        widget?.fieldModel?.value == null) {
      if (['[DRD_MANUFACTURER]', '[DRD_MADE_IN]', '[TYPE]']
          .contains(widget.fieldModel.fieldName)) {
        widget.fieldModel.value = '';
      } else if (['[DRD_AMBIENT_CONDITION]']
          .contains(widget.fieldModel.fieldName)) {
        widget.fieldModel.value = widget?.fieldModel?.additionalData?.options
            ?.firstWhereOrNull((element) => element.title == 'Không mưa')
            ?.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget?.fieldModel?.value == null &&
        widget?.fieldModel?.apiCode != null &&
        widget?.fieldModel?.apiCode != null &&
        widget?.fieldModel?.apiCode != ApiCodeGeneral.GeneralInspectionStatus) {
      valueFill =
          widget?.fieldModel?.additionalData?.options?.firstOrNull?.value;
      widget?.fieldModel?.value = valueFill;
    } else {
      final options = widget?.fieldModel?.additionalData?.options;
      if (options != null && options.isNotEmpty) {
        final matchedOption = options.firstWhere(
            (element) =>
                element.value == widget?.fieldModel?.value ||
                element.title == widget?.fieldModel?.value,
            orElse: () => null);
        if (matchedOption != null) {
          valueFill = matchedOption.value;
          widget.fieldModel.value = valueFill;
        } else {
          valueFill = widget?.fieldModel?.value;
        }
      } else {
        valueFill = widget?.fieldModel?.value;
      }
    }
    //isEmpty = widget?.fieldModel?.formValuesModel?.value?.isEmpty == true || widget?.fieldModel?.formValuesModel?.value?.isEmpty == true;
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: widget.enable ? Colors.white : Colors.grey.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: isEmpty ? Colors.red : Colors.grey)),
            child: Focus(
              focusNode: widget?.fieldModel?.focusNode,
              onFocusChange: (val) {
                if (val) {
                  widget?.fieldModel?.focusNode?.unfocus();
                  openDropdown();
                }
              },
              child: ValueListenableBuilder<String>(
                valueListenable: widget.fieldModel.valueNotifier,
                builder: (context, currentVal, _) {
                  if (currentVal != null && currentVal.isNotEmpty) {
                    valueFill = currentVal;
                  }
                  return Container(
                    key: _dropdownButtonKey,
                    child: DropdownSearch<StringOptionModel>(
                      key: ValueKey(valueFill),
                      showClearButton: _isShowClear,
                      enabled: _controller.isHasEdit(),
                      selectedItem: () {
                        if (valueFill == null || valueFill.isEmpty) return null;
                        final opts = widget?.fieldModel?.additionalData?.options;
                        if (opts != null && opts.isNotEmpty) {
                          final matched = opts.firstWhere((e) => e.value == valueFill || e.title == valueFill, orElse: () => null);
                          if (matched != null) {
                            if (valueFill != matched.value) {
                              valueFill = matched.value;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                widget.fieldModel.value = matched.value;
                              });
                            }
                            return matched;
                          }
                        }
                        return StringOptionModel(valueFill, valueFill);
                      }(),
                      showSearchBox: true,
                    compareFn: (item, selectedItem) => item?.value == selectedItem?.value,
                    filterFn: (model, searchTerm) {
                      if (searchTerm == null || searchTerm == '') return true;
                      
                      final lowerSearch = searchTerm.toLowerCase();
                      final titleStr = model.title ?? '';
                      final subTitleStr = model.subtitle ?? '';
                      final fullText = subTitleStr.isNotEmpty ? '$titleStr - $subTitleStr' : titleStr;
                      final lowerTitle = fullText.toLowerCase();

                      // Fast path
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
                    searchDelay: const Duration(milliseconds: 300),
                    dropdownSearchDecoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        border: OutlineInputBorder(borderSide: BorderSide.none)),
                    clearButtonProps: IconButtonProps(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                      iconSize: 16,
                    ),
                    dropdownButtonProps: IconButtonProps(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                      iconSize: 16,
                    ),
                    itemAsString: (StringOptionModel u) {
                      final titleStr = u.title ?? '';
                      final subTitleStr = u.subtitle ?? '';
                      return subTitleStr.isNotEmpty ? '$titleStr - $subTitleStr' : titleStr;
                    },
                    onChanged: widget.enable == null || widget.enable == false
                        ? null
                        : (newValue) {
                            _onValueChange(newValue.value);
                            if (widget.onEditingComplete != null) {
                              widget.onEditingComplete();
                            }
                          },
                    items: () {
                      final opts = widget?.fieldModel?.additionalData?.options?.toList() ?? <StringOptionModel>[];
                      if (valueFill != null && valueFill.isNotEmpty) {
                        final matched = opts.firstWhere((e) => e.value == valueFill, orElse: () => null);
                        if (matched == null) {
                          opts.add(StringOptionModel(valueFill, valueFill));
                        }
                      }
                      return opts;
                    }(),
                  ),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.fieldModel.isCodeApi() && widget.enable)
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              showDialogAddOption(positiveAction: (name) async {
                final optionId = await _controller.addGeneralData(
                    name, widget.fieldModel.apiCode.toString());
                if (optionId != null) {
                  final option = StringOptionModel(name, optionId);
                  widget.fieldModel.additionalData.options.add(option);
                  setState(() {});
                }
              });
            },
          )
      ],
    );
  }

  Future _onValueChange(String newValue) async {
    valueFill = newValue;
    if (widget?.fieldModel?.relationKey?.isNotEmpty == true) {
      await _controller.reportModel.value.fieldsModel
          .firstWhere((element) => element.fieldType == FieldType.taps,
              orElse: () => null)
          .fillValueToAllFieldText(
              widget?.fieldModel?.relationKey,
              widget?.fieldModel?.additionalData?.options
                      ?.firstWhereOrNull((element) => element.value == newValue)
                      ?.title ??
                  '');
      // widget.fieldModel.fillValueToAllField(, text);
    }
    widget.fieldModel.value = newValue;

    if (widget?.fieldModel?.relationKey?.isNotEmpty == true) {
      final getSubtitle = widget?.fieldModel?.additionalData?.options
          ?.firstWhereOrNull((element) => element.value == newValue);
      await _controller.reportModel.value.fieldsModel
          .firstWhere((element) => element.fieldType == FieldType.taps,
              orElse: () => null)
          .fillValueToAllFieldText(
              widget?.fieldModel?.relationKey, getSubtitle?.subtitle ?? '');
      // widget.fieldModel.fillValueToAllField(, text);
    }

    setState(() {});
  }
}

