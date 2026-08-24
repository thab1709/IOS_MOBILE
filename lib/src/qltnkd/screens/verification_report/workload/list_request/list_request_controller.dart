// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:get/get.dart';

import '../../../../../app_common/shared/app_shared.dart';
import '../../../../common/constance/strings.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../common/utils/connection.dart';
import '../../../../models/option_model.dart';
import '../../../../offline_service/local_data_manager.dart';
import '../../../../services/responsitory/workload_repository.dart';

class ListRequestController extends GetxController {
  String searchTerm = '';
  List<StringOptionModel> unitOptions = <StringOptionModel>[];
  List<StringOptionModel> unitOptionsOriginal = <StringOptionModel>[];
  String unit = '';
  String fromDate = '';
  String toDate = '';
  DateTime fromDateTime = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDateTime = DateTime.now();
  int ticketRequestType = 0;
  final repo = WorkloadRepository();
  final userProfile = AppShared.instance.getUserProfile();
  StreamController<int> filterController = StreamController<int>.broadcast();

  void clearFilter() {
    ticketRequestType = 0;
    fromDateTime = DateTime.now();
    toDateTime = DateTime.now();
    unit = '';
    fromDate = '';
    toDate = '';
  }

  void setDefaultDate() {
    fromDate = '';
    toDate = '';
    fromDateTime = DateTime.now().subtract(const Duration(days: 30));
    toDateTime = DateTime.now();
  }

  void onDispose() {
    filterController.close();
  }

  void reloadTab(int index) {
    Get.back();
    filterController.sink.add(index);
  }

  Future getUnits() async {
    Future online() async {
      final response = await repo.getAllUnits();
      if (response.isLoadSuccess) {
        unitOptions =
            response.data.map((e) => StringOptionModel(e.name, e.id)).toList();
        unit = response?.data?.first?.id ?? '';
        unitOptionsOriginal = unitOptions.sublist(1, unitOptions.length - 1);
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    Future offline() async {
      unitOptions.clear();
      final response =
          await RLocalDataManager.instance.getUnitWorkOffline() ?? List.empty();
      unitOptions.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((element) {
        unitOptions.add(StringOptionModel(element.name, element.id));
      });
      unitOptionsOriginal = unitOptions.sublist(1, unitOptions.length - 1);
    }

    final isOnline = await RConnection.shared.checkConnection();
    if (isOnline) {
      await online();
    } else {
      await offline();
    }
  }
}

