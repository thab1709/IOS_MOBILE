// @dart=2.9
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({this.fieldModel});

  final FieldModel fieldModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: fieldModel?.style?.getAlignment(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(fieldModel?.title ?? '',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: fieldModel.style?.getColor(fieldModel?.style?.color) ?? Colors.black)),
          Container(
            height: fieldModel?.subTitle?.isEmpty == true ? 0 : null,
            child: Text(fieldModel?.subTitle ?? '',
                style:
                TextStyle(fontWeight: FontWeight.w300, fontSize: 16, color: fieldModel.style?.getColor(fieldModel?.style?.color) ?? Colors.black)),
          )
        ],
      ),
    );
  }
}

