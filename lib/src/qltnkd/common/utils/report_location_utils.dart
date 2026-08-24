// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:geolocator/geolocator.dart';

class ReportLocationUtils {
  static const Duration saveTimeout = Duration(seconds: 10);

  static Future<void> requestPermissionOnAppStart() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (_) {}
  }

  static Future<Position> getCurrentPositionForSave({
    bool showLocationServiceDialog = true,
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (showLocationServiceDialog) {
          await rShowMyDialogOkCancel(
              'Ứng dụng cần sử dụng vị trí để có thể thực hiện kiểm tra',
              title: 'Cấp quyền truy cập',
              firstTitle: 'Không cấp phép',
              firstAction: () {},
              secondTitle: 'Cấp phép',
              secondFunction: () async {
                await Geolocator.openLocationSettings();
              });
        }
        return null;
      }

      final hasPermission = await _ensurePermission();
      if (!hasPermission) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: saveTimeout,
      ).timeout(saveTimeout);
      
      if (position == null) {
         position = await Geolocator.getLastKnownPosition();
      }
      return position;
    } catch (_) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (e) {
        return null;
      }
    }
  }

  static Future<bool> _ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<void> checkInAndSendLocation(String reportId) async {

    ProgressHUD.show();
    Position position;
    try {
      position = await getCurrentPositionForSave();
      if (position != null) {
        await ReportRepository().sendLocation(reportId, position: position);
      }
    } finally {
      ProgressHUD.dismiss();
    }

    if (position != null) {
      await rShowDialogOneButton('Đã lấy tọa độ thành công (Kinh độ : ${position.longitude.toStringAsFixed(8)}, Vĩ độ : ${position.latitude.toStringAsFixed(8)})');
    } else {
      await rShowDialogOneButton('Không thể lấy tọa độ. Vui lòng kiểm tra lại định vị thiết bị.');
    }
  }
}
