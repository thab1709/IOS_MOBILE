// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:flutter/material.dart';

class ETextArea extends StatefulWidget {
  ETextArea(
      {this.title,
      this.value,
      this.onChange,
      this.weight,
      this.enable = true,
      this.isRequire = false,
      this.minLine = 3,
      Key key
      }) : super(key: key) {
    editingController.text = value;
    editingController.selection = TextSelection.fromPosition(
        TextPosition(offset: editingController.text.length));
  }

  final TextEditingController editingController = TextEditingController();
  final String title;
  final String value;
  final FontWeight weight;
  final bool enable;
  final int minLine;
  final bool isRequire;
  final Function(String) onChange;

  @override
  _ETextAreaState createState() => _ETextAreaState();
}

class _ETextAreaState extends State<ETextArea> {
  bool isEmpty = false;
  bool defaultEnable = UserRole.hasPermissionCreate();

  @override
  void initState() {
    super.initState();
    widget.editingController.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.editingController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRequire) {
      isEmpty = widget?.editingController?.text?.isEmpty ?? false;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      //child: Device.get().isPhone ? buildPhone() : buildTablet(),
      child: buildPhone(),
    );
  }

  Row buildTablet() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            widget.title ?? '',
            style: TextStyle(fontSize: 16, fontWeight: widget.weight),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: TextField(
            controller: widget.editingController,
            onChanged: (value) {
              widget.onChange(value);
              if (value?.isNotEmpty == true && isEmpty) {
                setState(() {
                  isEmpty = false;
                });
              }
            },
            maxLines: 30,
            enabled: widget.enable ?? defaultEnable,
            textInputAction: TextInputAction.done,
            minLines: widget.minLine,
            decoration: InputDecoration(
                isDense: true,
                errorStyle: const TextStyle(fontSize: 1),
                fillColor:
                    widget.enable ?? true ? Colors.white : Colors.grey.shade100,
                filled: !(widget.enable ?? true),
                errorText: isEmpty ? AppStrings.requireText : null,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
          ),
        )
      ],
    );
  }

  Column buildPhone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title ?? '',
          style: TextStyle(fontSize: 16, fontWeight: widget.weight),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.editingController,
          onChanged: (value) {
            widget.onChange(value);
            if (value?.isNotEmpty == true && isEmpty) {
              setState(() {
                isEmpty = false;
              });
            } else {
              isEmpty = true;
            }
          },
          maxLines: 30,
          enabled: widget.enable ?? defaultEnable,
          textInputAction: TextInputAction.done,
          minLines: widget.minLine,
          decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.grey.shade100,
              errorStyle: const TextStyle(fontSize: 1),
              filled: !(widget.enable ?? true),
              errorText: isEmpty ? AppStrings.requireText : null,
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
        )
      ],
    );
  }
}

