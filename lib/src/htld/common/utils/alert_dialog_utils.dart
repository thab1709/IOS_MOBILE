// @dart=2.9
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

Future<bool> showCheckList(
    BuildContext context, Widget widget, String title) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text(title),
            content: Container(
                width: MediaQuery.of(context).size.width, child: widget),
            actions: <Widget>[
              EButton(
                title: 'Huỷ',
                action: () => {Navigator.pop(context), false},
                color: AppColor.colorOrange,
              ),
              EButton(
                title: 'Lưu',
                action: () => {Navigator.pop(context, true)},
              ),
            ],
            buttonPadding: const EdgeInsets.only(right: 20, left: 20),
          ),
        );
      });
}

Future<OptionData> showCheckListLine(
  BuildContext context,
  BasePopupWidget widget,
  String title, {
  bool enable = true,
}) async {
  return showDialog<OptionData>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text(title),
            content: Container(width: Get.width, child: widget),
            actions: <Widget>[
              EButton(
                title: '${enable ? 'Huỷ' : 'Đóng'}',
                action: () => {Navigator.pop(context), null},
                color: AppColor.colorOrange,
              ),
              if (enable)
                EButton(
                  title: 'Lưu',
                  action: () => {widget.saveData()},
                ),
            ],
            buttonPadding: const EdgeInsets.only(right: 20, left: 20),
          ),
        );
      });
}

Future<bool> showPopupLine(
    BuildContext context, BasePopupWidget widget, String title) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text(title),
            content: Container(
                width: MediaQuery.of(context).size.width, child: widget),
            actions: <Widget>[
              EButton(
                title: 'Huỷ',
                action: () => {Navigator.pop(context), false},
                color: AppColor.colorOrange,
              ),
              EButton(
                title: 'Lưu',
                action: () => {widget.saveData()},
              ),
            ],
            buttonPadding: const EdgeInsets.only(right: 20, left: 20),
          ),
        );
      });
}

Future<bool> showPopupCheckList(BuildContext context, String title,
    BasePopupWidget widget, ActionType type) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: AlertDialog(
              title: Text(title),
              content: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Container(
                    width: MediaQuery.of(context).size.width, child: widget),
              ),
              actions: <Widget>[
                EButton(
                  title: type != ActionType.view ? 'Huỷ' : 'Đóng',
                  action: () => {Navigator.pop(context, false)},
                  color: AppColor.colorOrange,
                ),
                if (type != ActionType.view)
                  EButton(
                    title: 'Lưu',
                    action: () => {widget.saveData()},
                  ),
              ],
              buttonPadding: const EdgeInsets.only(right: 20, left: 20),
            ),
          ),
        );
      });
}

// Future<LineWeirdoMessage> showLinePopupCheckList(BuildContext context, String title, BasePopupWidget widget, ActionType type) async {
//   return showDialog<LineWeirdoMessage>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return WillPopScope(
//           onWillPop: () async {
//             return false;
//           },
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             resizeToAvoidBottomInset: true,
//             body: AlertDialog(
//               title: Text(title),
//               content: Container(
//                   width: MediaQuery.of(context).size.width, child: widget),
//               actions: <Widget>[
//                 EButton(title: type != ActionType.view ? 'Huỷ' : 'Đóng', action: () => {Navigator.pop(context, null)}, color: AppColor.colorOrange,),
//                 if (type != ActionType.view) EButton(title: 'Lưu', action: () => {
//                   widget.saveData()
//                 },),
//               ],
//               buttonPadding: const EdgeInsets.only(right: 20, left: 20),
//             ),
//           ),
//         );
//       });
// }

Future<void> showMyDialogOkCancel(String content,
    {String firstTitle,
    Function firstAction,
    String secondTitle,
    Function secondFunction}) async {
  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Thông báo',
                        style: TextStyle(
                            color: AppColor.highlightColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(content),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EButton(
                            title: firstTitle ?? 'Huỷ',
                            titleColor: Colors.grey,
                            color: Colors.white,
                            action: () {
                              Get.back();
                              if (firstAction != null) {
                                firstAction();
                              }
                            }),
                        const SizedBox(
                          width: 24,
                        ),
                        EButton(
                            title: secondTitle ?? 'Xác nhận',
                            action: () {
                              Get.back();
                              if (secondFunction != null) {
                                secondFunction();
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

Future<void> showDialogOkCancelTouchOutSite(
  String content, {
  String firstTitle,
  Function firstAction,
  String secondTitle,
  Function secondFunction,
}) async {
  return Get.dialog(
    InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Dialog(
          insetPadding: const EdgeInsets.only(left: 30, right: 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 150,
              // maxHeight: 250
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Thông báo',
                      style: TextStyle(
                          color: AppColor.highlightColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(content),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: EButton(
                          title: firstTitle ?? 'Huỷ',
                          action: () {
                            Get.back();
                            if (firstAction != null) {
                              firstAction();
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: EButton(
                          title: secondTitle ?? 'Xác nhận',
                          action: () {
                            Get.back();
                            if (secondFunction != null) {
                              secondFunction();
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// Future<void> showDialogOneButton(
//     BuildContext context, String content, String action, Function toTo,
//     {String title, bool requireAction = false}) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (context) {
//       return WillPopScope(
//         onWillPop: () async {
//           return !requireAction;
//         },
//         child: AlertDialog(
//           title: title == null ? null : Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 Text(content),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: toTo,
//               child: Text(action),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
Future<void> showDialogValidateData() async {
  return Get.dialog(
    WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        title: const Text('Thông báo'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const [
              Text('Vui lòng nhập đầy đủ thông tin'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    ),
  );
}

Future<bool> checkLocationPermission() async {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    await showMyDialogOkCancel(
        'Để tiếp tục sử dụng chức năng, ứng dụng yêu cầu cấp quyền truy cập vị trí.',
        firstTitle: 'Huỷ',
        secondTitle: 'Cài đặt', secondFunction: () {
      Geolocator.openLocationSettings();
    });
    return false;
  } else {
    return true;
  }
}

Future<void> showDialogOneButton(String content,
    {String title = 'Thông báo'}) async {
  return Get.dialog(
    WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    ),
  );
}

Future<void> showDialogError(String content, {Function action}) async {
  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
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
                            color: AppColor.highlightColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: content?.startsWith('<html>') == true
                          ? Html(data: content ?? '')
                          : Text(content ?? ''),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EButton(
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
          )),
      barrierDismissible: true);
}

Future<void> showPopupRequestLocation({Function(bool) action}) async {
  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 20, right: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 150,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Cấp quyền truy cập',
                        style: TextStyle(
                            color: AppColor.highlightColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                          'Ứng dụng cần sử dụng vị trí để có thể thực hiện kiểm tra'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EButton(
                            title: 'Không cấp phép',
                            titleColor: AppColor.highlightColor,
                            color: Colors.white,
                            action: () {
                              Get.back();
                              if (action != null) {
                                action(false);
                              }
                            }),
                        const SizedBox(
                          width: 2,
                        ),
                        EButton(
                            title: 'Cấp phép',
                            action: () {
                              Get.back();
                              if (action != null) {
                                action(true);
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

