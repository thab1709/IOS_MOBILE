// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:flutter/material.dart';

class ReportActionButton extends StatelessWidget {
  const ReportActionButton({
    @required this.title,
    @required this.action,
    Key key,
    this.padding,
  }) : super(key: key);

  final String title;
  final Function action;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.only(top: 16, bottom: 10),
      child: RButton(
        title: title,
        maxSize: true,
        action: action,
      ),
    );
  }
}

