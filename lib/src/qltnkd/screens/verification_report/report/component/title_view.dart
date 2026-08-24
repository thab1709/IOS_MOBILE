// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:flutter/material.dart';

class CustomTitleView extends StatelessWidget {
  const CustomTitleView({this.fieldModel});

  final FieldModel fieldModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: fieldModel?.style?.getAlignment(),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          //color: fieldModel?.style?.getColor(fieldModel?.style?.backgroundColor),
          color: fieldModel?.style?.backgroundColor != null
              ? RAppColor.highlightColor70
              : Colors.white,
          border: fieldModel?.style?.borderColor != null
              ? Border.all(
                  color: fieldModel?.style
                      ?.getColor(fieldModel?.style?.borderColor))
              : Border(
                  top: fieldModel?.style?.borderTopWidth != null
                      ? BorderSide(
                          color: fieldModel.style
                              ?.getColor(fieldModel?.style?.borderTopColor))
                      : BorderSide.none,
                  bottom: fieldModel?.style?.borderBottomWidth != null
                      ? BorderSide(
                          color: fieldModel.style
                              ?.getColor(fieldModel?.style?.borderBottomColor))
                      : BorderSide.none,
                  left: fieldModel?.style?.borderLeftWidth != null
                      ? BorderSide(
                          color: fieldModel.style
                              ?.getColor(fieldModel?.style?.borderLeftColor))
                      : BorderSide.none,
                  right: fieldModel?.style?.borderRightWidth != null
                      ? BorderSide(
                          color: fieldModel.style
                              ?.getColor(fieldModel?.style?.borderRightColor))
                      : BorderSide.none)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(fieldModel?.title ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: fieldModel.style?.getColor(fieldModel?.style?.color) ??
                      Colors.black)),
          Container(
            height: fieldModel?.subTitle?.isEmpty == true ? 0 : null,
            child: Text(fieldModel?.subTitle ?? '',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color:
                        fieldModel.style?.getColor(fieldModel?.style?.color) ??
                            Colors.black)),
          )
        ],
      ),
    );
  }
}

