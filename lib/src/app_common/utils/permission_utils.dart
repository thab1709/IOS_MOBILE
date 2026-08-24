// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> requestPermission() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled) {
    await hShowDialogOneButton('Vui lòng bật vị trí');
    return false;
  }

  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    if (Platform.isAndroid) {
      await showPopupRequestLocation(action: (granted) async {
        if (granted) {
          final result = await Geolocator.requestPermission();
          if (result == LocationPermission.always ||
              result == LocationPermission.whileInUse) {
            return true;
          } else {
            //   return false;
          }
        } else {
          //  return false;
        }
      });
    } else {
      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.always ||
          result == LocationPermission.whileInUse) {
        return true;
      } else {
        //  return false;
      }
    }
  } else if (permission == LocationPermission.deniedForever ||
      permission == LocationPermission.unableToDetermine) {
    await hShowDialogOneButton('Vui lòng bật vị trí');
    return false;
  } else {
    return true;
  }

  return false;
}

