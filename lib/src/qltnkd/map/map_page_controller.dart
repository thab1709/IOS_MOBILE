// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/map/model/substaton_location.dart';
import 'package:evnmobile/src/qltnkd/map/model/user_location.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

class ReportMapPageController extends GetxController {
  final repository = ReportRepository();

  ReportSubstationLocation substationLocation;
  final userLocations= <ReportUserLocation>[].obs;

  Future<void> getReportLocation(String id) async {
    final res = await repository.getReportLocation(id);
    if (res.isLoadSuccess) {
      userLocations.assignAll(res.data.users);
      substationLocation = res.data.substation;
      userLocations.refresh();
    } else {
      await rShowDialogOneButton(res.message);
    }
  }
}

