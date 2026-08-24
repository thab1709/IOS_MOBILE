// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

Future<void> rShowMyDialogOkCancel(String content,
    {String title,
    String firstTitle,
    Function firstAction,
    String secondTitle,
    Function secondFunction}) async {
  final size = Get.size.width;
  var sizePadding = 30.0;
  if(size >= 600){
    sizePadding = 100.0;
  }

  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: EdgeInsets.only(left: sizePadding, right: sizePadding),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 150,
                // maxHeight: 250
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        title ?? 'Thông báo',
                        style: const TextStyle(
                            color: RAppColor.highlightColor70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(content, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: RButton(
                              title: firstTitle ?? 'Huỷ',
                              titleColor: Colors.black,
                              color: Colors.grey.shade300,
                              action: () {
                                Get.back();
                                if (firstAction != null) {
                                  firstAction();
                                }
                              }),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: RButton(
                              title: secondTitle ?? 'Xác nhận',
                              action: () {
                                Get.back();
                                if (secondFunction != null) {
                                  secondFunction();
                                }
                              }),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
      barrierDismissible: true);
}

Future<void> rShowDialogOneButton(String content, {Function action, String buttonTitle}) async {
  if (content == null) {
    return;
  }
  final size = Get.size.width;
  var sizePadding = 30.0;
  if(size >= 600){
    sizePadding = 100.0;
  }
  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: EdgeInsets.only(left: sizePadding, right: sizePadding),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Get.width >= 600 ? Get.width / 2 : Get.width,
                minHeight: 150,
                // maxHeight: 250
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                // height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Thông báo',
                        style: TextStyle(
                            color: RAppColor.highlightColor70,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: content?.startsWith('<html>') == true
                          ? Html(data: content)
                          : GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: content)).then((value) {
                                  SnackBarHUD.show('Sao chép thành công');
                                });
                              },
                              child: Text(content ?? 'Lỗi không xác định')),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RButton(
                            title: buttonTitle ?? 'Xác nhận',
                            action: () {
                              Get.back();
                              if (action != null) {
                                action();
                              }
                            })
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
      barrierDismissible: true);
}

Future<void> rShowDialogVersionApp(String content, BuildContext context, {Function action}) async {
  if (content == null) {
    return;
  }
  final size = Get.size.width;
  var sizePadding = 30.0;
  if(size >= 600){
    sizePadding = 100.0;
  }
  return showDialog(
      barrierDismissible: true, context: context, builder: (context) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
              insetPadding: EdgeInsets.only(left: sizePadding, right: sizePadding),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Get.width >= 600 ? Get.width / 2 : Get.width,
                  minHeight: 150,
                  // maxHeight: 250
                ),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  // height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Thông báo',
                          style: TextStyle(
                              color: RAppColor.highlightColor70,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: content?.startsWith('<html>') == true
                            ? Html(data: content)
                            : GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: content)).then((value) {
                                SnackBarHUD.show('Sao chép thành công');
                              });
                            },
                            child: Text(content ?? 'Lỗi không xác định')),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RButton(
                              title: 'Xác nhận',
                              action: () {
                                Get.back();
                                if (action != null) {
                                  action();
                                }
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  });
}

Future<String> rShowInputDialog(String title, {String hintText = 'Nhập ghi chú (nếu có)'}) async {
  String inputText = '';
  final result = await Get.dialog<bool>(
    AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 18, color: RAppColor.highlightColor70, fontWeight: FontWeight.bold)),
      content: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        maxLines: 3,
        onChanged: (val) => inputText = val,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(backgroundColor: RAppColor.highlightColor70),
          child: const Text('Xác nhận'),
        ),
      ],
    ),
  );
  if (result == true) {
    return inputText;
  }
  return null;
}

