// @dart=2.9
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../tab_form_screen.dart';

class ExpandView extends StatefulWidget {
  const ExpandView({@required this.fieldModel});

  final FieldModel fieldModel;

  @override
  _ExpandViewState createState() => _ExpandViewState();
}

class _ExpandViewState extends State<ExpandView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Get.to(TabFormScreen(
          widget.fieldModel,
          isChildren: true,
        ));
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.edit,
          )),
    );
  }
}

