// @dart=2.9
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:get/get.dart';

import '../../common/base/base_delegate.dart';
import '../../common/utils/alert_dialog_utils.dart';
import '../../services/responsitory/location_repository.dart';
import 'models/location_line_detail.dart';
import 'models/substation_detail_location.dart';
import 'models/user_location.dart';

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
      final fistLocation = data?.data?.userLocations?.firstOrNull?.locations?.firstOrNull;
      if (substationDetailLocation?.substationLongitude == null && fistLocation?.latitude == null) {
        await hShowDialogOneButton('Không tìm thấy vị trí của trạm biến áp', action: () {
          Get.back();
        });
      } else {
        if(substationDetailLocation?.substationLongitude == null) {
          substationDetailLocation =
              SubstationDetailLocation(
                  substationLatitude: fistLocation.latitude,
                  substationLongitude: fistLocation.longitude,
                  userLocations: data?.data?.userLocations
              );
        }

      }
      delegate.loadSuccess();
    } else {
      await hShowDialogOneButton(data.message);
    }
  }

  Future<void> getLocationLineDetail(String id) async {
    final data = await repository.getLocationLineDetail(id);
    if (data.isLoadSuccess) {
       lineKinks = data?.data?.substationLocations ?? [];
       lineKinks.removeWhere((element) => element.latitude == null || element.longitude == null);
       userLocation = data.data.userLocations;
       final defaultLocation = userLocation?.firstOrNull?.locations?.firstOrNull;
       if (lineKinks?.isEmpty == true  && defaultLocation?.latitude == null) {
         await hShowDialogOneButton('Không tìm thấy vị trí của đường dây', action: () {
           Get.back();
         });
         return;
       }

       if (lineKinks?.isEmpty == true) {
        lineKinks.add(SubstationLocations(
            latitude: defaultLocation.latitude,
            longitude: defaultLocation.longitude));
      }

      delegate.loadSuccess();
    } else {
      await hShowDialogOneButton(data.message);
    }
  }
}
