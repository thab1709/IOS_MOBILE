// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showDialogGuildInputCharacter({@required Function(String) onSelect}) async {
  final size = Get.size.width;
  var sizePadding = 30.0;
  if(size >= 600){
    sizePadding = 100.0;
  }
  Widget _buildItem(String value) {
    return InkWell(
      onTap: () {
        onSelect(value);
        Get.back();
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(value),
          ),
        ),
      ),
    );
  }

  return Get.dialog(

      Dialog(
        insetPadding: EdgeInsets.only(left: sizePadding, right: sizePadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 150,
            // maxHeight: 250
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 26, left: 26, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ký tự đặc biệt',
                    style: TextStyle(
                        color: RAppColor.highlightColor70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      _buildItem('Φ'),
                      _buildItem('δ'),
                      _buildItem('ε'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildItem('π'),
                      _buildItem('µ'),
                      _buildItem('Ω'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildItem('φ'),
                      _buildItem('£'),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RButton(
                            title: 'Đóng',
                            titleColor: Colors.black,
                            color: Colors.grey.shade100,
                            action: () {
                              Get.back();
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true);
}

