// @dart=2.9
import 'dart:ffi';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../app_common/edit_picture/add_text_screen.dart';
import '../../../../htld/common/utils/alert_dialog_utils.dart';
import '../../../common/components/button_40.dart';
import '../../../common/constance/app_color.dart';
import '../../../common/constance/app_icon.dart';
import '../../../common/constance/strings.dart';
import '../../../common/themes/styles.dart';
import '../../../models/day_night/popups/images_model.dart';
import '../../../models/option_model.dart';
import '../../grid_management/containers/auto_height_text_field.dart';
import '../../grid_management/containers/e_check_box.dart';
import '../../grid_management/containers/e_single_drop_down.dart';
import '../../grid_management/containers/e_text_form_field.dart';
import '../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../grid_management/transformer/check_by_daytime/check_sheet/common/dialog_picture.dart';
import 'multi_dropdown_widget.dart';
import 'single_dropdown_widget.dart';

class WidgetItems extends StatefulWidget {
  const WidgetItems(
      {this.invalid = false,
        this.invalidEx=false,
      this.textValue,
      this.function,
      this.numberValue,
      this.optionValue,
      this.imagesValue,
      this.optionsString,
      this.defaultOptionsString,
      this.optionsNumber,
      this.defaultOptionsNumber,
      this.typeItem,
      this.title,
      this.required = false,
      this.readOnly = false,
      this.checkBoxValue,
      this.removeImage,
      this.addImage,
      this.fromDateTime,
      this.toDateTime,
      this.timeController,
      this.isChildrenItem = false,
      this.defaultSingleOptionsString,
      this.isNumber = false,
      this.initEmptyValue = false,
        this.invalidEndDate=false
      });

  final bool invalid;
  final bool invalidEx;
  final String textValue;
  final Function function;
  final double numberValue;
  final int optionValue;
  final List<Images> imagesValue;
  final List<OptionModelString> optionsString;
  final List<OptionModelString> defaultOptionsString;
  final List<OptionModel> optionsNumber;
  final int defaultOptionsNumber;
  final String defaultSingleOptionsString;
  final int typeItem;
  final String title;
  final bool required;
  final bool readOnly;
  final bool checkBoxValue;
  final Function removeImage;
  final Function addImage;
  final DateTime fromDateTime;
  final DateTime toDateTime;
  final TextEditingController timeController;
  final bool isChildrenItem;
  final bool isNumber;
  final bool initEmptyValue;
  final bool invalidEndDate;


  @override
  State<WidgetItems> createState() => _WidgetItemsState();
}

class _WidgetItemsState extends State<WidgetItems> {
  DateTime fromDateTime;
  DateTime toDateTime;
  String fromDate = '';
  String toDate = '';

  @override
  void initState() {
    // TODO: implement initState
    fromDateTime = widget.fromDateTime;
    toDateTime = widget.toDateTime;
    if(widget.initEmptyValue)
      {widget.function('');}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.isChildrenItem ? 16 : 0),
      child: renderTypeItem(),
    );
  }

  Widget renderTypeItem() {
    switch (widget.typeItem) {
      case TypeItem.textBox /*textbox*/ :
        return ETextFormField(
          hint: 'Nhập thông tin',
          title: widget.title,
          isNumpad: widget.isNumber,
          isRequied: widget.required,
          invalid: widget.invalid,
          readOnly: widget.readOnly,
          value: widget.textValue,
          onChangeInput: (value)=>widget.function(value),
        );
      case TypeItem.singleDropdown /*single dropdown*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title: widget.title, required: widget.required),

              SingleDropdownWidget(
                onSelected: (value)=> widget.function(value),
                isNumber: widget.isNumber,
                invalid: widget.required && widget.invalid,
                defaultOptionsNumber: widget.defaultOptionsNumber,
                defaultSingleOptionsString: widget.defaultSingleOptionsString.isNullOrEmpty()?null:widget.defaultSingleOptionsString,
                disable: widget.readOnly,
                optionModelNumber: widget.optionsNumber ?? [],
                optionModelString: widget.optionsString ?? [],
                title: widget.title,
              ),

          ],
        );
      case TypeItem.multiDropdown /*multi dropdown*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title: widget.title, required: widget.required),
            MultiDropdownWidget(
              onSelected: (value)=> widget.function(value),
              invalid: widget.required && widget.invalid,
              defaultOptionModelString: widget.defaultOptionsString,
              disable: widget.readOnly,
              optionModelString: widget.optionsString ?? [],
              title: widget.title,
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 3),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5),
            //       border: Border.all(
            //           color: ((widget.required &&
            //                   widget.defaultOptionsString.isEmpty && widget.invalid)||widget.invalidEx)
            //               ? Colors.red
            //               : Colors.grey,
            //           style: BorderStyle.solid)),
            //   child: IgnorePointer(
            //     ignoring: widget.readOnly,
            //     child: MultiSelectDialogField(
            //       searchable: true,
            //       cancelText: const Text('Hủy'),
            //       title: Text(widget.title),
            //       buttonText: const Text('Chọn',
            //           style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.w400,
            //               color: HighElectricAppColor.nature04)),
            //       buttonIcon: const Icon(Icons.arrow_drop_down),
            //
            //       items: (widget.optionsString ?? [])
            //           .map((e) => MultiSelectItem(e, e.title))
            //           .toList(),
            //       initialValue:
            //           widget.defaultOptionsString ?? [], //[model.options[0]],
            //       listType: MultiSelectListType.LIST,
            //       onConfirm: (value)=>widget.function(value),
            //     ),
            //   ),
            // ),
          ],
        );
      case TypeItem.textArea /*TextArea*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title: widget.title, required: widget.required),
            AutoHeightTextField(
              textFieldController:
                  TextEditingController(text: widget.textValue),
              maxHeight: 150,
              onChange: widget.function,
              isEnable: !widget.readOnly,
              hintText: 'Nhập thông tin',
              invalid: widget.required &&
                  widget.invalid &&
                  widget.textValue.isNullOrBlank(),
            ),
          ],
        );
      case TypeItem.checkbox /*Checkbox*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title: widget.title, required: widget.required),
            ECheckBox(
              isSubstation: false,
              onClicked: widget.function,
              checked: widget.checkBoxValue,
              isAllowEdit: !widget.readOnly,
            ),
          ],
        );
        break;
      case TypeItem.timePicker /*Datetime picker*/ :
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitle(title: widget.title, required: widget.required),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: (widget.invalid &&
                                widget.required &&
                                widget.textValue.isNullOrBlank())
                            ? Colors.red
                            : Colors.grey,
                        style: BorderStyle.solid)),
                child: DateTimeField(
                  enabled: widget.readOnly,
                  onChanged: widget.function,
                  initialValue: widget.textValue == null
                      ? null
                      : DateTime.parse(widget.textValue),
                  format: DateFormat("HH:mm"),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                      builder: (context, child) {
                        final Widget mediaQueryWrapper = MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            alwaysUse24HourFormat: true,
                          ),
                          child: Localizations.override(
                            context: context,
                            locale: const Locale('vi', 'VN'),
                            child: child,
                          ),
                        );

                        return mediaQueryWrapper;
                      },
                    );
                    return DateTimeField.convert(time);
                  },
                ),
              ),
            ]);

      case TypeItem.images /*Images*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title: widget.title, required: widget.required),
            Wrap(
              children: [
                if (widget.readOnly == false)
                  GestureDetector(
                    onTap: () async {
                      if (widget.imagesValue.length == 10) {
                        await showDialogOneButton(
                            HighElectricStrings.overloadImagesLength);
                      } else {
                        final result = await showSelectMultiImageBottomSheet(
                            context,
                            10 -
                                (widget.imagesValue != null
                                    ? widget.imagesValue.length
                                    : 0));
                        if (result != null && result is List<File> && result.isNotEmpty) {
                          final editImageResult = await Get.to(EditImageScreen(
                            files: result,
                          ));
                          if (editImageResult != null) {
                            await widget.addImage(editImageResult);
                          }
                        }
                      }
                    },
                    child: Button40(
                      child: SvgPicture.asset(
                        HighElectricAppIcon.camera,
                        color: (widget.invalid &&
                            widget.imagesValue.isEmpty &&
                            widget.required)
                            ? Colors.red
                            : Colors.white,
                        width: 18,
                        height: 20,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                Visibility(
                  visible: widget.imagesValue != null &&
                      widget.imagesValue.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogPicture(
                                    listImage: widget.imagesValue,
                                    removeImage: (file) {
                                      widget.removeImage(file);
                                    },
                                    addImage: (item) => widget.addImage(item),
                                    isLogbook: true,
                                    isGroup:widget.readOnly==true,
                                    showRemove: widget.readOnly==false,
                                    // isGroup: _controller
                                    //     .transformerTicketController
                                    //     .actionTicketType ==
                                    //     ActionTicketType.view,
                                  );
                                });
                          },
                          child: Button40(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  HighElectricAppIcon.collections,
                                  width: 18,
                                  height: 20,
                                  fit: BoxFit.scaleDown,
                                ),
                                Positioned(
                                    top: 3,
                                    right: 3,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color:
                                        HighElectricAppColor.brandColor04,
                                        border: Border.all(
                                            color:
                                            HighElectricAppColor.nature01),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.imagesValue.length
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: HighElectricAppColor.nature01,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
        break;
      case TypeItem.datePicker /*Date picker*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title: widget.title, required: widget.required),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: (widget.invalid &&
                              widget.required &&
                              widget.textValue.isNullOrBlank())
                          ? Colors.red
                          : Colors.grey,
                      style: BorderStyle.solid)),
              child: DateTimeField(
                enabled: !widget.readOnly,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: widget.function,
                initialValue: widget.textValue == null
                    ? null
                    : DateTime.parse(widget.textValue),
                format: DateFormat(HighElectricStrings.ddMMyyyy),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      locale: const Locale('vi', 'VN'),
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  return date;
                },
              ),
            ),
          ],
        );
        break;
      case TypeItem.dateTimePicker /*Date picker*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title: widget.title, required: widget.required),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: ((widget.invalid &&
                              widget.required &&
                              widget.timeController.text.isNullOrBlank()) || widget.invalidEx)
                          ? Colors.red
                          : Colors.grey,
                      style: BorderStyle.solid)),
              child: Row(
                children: [
                  Expanded(
                    child: DateTimeField(
                      enabled: !widget.readOnly,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onChanged: (value)=>widget.function(value),
                      initialValue: widget.timeController.text.isNullOrEmpty()
                          ? null
                          : DateTime.parse(widget.timeController.text),
                      format: DateFormat(HighElectricStrings.ddmmyyyyHHmm),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            locale: const Locale('vi', 'VN'),
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue??DateTime.now()),
                            builder: (context, child) {
                              final Widget mediaQueryWrapper = MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: true,
                                ),
                                child: Localizations.override(
                                  context: context,
                                  locale: const Locale('vi', 'VN'),
                                  child: child,
                                ),
                              );

                              return mediaQueryWrapper;
                            },
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                  ),
                  if(widget.timeController.text.isNullOrEmpty())
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child:  Icon(
                      Icons.calendar_today,
                      color: HighElectricAppColor.nature05,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            if(widget.invalidEndDate)
              const Text(
                'Thời gian kết thúc phải lớn hơn Thời gian bắt đầu!',
                softWrap: true,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              )
          ],
        );
        break;
      case TypeItem.periodTime: //periodTime
        return Column(
          children: [
            _buildTitle(title: widget.title, required: widget.required),
            GestureDetector(
              onTap: () async {
                await _showTimePicker(context);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: Colors.grey.shade300)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.timeController,
                        decoration: const InputDecoration(
                          enabled: false,
                          border: InputBorder.none,
                          hintText: 'Chọn khoảng thời gian',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.calendar_today,
                        color: HighElectricAppColor.nature05,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case TypeItem.title: //
        return _buildTitle(title: widget.title, required: widget.required);
        break;
      default:
        return Container();
    }
  }

  Widget _buildTitle({String title, bool required}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(
                title,
                style: Styles.titleTextField,
              ),
              if (required)
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
      ],
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final arrDateSearch = await showTimePickerSearch(
        context,
        fromDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, 1),
        toDateTime ??
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
    if (arrDateSearch != null) {
      if (fromDateTime == null || toDateTime == null) {
        widget.timeController.text =
            '${arrDateSearch.start.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${arrDateSearch.end.toStringFormat(HighElectricStrings.ddMMyyyy)}';
      } else {
        widget.timeController.text = null;
      }
      fromDateTime = arrDateSearch.start;
      toDateTime = arrDateSearch.end;
      setState(() {});
      // widget.fromDate = arrDateSearch.start.formatFirstDate();
      // widget.toDate = arrDateSearch.end.formatSecondDate();

    }
  }

  Future<DateTimeRange> showTimePickerSearch(
      BuildContext context, DateTime fromDate, DateTime toDate) async {
    final currentTime = DateTime.now().toUtc();
    final dateTimeRangeInit = DateTimeRange(start: fromDate, end: toDate);
    return showDateRangePicker(
        context: context,
        locale: const Locale('vi', 'VN'),
        initialDateRange: dateTimeRangeInit,
        firstDate:
            DateTime(currentTime.year - 5, currentTime.month, currentTime.day),
        lastDate:
            DateTime(currentTime.year + 2, currentTime.month, currentTime.day));
  }
}

