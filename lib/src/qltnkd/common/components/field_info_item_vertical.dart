// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:flutter/material.dart';

class FieldInfoItemVertical extends StatelessWidget {
  const FieldInfoItemVertical(
      {Key key,
        this.title,
        this.value,
        this.valueWidget,
        this.padding})
      : super(key: key);

  final String title;
  final String value;
  final EdgeInsets padding;
  final Widget valueWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: _buildContent(),
    );
  }


  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? '', style: const TextStyle(color: Colors.grey, fontSize: 15)),
        const SizedBox(height: PaddingSize.micro),
        if(value != null)
        Text(
          value ?? '',
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if(valueWidget != null)
          valueWidget
      ],
    );
  }
}

