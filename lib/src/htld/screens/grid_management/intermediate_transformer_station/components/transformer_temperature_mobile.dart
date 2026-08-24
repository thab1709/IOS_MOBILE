// @dart=2.9
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/temperature.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_dot_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../containers/e_drop_down.dart';
import '../../containers/e_radio_button.dart';
import '../../containers/e_text_field.dart';

class TransformerTemperatureMobile extends StatelessWidget {
  TransformerTemperatureMobile(
      {@required this.data, this.title, this.onChange});

  final List<Temperature> data;
  final String title;
  final titleStyle = const TextStyle(
      color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600);
  final Function(Temperature model) onChange;
  final RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return _mobileWidget();
  }

  Widget _mobileWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: ELabel(title: title),
          ),
          Container(height: 1, color: Colors.grey.shade300),
          _renderPageView(),
        ],
      ),
    );
  }

  Widget _renderPageView() {
    final list = data.map(_renderDetail).toList();
    return Container(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 270,
              child: PageView(
                  onPageChanged: (value) {
                    currentIndex.value = value;
                  },
                  children: list),
            ),
            Obx(() => EDotView(
                  lenght: data.length,
                  currentIndex: currentIndex.value,
                )),
            const SizedBox(
              height: 8,
            )
          ],
        ));
  }

  Widget _renderDetail(Temperature model) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        ETextField(
          title: 'Tên MBA',
          titleStyle: titleStyle,
          value: model.equipmentName,
          onChange: (value) {
            model.equipmentName = value;
            onChange(model);
          },
        ),
        ETextField(
          title: 'Nhiệt độ MBA',
          titleStyle: titleStyle,
          value: model.temperature,
          onChange: (value) {
            model.temperature = value;
            onChange(model);
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Flexible(
          child: ERadioButton(BTOptions,
              textStyle: titleStyle,
              title: 'Hệ thống làm mát',
              defaultValue: model?.coolingStatus ?? 0,
              onChange: (option, mess) {
            if (option.value != model.coolingStatus) {
              model.coolingStatus = option?.value ?? 0;
              onChange(model);
            }
          }),
        ),
      ],
    );
  }
}

