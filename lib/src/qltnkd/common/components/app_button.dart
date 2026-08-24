// @dart=2.9
import 'package:flutter/material.dart';

import '../themes/colorx.dart';

class RButton extends StatelessWidget {
  const RButton({@required this.title, @required this.action, this.color, this.maxSize, this.enable, this.titleColor, this.borderColor,this.borderRadius});

  final String title;
  final Function action;
  final Color color;
  final Color titleColor;
  final Color borderColor;
  final bool maxSize;
  final bool enable;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxSize ?? false ? double.maxFinite : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 6)),
        border: Border.all(color: borderColor ?? Colors.white.withOpacity(0), width: 1),
        color: enable ?? true ? color ?? RAppColor.highlightColor70 : Colors.grey,
      ),
      child: TextButton(
          onPressed: action,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(title,
                style: TextStyle(
                    color: titleColor ?? Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
          )),
    );
  }
}

