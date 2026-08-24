// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';

class CheckBoxView extends StatefulWidget {
  CheckBoxView({@required this.fieldModel, this.enable}) {
    fieldModel.value = fieldModel?.value != 'true' ? 'false' : 'true';
  }

  final FieldModel fieldModel;
  final bool enable;

  @override
  _CheckBoxViewState createState() => _CheckBoxViewState();
}

class _CheckBoxViewState extends State<CheckBoxView> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
          value: widget?.fieldModel?.value == 'true',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: RAppColor.highlightColor70,
          onChanged: widget.enable == null || widget.enable == false
              ? null
              : (newValue) => {
                    setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.fieldModel.value = newValue ? 'true' : 'false';
                    })
                  }),
    );
  }
}

