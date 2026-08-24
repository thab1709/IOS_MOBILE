// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../../app_env.dart';
import '../../htld/common/utils/alert_dialog_utils.dart';
import '../enum/app_code.dart';
import '../login/login_controller.dart';
import '../shared/app_shared.dart';

void changeColorStatusBarLight() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
}

String getWeekOfYear(String dateStr) {
  // Set start of week is monday
  final oldLocate = Intl.defaultLocale;
  Intl.defaultLocale = 'en_GB';
  final datetime = DateTime.parse(dateStr);
  final numberWeek = Jiffy(datetime).week;
  Intl.defaultLocale = oldLocate;
  return '$numberWeek/${datetime.year}';
}

String formatHHMMSS(int seconds) {
  final hours = (seconds / 3600).truncate();
  final second = (seconds % 3600).truncate();
  final minutes = (seconds / 60).truncate();

  final hoursStr = (hours).toString().padLeft(2, '0');
  final minutesStr = (minutes).toString().padLeft(2, '0');
  final secondsStr = (second % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return '$minutesStr:$secondsStr';
  }

  return '$hoursStr:$minutesStr:$secondsStr';
}

String formatDDHHMMSS(int seconds) {
  if (seconds < 0) seconds = 0;
  final duration = Duration(seconds: seconds);

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  final days = duration.inDays;
  final hours = duration.inHours.remainder(24);
  final minutes = duration.inMinutes.remainder(60);
  final secs = duration.inSeconds.remainder(60);

  final daysStr = twoDigits(days);
  final hoursStr = twoDigits(hours);
  final minutesStr = twoDigits(minutes);
  final secondsStr = twoDigits(secs);

  return '$daysStr:$hoursStr:$minutesStr:$secondsStr';
}

Future getFileSize(String filepath, int decimals) async {
  final file = File(filepath);
  final bytes = await file.length();
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  final i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

Future<String> getNameByLocation(double lat, double long) async {
  if (lat == null || long == null) {
    return '';
  }

  try {
    final placemarks = await placemarkFromCoordinates(lat, long);
    if (placemarks?.isEmpty == true) {
      return '';
    } else {
      var location = placemarks.firstWhereOrNull((element) {
        return element.street.toLowerCase().contains('tòa nhà');
      });

      location ??= placemarks.firstWhereOrNull((element) {
        return !element.street.contains('+') &&
            !element.street.toLowerCase().contains('đường chưa đặt tên');
      });

      location ??= placemarks.first;
      return '${location.street ?? ''}, ${location.subAdministrativeArea ?? ''}, ${location.administrativeArea ?? ''}';
    }
  } catch (_) {
    debugPrint(_.toString());
    return '';
  }
}

Future showDialogUpdateApp() async {
  await showDialogError(
      'Có phiên bản mới. Vui lòng cập nhập lên phiên bản mới nhất',
      action: () async {
    await AppShared.instance.persistentUserToken('');
    await LaunchApp.openApp(
      androidPackageName: 'com.deploygate', //open Deploy gate
      iosUrlScheme: 'itms-beta://', //open TestFlight
      openStore: true,
    );
    await SystemNavigator.pop();
  });
}

Future<File> showSelectImageBottomSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    enableDrag: false,
    backgroundColor: Colors.black26,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (context) {
            return StatefulBuilder(
              builder: (context, state) {
                return Wrap(
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Vui lòng chọn',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    const Divider(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        final status = await Permission.storage.status;
                        if (status.isGranted) {
                          final file =
                              await getImage(ImageSource.gallery, context);
                          Navigator.pop(context, file);
                        } else {
                          final statuses = await [
                            Permission.storage,
                          ].request();
                          if (statuses.isNotEmpty) {
                            final file =
                                await getImage(ImageSource.gallery, context);
                            Navigator.pop(context, file);
                          } else {
                            Navigator.pop(context, null);
                          }
                        }
                      },
                      child: Container(
                          width: double.infinity,
                          height: 56,
                          alignment: Alignment.center,
                          child: const Text(
                            'Chọn từ thư viện',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          )),
                    ),
                    const Divider(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        final status = await Permission.camera.status;
                        if (status.isGranted) {
                          final file =
                              await getImage(ImageSource.camera, context);
                          Navigator.pop(context, file);
                        } else {
                          final statuses = await [
                            Permission.camera,
                          ].request();
                          if (statuses.isNotEmpty) {
                            final file =
                                await getImage(ImageSource.camera, context);
                            Navigator.pop(context, file);
                          } else {
                            Navigator.pop(context, null);
                          }
                        }
                      },
                      child: Container(
                          width: double.infinity,
                          height: 56,
                          alignment: Alignment.center,
                          child: const Text(
                            'Chụp ảnh',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          )),
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}

Future<List<dynamic>> showSelectMultiImageBottomSheet(
    BuildContext context, int max,
    {List<String> imagesSelectedInPopup}) async {
  return showModalBottomSheet(
    context: context,
    enableDrag: false,
    backgroundColor: Colors.black26,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomSheet(
          onClosing: () {},
          enableDrag: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, state) {
                return Wrap(
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Vui lòng chọn',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    const Divider(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        final status = await Permission.storage.status;
                        if (status.isGranted) {
                          final assets = await AssetPicker.pickAssets(context,
                              maxAssets: max,
                              requestType: RequestType.image,
                              imagesSelectedInPopup: imagesSelectedInPopup,
                              textDelegate: VietNamText());
                          final filesResult = <File>[];
                          if (assets == null || assets.isEmpty) {
                            Navigator.pop(context, filesResult);
                            return;
                          }
                          await Future.forEach(assets, (element) async {
                            final file = await element.file;
                            filesResult.add(file);
                          });
                          Navigator.pop(context, filesResult);
                        } else {
                          final statuses = await [
                            Permission.storage,
                          ].request();
                          if (statuses.isNotEmpty) {
                            final assets = await AssetPicker.pickAssets(context,
                                maxAssets: max,
                                requestType: RequestType.image,
                                imagesSelectedInPopup: imagesSelectedInPopup,
                                textDelegate: VietNamText());
                            final filesResult = <File>[];
                            if (assets == null || assets.isEmpty) {
                              Navigator.pop(context, filesResult);
                              return;
                            }
                            await Future.forEach(assets, (element) async {
                              final file = await element.file;
                              filesResult.add(file);
                            });
                            Navigator.pop(context, filesResult);
                          } else {
                            Navigator.pop(context, []);
                          }
                        }
                      },
                      child: Container(
                          width: double.infinity,
                          height: 56,
                          alignment: Alignment.center,
                          child: const Text(
                            'Chọn từ thư viện',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          )),
                    ),
                    const Divider(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        final status = await Permission.camera.status;
                        if (status.isGranted) {
                          final file =
                              await getImage(ImageSource.camera, context);
                          if (file == null) {
                            Navigator.pop(context, <File>[]);
                          } else {
                            Navigator.pop(context, [file]);
                          }
                        } else {
                          final statuses = await [
                            Permission.camera,
                          ].request();
                          if (statuses.isNotEmpty) {
                            final file =
                                await getImage(ImageSource.camera, context);
                            if (file == null) {
                              Navigator.pop(context, <File>[]);
                            } else {
                              Navigator.pop(context, [file]);
                            }
                          } else {
                            Navigator.pop(context, <File>[]);
                          }
                        }
                      },
                      child: Container(
                          width: double.infinity,
                          height: 56,
                          alignment: Alignment.center,
                          child: const Text(
                            'Chụp ảnh',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          )),
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}

Future<DateTimeRange> showTimePickerSearch(
    BuildContext context, DateTime fromDate, DateTime toDate) async {
  final currentTime = DateTime.now().toUtc();
  DateTimeRange dateTimeRangeInit;
  if (fromDate != null && toDate != null) {
    dateTimeRangeInit = DateTimeRange(start: fromDate, end: toDate);
  }
  return showDateRangePicker(
      context: context,
      locale: const Locale('vi', 'VN'),
      initialDateRange: dateTimeRangeInit,
      firstDate:
          DateTime(currentTime.year - 5, currentTime.month, currentTime.day),
      lastDate:
          DateTime(currentTime.year + 2, currentTime.month, currentTime.day));
}

Future<List<File>> openCamera(BuildContext context) async {
  final status = await Permission.camera.status;
  if (status.isGranted) {
    final file = await getImage(ImageSource.camera, context);
    return [file];
  } else {
    final statuses = await [
      Permission.camera,
    ].request();
    if (statuses.isNotEmpty) {
      final file = await getImage(ImageSource.camera, context);
      return [file];
    }
  }

  return [];
}

Future<File> getImage(ImageSource imageSource, BuildContext context) async {
  if (imageSource == ImageSource.camera) {
    File fileCapture;
    await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
          shouldDeletePreviewFile: true,
          textDelegate: VietNamTextCamera(),
          onEntitySaving: (context, cameraPickerViewType, file) {
            fileCapture = file;
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }),
    );
    if (fileCapture != null) {
      return fileCapture;
    } else {
      debugPrint('No image selected.');
      return null;
    }
  } else {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: imageSource, imageQuality: 30, maxWidth: 1024, maxHeight: 1024);
    if (pickedFile != null) {
      final size = await getFileSize(pickedFile.path, 1);
      debugPrint('Selected image with size: $size');
      return File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
      return null;
    }
  }
}

bool isLimitImageSize(File image) {
  final bytes = image.readAsBytesSync().lengthInBytes;
  final kb = bytes / 1024;
  final mb = kb / 1024;
  debugPrint('isLimitImageSize: $mb');
  return mb > 1.0;
}

Image imageFromBase64String(String base64String) {
  return Image.memory(
    base64Decode(base64String.replaceFirst('data:image/png;base64,', '')),
    width: 200,
    fit: BoxFit.fitWidth,
  );
}

bool isClickAble(Function(DateTime) setClickTime, DateTime clickTime) {
  final currentTime = DateTime.now();
  if (clickTime == null) {
    setClickTime(currentTime);
    return true;
  }
  if (currentTime.difference(clickTime).inMilliseconds < 6000) {
//set this difference time in seconds
    return false;
  }

  setClickTime(currentTime);
  return true;
}

Future openAppSSO(String type) async {
  String appCode;
  if (AppShared.instance.getAppType() == AppType.KDTN) {
    appCode = AppCode.KDTN;
  } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
    appCode = AppCode.CAOTHE;
  } else {
    return;
  }

  final uri = Uri.parse('com.evnhanoi.sso://open?appCode=$appCode&type=$type');
  try {
    final result = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!result) {
      await onErrorOpenAppSSO(type, appCode);
    }
  } catch (e) {
    await onErrorOpenAppSSO(type, appCode);
  }
}

Future<void> onErrorOpenAppSSO(String type, String appCode) async {
  if (type == 'logout') return;

  if (type != 'loginSSO') {
    await showMyDialogOkCancel(
      'Vui lòng cài đặt ứng dụng SSO hoặc đăng nhập bằng website',
      secondTitle: 'Cài đặt ứng dụng SSO',
      secondFunction: installAppSSO,
    );
  } else {
    await showDialogOkCancelTouchOutSite(
      'Vui lòng cài đặt ứng dụng SSO hoặc đăng nhập bằng website',
      firstTitle: 'Cài đặt ứng dụng SSO',
      firstAction: installAppSSO,
      secondTitle: 'Đăng nhập bằng website',
      secondFunction: () {
        final controller = Get.find<AppLoginController>();
        controller?.updateStatusLoginSSO(status: true);
        launchUrl(
          Uri.parse(
            'https://sso.evnhanoi.vn/sso/login?appCode=$appCode&redirectUrl=com.evn.pmis://open',
          ),
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }
}

void installAppSSO() {
  const appId = 'com.evnhanoi.sso';
  final url = Uri.parse(
    Platform.isAndroid
        ? 'market://details?id=$appId'
        : 'https://apps.apple.com/app/id$appId',
  );
  launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}

class VietNamText extends AssetsPickerTextDelegate {
  @override
  String get confirm => 'Xác nhận';

  @override
  String get cancel => 'Hủy';

  @override
  String get edit => 'Sửa';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get heicNotSupported => 'Unsupported HEIC asset type.';

  @override
  String get loadFailed => 'Tải thất bại';

  @override
  String get original => 'Gốc';

  @override
  String get preview => 'Xem trước';

  @override
  String get select => 'Chọn';

  @override
  String get emptyList => 'Danh sách trống';

  @override
  String get unSupportedAssetType => 'Unsupported HEIC asset type.';

  @override
  String get unableToAccessAll => 'Unable to access all assets on the device';

  @override
  String get viewingLimitedAssetsTip =>
      'Only view assets and albums accessible to app.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Update limited access assets list';

  @override
  String get accessAllTip => 'App can only access some assets on the device. '
      'Go to system settings and allow app to access all assets on the device.';

  @override
  String get goToSystemSettings => 'Đi tới cài đặt hê thống';

  @override
  String get accessLimitedAssets => 'Continue with limited access';

  @override
  String get accessiblePathName => 'Accessible assets';
}

class VietNamTextCamera extends CameraPickerTextDelegate {
  @override
  String get confirm => 'Xác nhận';

  @override
  String get loadFailed => 'Tải thất bại';

  @override
  String get shootingTips => 'Chạm để chụp ảnh';

  /// Default loading string for the dialog.
  @override
  String get loading => 'Đang tải…';

  /// Saving string for the dialog.
  @override
  String get saving => 'Đang lưu…';

  /// Semantics fields.
  ///
  /// Fields below are only for semantics usage. For customizable these fields,
  /// head over to [EnglishCameraPickerTextDelegate] for better understanding.
  @override
  String get sActionManuallyFocusHint => 'Tập trung tay';

  @override
  String get sActionPreviewHint => 'Xem trước';

  @override
  String get sActionRecordHint => 'Video';

  @override
  String get sActionShootHint => 'Ảnh chụp';

  @override
  String get sActionShootingButtonTooltip => 'Nút chụp ảnh';

  @override
  String get sActionStopRecordingHint => 'Dừng ghi âm';
}

