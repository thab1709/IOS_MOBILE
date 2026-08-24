// @dart=2.9
import 'package:flutter/material.dart';

import '../../../common/constance/app_color.dart';

class ECheckBox extends StatefulWidget {
  ECheckBox({
    this.title,
    this.onClicked,
    this.checked = false,
    this.isSubstation = false,
    this.isAllowEdit = true,
    this.isHeader = false,
    this.invalid = false,
  });

  Function onClicked;
  String title;
  bool checked;
  bool isSubstation;
  bool isAllowEdit;
  bool isHeader;
  bool invalid;
  @override
  State<ECheckBox> createState() => _ECheckBoxState();
}

class _ECheckBoxState extends State<ECheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Center(
          child: InkWell(
        onTap: () {
          if (widget.isAllowEdit) {
            setState(() {
              if (!widget.isSubstation) widget.checked = !widget.checked;
            });
            widget.onClicked(widget.checked);
          }
        },
        child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: widget.invalid ==true?Colors.red: widget.checked
                      ? HighElectricAppColor.primary10
                      : HighElectricAppColor.nature03,
                  width: 2,
                ),
                color: widget.checked
                    ? HighElectricAppColor.primary10
                    : HighElectricAppColor.nature01),
            child: Visibility(
              visible: widget.checked,
              child: const Icon(
                Icons.check,
                size: 17,
                color: HighElectricAppColor.nature01,
              ),
            )),
      )),
      if (widget.title != null) _buildTitle(),
    ]);
  }

  Widget _buildTitle() {
    return Flexible(
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              widget.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: widget.isHeader?FontWeight.bold: FontWeight.w400,
                color: widget.isAllowEdit
                    ? HighElectricAppColor.nature06
                    : HighElectricAppColor.nature04,
              ),
            ),
          )
        ],
      ),
    );
  }
}

