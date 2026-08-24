// @dart=2.9
import 'package:dropdown_search/dropdown_search.dart';
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/themes/colorx.dart';
import '../../../../../../common/themes/styles.dart';
import '../../../../../../models/option_model.dart';
import '../../../../containers/e_button.dart';

class AbnormalDropdownWidget extends StatefulWidget {
  final List<OptionModelString> options;
  final String defaultOption;
  final Function(String) onSelected;
  final bool invalid;
  final bool disable;
  final Function(String) addAbnormalOption;
  final String title;
  final String placeholder;

  const AbnormalDropdownWidget(
      {Key key,
      this.options,
      this.defaultOption,
      this.onSelected,
      this.invalid = false,
      this.disable = false,
      this.addAbnormalOption,
      this.title,
      this.placeholder
      })
      : super(key: key);

  @override
  State<AbnormalDropdownWidget> createState() => _AbnormalDropdownWidgetState();
}

class _AbnormalDropdownWidgetState extends State<AbnormalDropdownWidget> {
  TextEditingController nameAbnormal = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.disable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Text(
                widget.title??'Tên bất thường',
                style: Styles.titleTextField,
              ),
              const Text('*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DropdownSearch<OptionModelString>(
                    emptyBuilder: (context, searchEntry) => const Center(child: Text('Không tìm thấy bất thường',style:TextStyle(color:Colors.grey))),
                    popupTitle: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Bất thường',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                    showSearchBox: true,
                    searchDelay: const Duration(seconds: 1),
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                    dropdownSearchDecoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: widget.disable,
                        contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: (widget.invalid &&
                                      widget.defaultOption == null)
                                  ? Colors.red
                                  : Colors.grey),
                        )),
                    items: widget.options ?? [],
                    onChanged: widget.disable == false ?  (data) async {
                      widget.onSelected(data.value);
                    } : null,
                    selectedItem: getDefaultOption(),
                    dropdownBuilder: _customDropDownString,),
              ),
              if(widget.disable == false)
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                    onTap: () async {
                      await _showMyDialog();
                    },
                    child: const Icon(
                      Icons.add,
                      size: 45,
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

 OptionModelString getDefaultOption() {
    final list = (widget.options ?? [])
        .where((element) => element.value == widget.defaultOption);
    return list.isEmpty ? null : list.first;
  }

  Widget _customDropDownString(
      BuildContext context, OptionModelString selectedItems) {
    return Text(
      selectedItems == null ? (widget.placeholder ?? '') : selectedItems.title,
      style: TextStyle(
          color: selectedItems == null ? Colors.grey : Colors.black,
          fontSize: 16),
    );
  }

  Future<void> _showMyDialog() async {
    var name = '';
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Thêm mới'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Tên bất thường',
                        style: Styles.titleTextField,
                      ),
                      Text('*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    height: 80,
                    child: Form(
                      // key: formGlobalKey,
                      child: TextFormField(
                          controller: TextEditingController()..text='',
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            name = value;
                          },
                          validator: (value) {
                            if (value == null || value.isBlank) // check bắt buộc
                                {
                              return '';
                            }
                            return null;
                          },
                          decoration:  const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                              borderSide:
                              BorderSide(color: AppColor.borderColor1),
                            ),
                            hintText: 'Nhập tên bất thường',
                          ) //, user keyboard will have a button to move cursor to next line
                      ),
                    ))
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      hShowMyDialogOkCancel('Bạn có chắc muốn hủy không?',
                          secondFunction: () {
                            Get.back();
                          });
                    },
                    child: EButtonWidget(
                      text: 'Hủy',
                      textColor: HighElectricAppColor.nature01,
                      bgColor: HighElectricAppColor.primary10,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (name != null && !name.isBlank)
                      {
                        await widget.addAbnormalOption(name);
                        Get.back();
                      }
                    },
                    child: EButtonWidget(
                      text: 'Lưu',
                      textColor: HighElectricAppColor.nature01,
                      bgColor: HighElectricAppColor.primary10,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

