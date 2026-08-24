// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htld/common/base/base_delegate.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/location_line_detail.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/substation_detail_location.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/user_location.dart';
import 'package:evnmobile/src/htld/services/responsitory/location_repository.dart';
import 'package:get/get.dart';

class MapPageController extends GetxController {
  final repository = LocationRepository();
  //Substation
  SubstationDetailLocation substationDetailLocation;

  //Line
  List<SubstationLocations> lineKinks = [];
  List<UserLocation> userLocation = [];
  BaseDelegate delegate;

  Future<void> getLocationDetail(String id) async {
    final data = await repository.getSubstationDetail(id);
    if (data.isLoadSuccess) {
      substationDetailLocation = data.data;
    }
    if (substationDetailLocation?.substationLongitude == null && substationDetailLocation?.substationLatitude == null) {
      await showDialogError('Không tìm thấy vị trí của trạm biến áp', action: () {
        Get.back();
      });
    } else {
      delegate.loadSuccess();
    }
  }

  Future<void> getLocationLineDetail(String id) async {
    final data = await repository.getLocationLineDetail(id);
    if (data.isLoadSuccess) {
       lineKinks = data.data.substationLocations;
       lineKinks.removeWhere((element) => element.latitude == null || element.longitude == null);
       userLocation = data.data.userLocations;
    }
    if (lineKinks?.isEmpty ?? true) {
      await showDialogError('Không tìm thấy vị trí của đường dây', action: () {
        Get.back();
      });
    }
    delegate.loadSuccess();
  }
}
