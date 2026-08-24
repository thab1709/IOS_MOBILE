// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:flutter/material.dart';

class ETextField extends StatefulWidget {
  ETextField({this.title, this.id, this.weight, this.horizontalPadding = 16, this.enable,
    this.value, this.titlePadding, this.onChange,
    this.spaceBetween, this.contentHorizontalPadding = 16,
    this.textAlign = TextAlign.left, this.titleStyle, this.isRequire = false}){
    controller.text = value;
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  }

  final TextEditingController controller = TextEditingController();
  final String title;
  final FontWeight weight;
  final double horizontalPadding;
  final double contentHorizontalPadding;
  final bool enable;
  final String value;
  final EdgeInsetsGeometry titlePadding;
  final String id;
  final double spaceBetween;
  final TextAlign textAlign;
  final TextStyle titleStyle;
  final bool isRequire;
  final Function(String) onChange;

  @override
  _ETextFieldState createState() => _ETextFieldState();
}

class _ETextFieldState extends State<ETextField> {
  bool isEmpty = false;
  final defaultEnable = UserRole.hasPermissionCreate();

  @override
  Widget build(BuildContext context) {
    if(widget.isRequire){
      isEmpty = widget?.controller?.text?.isEmpty ?? false;
    }
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 8, horizontal: widget.horizontalPadding),
      //child: Device.get().isTablet ?  _tabletWidget() :  _mobileWidget()
      child: _mobileWidget()
    );
  }

  Widget _mobileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: widget.titleStyle ?? TextStyle(fontWeight: widget.weight , fontSize: 16),
        ),
        const SizedBox(height: 6),
        TextField(
          textAlign: widget.textAlign,
          controller: widget.controller,
          onChanged: (value){
            widget.onChange(value);
            if(value?.isNotEmpty == true && isEmpty){
              setState(() {
                isEmpty = false;
              });
            }
          },
          enabled: widget.enable ?? defaultEnable,
          decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
              filled: !(widget.enable ?? true),
              isDense: true,
              errorStyle: const TextStyle(fontSize: 1),
              errorText: isEmpty ? AppStrings.requireText : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: widget.contentHorizontalPadding)),
        )
      ],
    );
  }
}

