// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/themes/colorx.dart';
import 'package:evnmobile/src/htdct/common/utils/DecimalTextInputFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/themes/styles.dart';
import '../transformer/transformer_ticket_controller.dart';

class ETextFormField extends StatefulWidget {
  const ETextFormField(
      {@required this.title,
      this.formKey,
      this.hint,
      this.isRequied = false,
      this.isNumpad = false,
      this.isValueDouble = false,
      this.value,
      this.readOnly = false,
      this.invalid = false,
      this.onChangeInput,
      this.isMultiLine = false,
      this.isInt = false});

  final Key formKey;
  final String title;
  final String hint;
  final bool isRequied;
  final bool isNumpad;
  final bool isValueDouble;
  final String value;
  final bool readOnly;
  final bool invalid;
  final Function(String) onChangeInput;
  final bool isMultiLine;
  final bool isInt;

  @override
  State<ETextFormField> createState() => _ETextFormFieldState();
}

class _ETextFormFieldState extends State<ETextFormField> {
  final formGlobalKey = GlobalKey<FormState>();

  final controller = TextEditingController();

  bool readOnly = false;
  bool isHasTransformerTicketController =
      Get.isRegistered<TransformerTicketController>();
  TransformerTicketController transformerTicketController;

  String valueFormat() {
    if (widget.value.isNullOrEmpty() || widget.value == 'null') {
      return '';
    }

    if (widget.isNumpad != true || !widget.isValueDouble) {
      return widget.value;
    }

    final double valueDouble = widget.value.toDoubleOrNull();
    if (valueDouble == null) {
      return widget.value;
    }

    return valueDouble.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {formGlobalKey.currentState.validate()});
  }

  @override
  Widget build(BuildContext context) {
    readOnly = widget.readOnly;
    if (isHasTransformerTicketController &&
        !readOnly &&
        transformerTicketController?.abnormalNotify == false) {
      transformerTicketController = Get.find();
      readOnly = !transformerTicketController.isHasPermissionEdit();
    }
    controller.text = valueFormat();
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller?.text?.length ?? 0));
    if (formGlobalKey.currentState != null) {
      formGlobalKey.currentState.validate();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: RichText(
            text: TextSpan(
              text: widget.title,
              style: Styles.titleTextField,
              children: <TextSpan>[
                if (widget.isRequied)
                  const TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      )),
              ],
            ),
          ),
        ),
        Form(
          key: widget.formKey ?? formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                  controller: controller,
                  onChanged: (value) {
                    if (widget.onChangeInput != null) {
                      widget.onChangeInput(value);
                    }
                    if (widget.invalid) {
                      formGlobalKey.currentState.validate();
                    }
                  },
                  readOnly: readOnly,
                  maxLines: widget.isMultiLine ? 3 : 1,
                  // initialValue: (widget.value==null):widget.value,
                  // initialValue: widget.isNumpad?((widget.value==null||widget.value==''||widget.value=='null')?null:widget.value):widget.value,
                  keyboardType: widget.isNumpad
                      ? TextInputType.numberWithOptions(
                          decimal: !widget.isInt, signed: true)
                      : widget.isMultiLine
                          ? TextInputType.multiline
                          : TextInputType.text,
                  inputFormatters: widget.isNumpad
                      ? widget.isInt
                          ? [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ]
                          : [
                              DecimalTextInputFormatter(),
                              CommaTextInputFormatter(),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^\-?\d*\.?\d{0,2})')),
                            ]
                      : [],
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    // return 'Please enter some text';
                    if (widget.invalid &&
                        (value == null || value.trim().isEmpty) &&
                        widget.isRequied &&
                        !readOnly) // check bắt buộc
                    {
                      return '';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      isDense: true,
                      fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(color: AppColor.borderColor1),
                      ),
                      enabledBorder: readOnly
                          ? null
                          : const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                color: AppColor.borderColor1,
                              ),
                            ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                          color: AppColor.borderColor1,
                        ),
                      ),
                      hintText: readOnly ? '' : widget.hint)),
            ],
          ),
        ),
      ],
    );
  }
}

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var truncated = newValue.text;
    final newSelection = newValue.selection;

    if (newValue.text.contains(',')) {
      truncated = newValue.text.replaceFirst(RegExp(','), '.');
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
      );
    }

    return newValue;
  }
}

