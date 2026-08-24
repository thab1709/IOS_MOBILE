// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import '../../../common/extension/extension.dart';

class EDateTimePicker extends StatelessWidget {
  EDateTimePicker({@required this.dateSelected, this.currentDate, this.title, this.weight, this.horizontalPadding, this.enable});

  final Function(DateTime) dateSelected;
  String currentDate;
  final String title;
  final FontWeight weight;
  final double horizontalPadding;
  bool enable;

  @override
  Widget build(BuildContext context) {
    currentDate = currentDate ?? DateTime.now().toStringFormat(AppStrings.ddmmyyyyHHmm);
    enable ??= true;
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding ?? 0),
      child: GetPlatform.isMobile ? buildPhone(context) : buildTablet(context),
    );
  }

  Row buildTablet(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: TextStyle(fontWeight: weight , fontSize: 16),
          ),
        ),
        const SizedBox(width: 16,),
        Expanded(
          flex: 1,
          child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: enable ? Colors.white : Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(currentDate,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        enableFeedback: enable,
                        onTap: () {
                          if (enable) {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                locale: LocaleType.vi,
                                currentTime: DateTime.now(),
                                onConfirm: dateSelected);
                          }
                        },
                        child: Icon(Icons.calendar_today, color: enable ? Colors.black : Colors.grey,),
                      ))
                ],
              ))
        )
      ],
    );
  }

  Column buildPhone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: weight , fontSize: 16),
        ),
        const SizedBox(height: 8,),
        Container(
            height: 50,
            decoration: BoxDecoration(
                color: enable ? Colors.white : Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(currentDate,
                        style: const TextStyle(fontSize: 16)),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      enableFeedback: enable,
                      onTap: () {
                        if (enable) {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              locale: LocaleType.vi,
                              currentTime: DateTime.now(),
                              onConfirm: dateSelected);
                        }
                      },
                      child: Icon(Icons.calendar_today, color: enable ? Colors.black : Colors.grey,),
                    ))
              ],
            ))
      ],
    );
  }

}
