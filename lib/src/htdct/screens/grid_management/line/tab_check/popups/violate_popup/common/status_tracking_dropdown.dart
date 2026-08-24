// @dart=2.9
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/option_type.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../containers/e_single_drop_down.dart';

Widget StatusTrackingDropdown(
    {Function(String) onChange, bool invalid, int defaultValue}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: const [
            Text(
              'Trạng thái theo dõi: ',
              style: Styles.titleTextField,
            ),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
      ESingleDropDown(
        OptionsType.following_finished.getOptions,
        value: defaultValue,
        invalid: invalid,
        onSelected: (value) {
          onChange(value);
        },
        isDisable: true,
        // isHasDefaultValue: true,
      ),
    ],
  );
}

