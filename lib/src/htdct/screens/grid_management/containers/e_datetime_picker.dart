// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../../common/extension/extension.dart';

class HDateTimePicker extends StatelessWidget {
  const HDateTimePicker({
    this.onChange,
    this.value,
    this.title,
    this.horizontalPadding,
    this.enable = true,
    this.invalid = false,
    this.isRequired = false,
    this.dateFormat = HighElectricStrings.ddMMyyyy,
  });

  final Function(String) onChange;
  final String value;
  final String title;
  final String dateFormat;
  final double horizontalPadding;
  final bool enable;
  final bool isRequired;
  final bool invalid;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 16 , horizontal: horizontalPadding ?? 0),
      child: buildPhone(context),
    );
  }

  Column buildPhone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
            height: 50,
            decoration: BoxDecoration(
                color: enable ? Colors.white : Colors.grey.shade100,
                border: Border.all(color: invalid && (value == null || value.isEmpty) ? Colors.red : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 14),
                    child:
                        Text(value ?? '', style: const TextStyle(fontSize: 16)),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      enableFeedback: enable,
                      onTap: () {
                        if (enable) {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              locale: LocaleType.vi,
                              currentTime: value.toDate(format: dateFormat) ?? DateTime.now(), onConfirm: (date) {
                            onChange(
                                date.toStringFormat(HighElectricStrings.utcFormatNotZ, isUtc: true));
                          });
                        }
                      },
                      child: Icon(
                        Icons.calendar_today,
                        color: enable ? Colors.black : Colors.grey,
                      ),
                    ))
              ],
            ))
      ],
    );
  }
}

