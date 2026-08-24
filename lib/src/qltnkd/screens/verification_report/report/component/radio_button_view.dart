// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/constance/field_type.dart';
import '../report_controller.dart';

class RadioButtonView extends StatefulWidget {
  const RadioButtonView(
      {@required this.fieldModel, @required this.refresh, this.enable});

  final FieldModel fieldModel;
  final bool enable;
  final Function refresh;

  @override
  _RadioButtonViewState createState() => _RadioButtonViewState();
}

class _RadioButtonViewState extends State<RadioButtonView> {
  final ReportController reportController = Get.put(ReportController());

  @override
  void initState() {
    super.initState();

    if (widget.fieldModel.defaultValue != null &&
        (widget.fieldModel.value == null || widget.fieldModel.value.isEmpty)) {
      widget.fieldModel.value = widget.fieldModel.defaultValue;
    }
  }

  @override
  void didUpdateWidget(covariant RadioButtonView oldWidget) {
   if(widget.fieldModel.value != oldWidget.fieldModel.value) {
     oldWidget.fieldModel.value = widget.fieldModel.value;
   }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Radio(
          value: widget?.fieldModel?.value,
          activeColor: RAppColor.highlightColor70,
          onChanged: widget.enable == null || widget.enable == false
              ? null
              : (newValue) async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await reportController.reportModel.value.fieldsModel
                      .firstWhere(
                          (element) => element.fieldType == FieldType.taps,
                          orElse: () => null)
                      .changeValueRadioBT(widget?.fieldModel?.relationKey);
                  widget.fieldModel.value = 'true';
                  widget.refresh();
                },
          groupValue: 'true'),
    );
  }
}

