// @dart=2.9
import 'package:evnmobile/src/app_common/rescource/images_common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/dialog/dialog_guild_input_character.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../report_controller.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    @required this.fieldModel,
    this.enable = true,
    this.isOnlyInputNumber = false,
    this.minLine,
    this.onEditingComplete,
    this.onOperatorValueChange,
    this.maxLine,
    this.isEdit,
    Key key,
  }) : super(key: key) {
    controller.text = fieldModel.value;
  }

  final FieldModel fieldModel;
  bool enable;
  final bool isOnlyInputNumber;
  final int maxLine;
  final Function() onEditingComplete;
  final int minLine;
  final Function() onOperatorValueChange;
  final bool isEdit;

  final TextEditingController controller = TextEditingController();

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isEmpty = false;
  bool isFocused = false;
  final ReportController reportController = Get.put(ReportController());

  @override
  void initState() {
    super.initState();
    widget.fieldModel?.focusNode?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        isFocused = widget.fieldModel?.focusNode?.hasFocus ?? false;
      });
    }
  }

  @override
  void dispose() {
    widget.fieldModel?.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    if (oldWidget.fieldModel.value != widget.fieldModel.value) {
      widget.controller.text = widget.fieldModel.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEdit &&
        (widget.fieldModel?.value == null || widget.fieldModel.value.isEmpty)) {
      widget.fieldModel?.value = widget.fieldModel?.defaultValue ?? '';
    }
    widget.controller.text = widget.fieldModel?.value;
    //isEmpty = widget?.controller?.text?.isEmpty ?? false;

    if (widget.enable) {
      widget.enable = !widget.fieldModel.isDisable ?? true;
    }

    if (widget?.fieldModel?.isDisableTextField() == true) {
      widget.enable = false;
    }

    widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller?.text?.length ?? 0));
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: widget.enable ? Colors.white : Colors.grey.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(
              color: isEmpty
                  ? Colors.red
                  : (isFocused ? Colors.blue : Colors.grey),
              width: isFocused ? 1.5 : 1.0)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: (text) {
                widget.fieldModel.value = text;
                if (widget?.fieldModel?.relationKey?.isNotEmpty == true) {
                  reportController.reportModel.value.fieldsModel
                      .firstWhere(
                          (element) => element.fieldType == FieldType.taps,
                          orElse: () => null)
                      .fillValueToAllFieldText(
                          widget?.fieldModel?.relationKey, text);
                  // widget.fieldModel.fillValueToAllField(, text);
                }

                reportController.checkEvaluate(widget.fieldModel);

                if (widget.onOperatorValueChange != null) {
                  widget.onOperatorValueChange();
                }
                if (text?.isNotEmpty == true && isEmpty) {
                  setState(() {
                    isEmpty = false;
                  });
                }
              },
              keyboardType: widget.isOnlyInputNumber
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              maxLines: widget.maxLine,
              focusNode: widget.fieldModel.focusNode,
              inputFormatters: [
                if (widget.isOnlyInputNumber)
                  FilteringTextInputFormatter.allow(RegExp(r'[\d+\.]')),
              ],
              minLines: widget.minLine,
              style: const TextStyle(fontSize: 16),
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                widget.onEditingComplete();
              },
              decoration: InputDecoration(
                isDense: true,
                enabled: widget.enable ?? true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              ),
            ),
          ),
          if (widget.enable)
            Container(
              height: 30,
              width: 30,
              child: IconButton(
                onPressed: () {
                  showDialogGuildInputCharacter(onSelect: (value) {
                    widget.controller.text = value;
                    widget.fieldModel.value = widget.fieldModel.value + value;
                    setState(() {});
                  });
                },
                icon: Image.asset(ImagesCommon.icCharacterMap),
              ),
            ),
        ],
      ),
    );
  }
}

