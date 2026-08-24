// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class ESingleDateTimePicker extends StatelessWidget {
  final Function(DateTime) dateSelected;
  final DateTime currentDate;
  final bool enable;
  final DateFormat dateFormat = DateFormat('HH:mm  dd/MM/yyyy');

  ESingleDateTimePicker({@required this.dateSelected, this.currentDate, this.enable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Text(dateFormat.format(currentDate ?? DateTime.now()),
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    if(enable) {
                      DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        locale: LocaleType.vi,
                        currentTime: currentDate ?? DateTime.now(),
                        onConfirm: dateSelected);
                    }
                  },
                  child: const Icon(Icons.calendar_today),
                ))
          ],
        ));
  }
}

