// @dart=2.9
import 'package:evnmobile/src/htdct/models/line/popups/test_info_general_model.dart';
import 'package:flutter/material.dart';
import '../../../../containers/e_text_form_field.dart';
import '../../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';
import 'test_info_general_controller.dart';

Widget buildContent(TestInfoGeneralController _controller) {
  final model = _controller.dataModel.value as TestInfoGeneralModel;
  return Column(
    children: [
      ExpansionWidget(
        invalid: _controller.invalid.value,
        isHeader: true,
        isCamera: false,
        title: 'Thông tin kiểm tra chung',
        children: <Widget>[
          ETextFormField(
            hint: 'Nhập thông tin',
            title: 'Nhiệt độ môi trường',
            isNumpad: true,
            isRequied: true,
            invalid: _controller.invalid.value,
            value: _controller.temperature.value,
            onChangeInput: (value) {
              _controller.temperature.value = value;
            },
          ),
          ETextFormField(
            hint: 'Nhập thông tin',
            title: 'Độ ẩm môi trường',
            isNumpad: true,
            isRequied: true,
            invalid: _controller.invalid.value,
            value: _controller.humidity.value,
            onChangeInput: (value) {
              _controller.humidity.value = value;
            },
          ),
        ],
      ),
    ],
  );
}

