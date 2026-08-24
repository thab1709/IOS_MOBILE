// @dart=2.9
import 'dart:math' show pow, pi;

import 'package:evnmobile/src/app_common/utils/permission_utils.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/work_model.dart';
import '../constance/strings.dart';
import 'alert_dialog_utils.dart';

int getWorkType(TestType subStationType, TicketType ticketType) {
  if (subStationType == TestType.subStation &&
      ticketType == TicketType.periodicDay) {
    return 1;
  } else if (subStationType == TestType.subStation &&
      ticketType == TicketType.periodicNight) {
    return 2;
  } else if (subStationType == TestType.line &&
      ticketType == TicketType.periodicMonth) {
    return 5;
  } else if (subStationType == TestType.line &&
      ticketType == TicketType.periodicNight) {
    return 6;
  }

  return 1;
}

double roundDouble(double value, int places) {
  final double mod = pow(10.0, places);
  return (value * mod).round().toDouble() / mod;
}

double rad(double x) {
  return x * pi / 180;
}

Future<Position> getCurrentPosition({bool isShowLoading = true}) async {
  final isAccept = await requestPermission();
  if (!isAccept) {
    return null;
  }
  if (isShowLoading) {
    ProgressHUD.show();
  }
  try {
    final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 20));
    if (isShowLoading) {
      ProgressHUD.dismiss();
    }
    return location;
  } catch (_) {
    if (isShowLoading) {
      ProgressHUD.dismiss();
    }
    return null;
  }
}

Future<Position> checkValidLocation() async {
  final location = await getCurrentPosition();
  if (location == null) {
    await hShowDialogOneButton('Không tìm thấy vị trí thiết bị');
    return null;
  }

  if (location?.isMocked == true) {
    await hShowDialogOneButton('${HighElectricStrings.isMockedLocation}');
    return null;
  }

  return location;
}

Future<Position> checkValidDistance({
  @required Position location,
  @required Entity entity,
}) async {
  if (entity?.latitude == null ||
      entity?.latitude == 0 ||
      entity?.longitude == null ||
      entity?.longitude == 0) {
    return location;
  }

  if (location == null || location.latitude == null) {
    await hShowDialogOneButton('Lỗi lấy vị trí thiết bị');
    return null;
  }

  if (location?.isMocked == true) {
    await hShowDialogOneButton('${HighElectricStrings.isMockedLocation}');
    return null;
  }

  // if (location.accuracy >= entity?.distance) {
  //   await hShowDialogOneButton(
  //       'Độ chính xác GPS của thiết bị quá thấp, sai số lên đến ${location.accuracy.toStringAsFixed(2)}m. Vui lòng thử lại');
  //   return null;
  // }

  final distanceInMeters = Geolocator.distanceBetween(location.latitude,
      location.longitude, entity?.latitude, entity?.longitude);
  if (distanceInMeters > entity?.distance) {
    await FirebaseCrashlytics.instance.recordError(
        Exception('Check lỗi vị trí 21'), StackTrace.fromString('fromString'),
        information: ['Sai số ${location.accuracy.toStringAsFixed(2)}m'],
        reason:
            'locationUser:${location.latitude}, ${location.longitude}__locationSub:${entity?.latitude}, ${entity?.longitude} __distance:${entity?.distance} __entity:${entity?.toString()}__$distanceInMeters',
        fatal: false);
    await hShowDialogOneButton(
        '${HighElectricStrings.invalidDistance}${entity?.distance} m');
    return null;
  } else {
    return location;
  }
}

