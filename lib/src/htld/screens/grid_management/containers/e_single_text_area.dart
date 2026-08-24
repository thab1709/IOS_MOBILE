// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:flutter/material.dart';

class ESingleTextArea extends StatefulWidget {
  ESingleTextArea({this.hint, this.value = '', this.isEnable = true, this.onChanged, this.isRequire = false}){
    editingController.text = value;
  }

  final String hint;
  final String value;
  final bool isEnable;
  final Function(String) onChanged;
  final bool isRequire;
  final TextEditingController editingController = TextEditingController();

  @override
  _ESingleTextAreaState createState() => _ESingleTextAreaState();
}

class _ESingleTextAreaState extends State<ESingleTextArea> {
  bool isValueEmpty = false;
  bool defaultEnable = UserRole.hasPermissionCreate();

  @override
  Widget build(BuildContext context) {
    if(widget.isRequire){
      isValueEmpty = widget?.editingController?.text?.isEmpty ?? false;
    }

    widget.editingController.selection = TextSelection.fromPosition(TextPosition(offset: widget.editingController.text.length));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: widget.editingController,
        maxLines: 30,
        textInputAction: TextInputAction.done,
        onChanged: defaultEnable ? (value){
          widget.onChanged(value);
          if(value?.isNotEmpty == true && isValueEmpty){
            setState(() {
              isValueEmpty = false;
            });
          }
        } : null,
        enabled: widget.isEnable,
        minLines: 3,
        decoration: InputDecoration(
          fillColor: Colors.white,
            filled: true,
            enabled: defaultEnable,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            isDense: true,
            errorStyle: const TextStyle(fontSize: 1),
            errorText: isValueEmpty ? AppStrings.requireText : null,
            border: const OutlineInputBorder(),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
      ),
    );
  }
}

