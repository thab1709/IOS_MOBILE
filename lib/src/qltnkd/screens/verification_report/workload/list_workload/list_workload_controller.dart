// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/workload_repository.dart';
import 'package:get/get.dart';

import '../../../../../app_common/shared/app_shared.dart';
import '../../../../common/constance/strings.dart';
import '../../../../common/utils/connection.dart';
import '../../../../models/option_model.dart';
import '../../../../offline_service/local_data_manager.dart';
import '../list_request/list_request_controller.dart';

class ListWorkloadController extends GetxController {
  String requestTicketType = '0';

  List<StringOptionModel> unitOptions = <StringOptionModel>[];
  List<StringOptionModel> unitOptionsOriginal = <StringOptionModel>[];
  List<IntOptionModel> workloadTypes = <IntOptionModel>[];
  final repo = WorkloadRepository();
  StreamController<int> filterController = StreamController<int>.broadcast();
  final userProfile = AppShared.instance.getUserProfile();
  final ListRequestController _listRequestController = Get.find();


  DateTime fromDateTime = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDateTime = DateTime.now();

  String fromDate = '';
  String toDate = '';
  String searchTerm = '';
  String unit = '';

  @override
  void dispose() {
    filterController.close();
    super.dispose();
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

  void clearFilter() {
    fromDate = '';
    toDate = '';
    unit = '0';
    requestTicketType = '0';
    _listRequestController.toDate = '';
    _listRequestController.fromDate = '';
  }

  void reloadTab(int index) {
    filterController.sink.add(index);
  }
}

