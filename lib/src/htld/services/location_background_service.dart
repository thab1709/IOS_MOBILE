// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/services/responsitory/location_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../../htdct/common/constance/strings.dart';
import '../../htdct/common/utils/alert_dialog_utils.dart';

class LocationServiceBackground {
  static final shared = LocationServiceBackground();
  final locationService = LocationRepository();

  void updateLocationToServer(String id) {
    if (AppShared.instance.getUserProfile().position != UserRole.worker &&
        id == null) {
      return;
    }

    requestPermission().then((value) {
      if (value == true) {
        Geolocator.getCurrentPosition().then((position) async {
          // save location to server
          locationService.updateLocation(
              position.latitude, position.longitude, id);
          // save location to local
          // NOTE(hau) : save location to local
          await AppShared.instance.saveLocationToCache(position);
        });
      }
    });
  }

  Future<bool> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await hShowMyDialogOkCancel(
          '${HighElectricStrings.requiredLocationPermission}',
          title: 'Cấp quyền truy cập',
          firstTitle: 'Không cấp phép',
          firstAction: () {},
          secondTitle: 'Cấp phép',
          secondFunction: () async {
            await Geolocator.openLocationSettings();
          });
      return true;
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
              return true;
            }
          } else {
            return true;
          }
        });
      } else {
        final result = await Geolocator.requestPermission();
        if (result == LocationPermission.always ||
            result == LocationPermission.whileInUse) {
          return true;
        } else {
          return true;
        }
      }
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      return true;
    } else {
      return true;
    }

    return true;
  }
}

