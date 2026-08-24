// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../report_controller.dart';

class TextInputTagView extends StatefulWidget {
  TextInputTagView(
      {@required this.fieldModel,
      this.enable = true,
      this.minLine,
      this.onOperatorValueChange,
      this.maxLine});

  final FieldModel fieldModel;
  final bool enable;
  final int maxLine;
  final int minLine;
  final Function() onOperatorValueChange;
  final TextEditingController controller = TextEditingController();

  @override
  _TextInputTagViewState createState() => _TextInputTagViewState();
}

class _TextInputTagViewState extends State<TextInputTagView> {
  bool isEmpty = false;
  final ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    widget.fieldModel.value ??= '';
    final selectedValues = widget?.fieldModel?.value?.isEmpty == true
        ? []
        : widget.fieldModel.value.split(',').toList();
    //isEmpty = widget?.controller?.text?.isEmpty ?? false;
    return Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: widget.enable ? Colors.white : Colors.grey.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: isEmpty ? Colors.red : Colors.grey)),
        child: Row(
          children: [
            Row(
              children: selectedValues.map((e) => _buildChip(e, selectedValues)).toList(),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: (text) {},
                keyboardType: TextInputType.text,
                maxLines: widget.maxLine,
                focusNode: widget.fieldModel.focusNode,
                minLines: widget.minLine,
                textInputAction: TextInputAction.done,
                onSubmitted: (text) {
                  if(widget.fieldModel.isStampNumber()) {
                    if (text?.trim()?.isNotEmpty == true && text.contains('.')) {
                      if (selectedValues.contains(text.toUpperCase()) ||
                          selectedValues.contains(text.toLowerCase())) {
                        //don't nothing
                      } else {
                        selectedValues.add(text);
                        widget.fieldModel.value = selectedValues.map((e) => e).join(',');
                      }
                      setState(() {
                        widget.controller.text = '';
                      });
                    } else {
                      widget.controller.text = text;
                      SnackBarHUD.show('Số tem không đúng định dạng');
                    }
                  } else {
                    if(text?.trim()?.isNotEmpty == true) {
                      if (selectedValues.contains(text.toUpperCase()) ||
                          selectedValues.contains(text.toLowerCase())) {
                        //don't nothing
                      } else {
                        selectedValues.add(text);
                        widget.fieldModel.value = selectedValues.map((e) => e).join(',');
                      }
                      setState(() {
                        widget.controller.text = '';
                      });
                    }
                  }
                },
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  isDense: true,
                  enabled: widget.enable ?? true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildChip(String label, List<String> values) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      child: Chip(
        label: Text(label),
        deleteIcon: widget.enable ? const Icon(Icons.close_sharp) : null,
        onDeleted: widget.enable ? () {
          values.removeWhere((element) => element == label);
          widget.fieldModel.value = values.map((e) => e).join(',');
          setState(() {});
        } : null,
      ),
    );
  }
}

