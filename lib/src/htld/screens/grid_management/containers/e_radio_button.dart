// @dart=2.9
import 'package:evnmobile/src/htld/models/option_model.dart';
import 'package:evnmobile/src/htld/models/weirdo_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ERadioButton extends StatelessWidget {
  ERadioButton(this.options,
      {this.title,
      this.index,
      this.defaultValue,
      this.weight = FontWeight.w500,
      this.onChange,
      this.textStyle});

  final int index;
  final int defaultValue;
  final String title;
  final FontWeight weight;
  final List<OptionModel> options;
  final Function(OptionModel, WeirdoMessage) onChange;
  final TextStyle textStyle;
  final controller = ERadioButtonController();

  void setDefaultValueValue(int value) {
    controller.setValue(value);
    final optionModel = options.firstWhereOrNull((element) => element.value == value);

    if (value != options.first.value && optionModel != null) {
      final message = WeirdoMessage(index,
          message:
              '${title.replaceAll(':', '')} ${optionModel?.title?.toLowerCase()}');
      Future.delayed(const Duration(milliseconds: 200), () {
        onChange(optionModel, message);
      });
    }
  }

  void setupData()  {
    if(options?.isNotEmpty == true && options.first.value != null) {
      setDefaultValueValue(defaultValue ?? options.first.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    setupData();
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle ??
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: options.map((e) {
                return _renderRadioButton(e.value, e.title);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderRadioButton(int value, String title) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          value: value,
          groupValue: controller.selectedValue.value,
          onChanged: (newValue) {
            controller.setValue(newValue);
            if (onChange != null) {
              final option =
                  options.firstWhere((element) => element.value == newValue);
              final isNormal = options.first.value == newValue;
              final message = WeirdoMessage(index,
                  message: isNormal
                      ? ''
                      : '${title.replaceAll(':', '')} ${option.title.toLowerCase()}');
              onChange(option, message);
            }
          },
        ),
        Text(
          title,
          style: textStyle,
        ),
      ],
    ));
  }
}

class ERadioButtonController extends GetxController {
  final selectedValue = 0.obs;

  void setValue(int value) {
    selectedValue.value = value;
  }
}

