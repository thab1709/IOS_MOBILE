// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/themes/colorx.dart';
import 'package:evnmobile/src/htdct/common/themes/styles.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/check_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';
import 'package:evnmobile/src/htdct/models/option_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_datetime_picker.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_single_drop_down.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_text_form_field.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/h_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../models/day_night/popups/check_date_model.dart';
import '../../../../../../models/day_night/popups/check_dropdown_model.dart';
import '../../../transformer_ticket_controller.dart';
import 'abnormal_dropdown_widget.dart';
import 'expansion_widget.dart';

class CheckWidget extends StatefulWidget {
  CheckWidget({
    @required this.onChangeWeirdoMessage,
    this.options,
    this.title,
    this.isNumber = false,
    this.checkListItem,
    this.invalid = false,
    this.optionsDefaultValue,
    this.onSelectChange,
    this.onChangeInput,
    this.defaultAbnormal,
    this.addImage,
    this.isDisableDropdown = false,
    this.listImage,
    this.label,
    this.allImage,
    this.removeImage,
    this.widgetEx,
    this.isRequiredConclude = true,
    this.showAbnormalDropdown = true,
    this.abnormalOptions,
    this.onSelectedAbnormalOption,
    this.addAbnormalOption,
    this.initAbnormalOptionValue,
    this.showUnusualClassification = false,
    this.unusualClassificationDefaultValue,
    this.onUnusualClassificationChange,
  });

  final List<dynamic> checkListItem;
  List<Images> allImage;
  final bool isNumber;
  final bool isDisableDropdown;
  bool invalid;
  final List<OptionModel> options;

  final String title;
  final Function(String) onSelectChange;
  int optionsDefaultValue;
  String defaultAbnormal;
  final Function(String) onChangeInput;
  final Function addImage;
  final Function removeImage;
  final List<Images> listImage;
  final Function(String weirdoMessage) onChangeWeirdoMessage;
  final Widget widgetEx;
  String label;
  final bool isRequiredConclude;
  final bool showAbnormalDropdown;
  final List<OptionModelString> abnormalOptions;
  final Function({String value, String title}) onSelectedAbnormalOption;
  final Function(String) addAbnormalOption;
  final String initAbnormalOptionValue;

  //Phân loại bất thường
  final bool showUnusualClassification;
  int unusualClassificationDefaultValue;
  final Function(int) onUnusualClassificationChange;

  @override
  State<CheckWidget> createState() => _CheckWidgetState();
}

class _CheckWidgetState extends State<CheckWidget> {
  final formGlobalKey = GlobalKey<FormState>();
  final TransformerTicketController transformerTicketController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          if (formGlobalKey.currentState != null)
            formGlobalKey.currentState.validate()
        });
  }

  @override
  Widget build(BuildContext context) {
    setDefaultValueValue(widget.optionsDefaultValue);

    if (formGlobalKey.currentState != null) {
      formGlobalKey.currentState.validate();
    }
    return ExpansionWidget(
      isHeader: false,
      addImage: widget.addImage,
      isRequireImage: true,
      invalid: widget.invalid,
      removeImage: widget.removeImage,
      listImage: widget.listImage,
      isCamera: widget.optionsDefaultValue != null &&
          widget.optionsDefaultValue != widget.options.first.value,
      title: widget.title,
      allImage: widget.allImage,
      //'2.3 ' + AppStrings.checkCarryingCapacityOf22,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.widgetEx != null) widget.widgetEx,
            ...buildCheckList(),
            if (widget.options != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      HighElectricStrings.conclude,
                      style: Styles.titleTextField,
                    ),
                    if (widget.isRequiredConclude)
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
            if (widget.options != null)
              ESingleDropDown(
                widget.options,
                value: widget.optionsDefaultValue,
                padding: 0,
                isDisable: widget.isDisableDropdown,
                invalid: widget.invalid,
                onSelected: (value) {
                  widget.onSelectChange(value);
                  widget.optionsDefaultValue = int.parse(value);
                  widget.onChangeWeirdoMessage('');
                  widget.onChangeInput('');
                  widget.onUnusualClassificationChange?.call(null);
                  setState(() {
                    widget.invalid = false;
                  });
                },
              ),
            if (widget.showUnusualClassification)
              Visibility(
                visible: widget.optionsDefaultValue != null &&
                    widget.optionsDefaultValue != widget.options.first.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: const [
                          Text(
                            HighElectricStrings.unusualClassification,
                            style: Styles.titleTextField,
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ESingleDropDown(
                      OptionsType.unusual_classification.getOptions,
                      value: widget.unusualClassificationDefaultValue,
                      padding: 0,
                      isDisable: widget.isDisableDropdown,
                      invalid: widget.invalid,
                      onSelected: (value) {
                        final result = int.parse(value);
                        widget.unusualClassificationDefaultValue = result;
                        widget.onUnusualClassificationChange?.call(result);
                      },
                    ),
                  ],
                ),
              ),
            if (widget.showAbnormalDropdown &&
                widget.options != null &&
                widget.optionsDefaultValue != null &&
                widget.optionsDefaultValue != widget.options.first.value)
              AbnormalDropdownWidget(
                options: widget.abnormalOptions ?? [],
                invalid: widget.invalid,
                disable: !transformerTicketController.isHasPermissionEdit(),
                onSelected: (value) {
                  widget.onSelectedAbnormalOption(
                      value: value, title: widget.title);
                },
                addAbnormalOption: (value) async {
                  await widget.addAbnormalOption(value);
                },
                defaultOption: widget.initAbnormalOptionValue,
              ),
            if (widget.options != null)
              Visibility(
                visible: widget.optionsDefaultValue != null &&
                    widget.optionsDefaultValue != widget.options.first.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: const [
                          Text(
                            HighElectricStrings.abnormalExpression,
                            style: Styles.titleTextField,
                          ),
                          Text('*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        height: 80,
                        child: Form(
                          key: formGlobalKey,
                          child: TextFormField(
                              controller: TextEditingController()
                                ..text = widget.defaultAbnormal,
                              maxLines: null,
                              expands: true,
                              enabled: transformerTicketController
                                  .isHasPermissionEdit(),
                              // allow user to enter 5 line in textfield
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                widget.onChangeInput(value);
                                if (value?.isNullOrEmpty() == true) {
                                  widget.onChangeWeirdoMessage('');
                                } else {
                                  widget.onChangeWeirdoMessage(
                                      '${widget.title} Nội dung: $value');
                                }
                              },
                              validator: (value) {
                                if (widget.invalid &&
                                    (value == null || value.isBlank) &&
                                    widget.optionsDefaultValue !=
                                        widget.options.first
                                            .value) // check bắt buộc
                                {
                                  return '';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: !transformerTicketController
                                    .isHasPermissionEdit(),
                                fillColor: Colors.grey.shade100,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                      BorderSide(color: AppColor.borderColor1),
                                ),
                                hintText: 'Nhập thông tin',
                              ) //, user keyboard will have a button to move cursor to next line
                              ),
                        ))
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  void setDefaultValueValue(int value) {
    if (widget.options == null) return;

    final optionModel = widget.options.firstWhereOrNull(
        (element) => element.value == widget.optionsDefaultValue);
    if (optionModel == null) {
      return;
    }

    widget.optionsDefaultValue = optionModel.value;

    if (widget.onChangeWeirdoMessage != null &&
        widget?.defaultAbnormal?.isNotEmpty == true &&
        optionModel != null &&
        optionModel.value != widget.options.first.value) {
      widget.onChangeWeirdoMessage(
          '${widget.title} Nội dung: ${widget.defaultAbnormal}');
    } else {
      widget.onChangeInput('');
      widget.onChangeWeirdoMessage('');
    }
  }

  List<Widget> buildCheckList() {
    final results = <Widget>[];
    if (widget.checkListItem != null) {
      for (final item in widget.checkListItem) {
        if (item is CheckModel) {
          final textWidget = ETextFormField(
            hint: 'Nhập thông tin',
            title: item.title,
            isNumpad: item.isNumber,
            isRequied: item.isRequired,
            invalid: widget.invalid,
            readOnly: item.readOnly ??
                !transformerTicketController.isHasPermissionEdit(),
            value: item.value,
            onChangeInput: (value) {
              item.value = value;
              item.onChange(value);
            },
          );
          results.add(textWidget);
        } else if (item is CheckDateModel) {
          final dateWidget = HDateTimePicker(
            value: item.value,
            title: item.title,
            invalid: widget.invalid,
            isRequired: item.isRequired,
            onChange: (dateString) {
              item.value = dateString;
              item.onChange(dateString);
            },
          );
          results.add(dateWidget);
        } else if (item is CheckDropdownModel) {
          final model = HDropDown(
            item.options,
            value: item.value,
            title: item.title,
            invalid: widget.invalid,
            isRequire: item.isRequired,
            onSelected: (value) {
              item.onChange(value);
            },
          );
          results.add(model);
        }
      }
    }

    return results;
  }
}

