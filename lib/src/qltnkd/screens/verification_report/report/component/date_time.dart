// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';

class DateTimePicker extends StatefulWidget {

  const DateTimePicker({this.fieldModel,this.enable = true, this.onEditingComplete, Key key}) : super(key: key);

  final FieldModel fieldModel;
  final bool enable;
  final Function() onEditingComplete;


  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  FieldModel fieldModel;
  bool enable;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    fieldModel = widget.fieldModel;
    if(fieldModel.value == null || fieldModel?.value?.isEmpty == true) {
      fieldModel.value = DateTime.now().toStringFormat(AppStrings.utcFormatNotZ, isUtc: true);
    }
  }

  Future showPicker() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final result = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        locale: LocaleType.vi,
        currentTime: fieldModel.value.toDateFormatLocal() ?? DateTime.now(),
        onConfirm: (date){
          setState(() {
            fieldModel.value = date.toStringFormat(AppStrings.utcFormatNotZ, isUtc: true);
          });
        });

    if(result != null) {
      if(widget.onEditingComplete != null) widget.onEditingComplete();
    }
  }
  @override
  Widget build(BuildContext context) {
   // isEmpty = widget?.fieldModel?.formValuesModel?.value == null || widget?.fieldModel?.formValuesModel?.value?.isEmpty == true;
    return Container(
      margin: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: !widget.enable ? null : showPicker,
        child: Focus(
          focusNode: widget?.fieldModel?.focusNode,
          onFocusChange: (val) {
            if (val) {
              showPicker();
            }
          },
          child: Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12, left: 10),
              decoration: BoxDecoration(
                color: widget.enable ? Colors.white : Colors.grey.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: isEmpty ? Colors.red : Colors.grey),),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(fieldModel.value?.fromFormatUTCToFormat(AppStrings.utcFormat, AppStrings.ddMMyyyy) ?? '',
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
}

