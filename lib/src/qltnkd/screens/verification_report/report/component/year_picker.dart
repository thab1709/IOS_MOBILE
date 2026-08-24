// @dart=2.9
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';

class YearPickerView extends StatefulWidget {
  const YearPickerView({this.fieldModel, this.enable = true, this.onEditingComplete, Key key}) : super(key: key);

  final FieldModel fieldModel;
  final bool enable;
  final Function() onEditingComplete;

  @override
  _YearPickerViewState createState() => _YearPickerViewState();
}

class _YearPickerViewState extends State<YearPickerView> {
  FieldModel fieldModel;
  bool enable;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    fieldModel = widget.fieldModel;
  }

  @override
  Widget build(BuildContext context) {
    // isEmpty = widget?.fieldModel?.formValuesModel?.value == null || widget?.fieldModel?.formValuesModel?.value?.isEmpty == true;
    return Container(
      margin: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: !widget.enable
            ? null
            : () async {
          FocusScope.of(context).requestFocus(FocusNode());
          await showYearPicker();
        },
        child: Focus(
          focusNode: widget?.fieldModel?.focusNode,
          onFocusChange: (val) async {
            if (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              await showYearPicker();
            }
          },
          child: Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12, left: 10),
              decoration: BoxDecoration(
                color: widget.enable ? Colors.white : Colors.grey.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: isEmpty ? Colors.red : Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(fieldModel.value?.fromFormatUtcToFormatLocal(RAppStrings.yyyy) ?? '',
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: const Icon(Icons.calendar_today))
                ],
              )),
        ),
      ),
    );
  }

  Future showYearPicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn năm'),
          content: Container(
            // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 6),
              lastDate: DateTime(DateTime.now().year, 6),
              initialDate: fieldModel.value
                      .toDateFormatLocal(format: RAppStrings.utcFormatNotZ) ??
                  DateTime.now(),
              selectedDate: fieldModel.value
                      .toDateFormatLocal(format: RAppStrings.utcFormatNotZ) ??
                  DateTime.now(),
              onChanged: (dateTime) {
                setState(() {
                  fieldModel.value =
                      DateTime(dateTime.year, 6).toStringFormat(RAppStrings.utcFormatNotZ, isUtc: true);
                });
                Navigator.pop(context);
                if(widget.onEditingComplete != null) widget.onEditingComplete();

              },
            ),
          ),
        );
      },
    );
  }
}

