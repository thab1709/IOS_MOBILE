// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../common/components/button_40.dart';
import '../../../common/constance/app_color.dart';
import '../../../common/constance/app_icon.dart';
import '../scan_qr/scan_qr_screen.dart';

class SearchView extends StatefulWidget {
  const SearchView({this.onChange, this.isShowQR = true, this.focusNode, Key key}) : super(key: key);
  final Function(String) onChange;
  final bool isShowQR;
  final FocusNode focusNode;
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controllerTextEditNode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: SizedBox(
            child: Stack(
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.black87),
                  focusNode: widget.focusNode,
                  controller: _controllerTextEditNode,
                  onChanged: (value) {
                    widget.onChange(TiengViet.parse(value.trim().toLowerCase()));
                    setState(() {

                    });
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 50, 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        color: HighElectricAppColor.nature03,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        color: HighElectricAppColor.nature03,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        color: HighElectricAppColor.nature03,
                      ),
                    ),
                    hintStyle: TextStyle(
                        color: HighElectricAppColor.nature04,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    hintText: 'Nhập từ khóa',
                  ),
                ),
                if(_controllerTextEditNode?.text?.isNotEmpty == true)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(onPressed: () {
                    _controllerTextEditNode.clear();
                    widget.onChange('');
                    setState(() {

                    });
                  }, icon: const Icon(Icons.close, color: Colors.black,)),
                )
              ],
            ),
          ),
        ),
        if(widget.isShowQR == true)
        const SizedBox(
          width: 12,
        ),
        if(widget.isShowQR == true)
        GestureDetector(
          onTap: () async {
            final result = await Get.to(() => const HScanQRScreen());
            if (result != null && result is String) {
              _controllerTextEditNode.text = result;
              widget.onChange(TiengViet.parse(result.toLowerCase()));
              setState(() {

              });
            }
          },
          child: Button40(
            child: SvgPicture.asset(
              HighElectricAppIcon.qrcode,
              width: 18,
              height: 20,
              fit: BoxFit.scaleDown,
            ),
          ),
        )
      ],
    );
  }
}

