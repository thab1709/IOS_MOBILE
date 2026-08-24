// @dart=2.9
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../common/themes/styles.dart';

Widget DateTimePickerCustom(
    {@required String title,
    Function onChange,
    bool invalid = false,
    bool isRequired = false,
    String initValueDateTime = '',
    bool readOnly = false,
    TextEditingController textEditingController,
    bool isEndTime = false}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(
              title,
              style: Styles.titleTextField,
            ),
            if (isRequired)
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
      Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (invalid &&
                          (textEditingController.text
                                  .toString()
                                  .isNullOrEmpty() ||
                              isEndTime))
                      ? Colors.red
                      : Colors.grey,
                  style: BorderStyle.solid)),
          child: DateTimeField(
            enabled: !readOnly,
            controller: textEditingController,
            //TextEditingController()..text =initValueDateTime==null?null:initValueDateTime.contains('T')?initValueDateTime.fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmm1):initValueDateTime,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (value) {
              onChange(value.toString());
              // onChange( value ==null ? 'null': value.toString().fromFormatUTCToFormat(HighElectricStrings.ddmmyyyyHHmmss,HighElectricStrings.ddmmyyyyHHmm1));
            },
            format: DateFormat(HighElectricStrings.ddmmyyyyHHmm),
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  locale: const Locale('vi', 'VN'),
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
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
          )),
    ],
  );
}

