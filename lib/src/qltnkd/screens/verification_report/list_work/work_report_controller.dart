// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/common.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/user_repository.dart';
import 'package:get/get.dart';

import '../../../models/create_report_not_plan_model.dart';

class WorkReportController extends GetxController {
  final service = ReportRepository();
  final profileService = ReportUserRepository();

  List<StringOptionModel> unitOptions = <StringOptionModel>[];

  DateTime fromDateTime = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDateTime = DateTime.now();

  String fromDate = DateTime.now().subtract(const Duration(days: 30)).formatFirstDate();
  String toDate = DateTime.now().formatSecondDate();
  String equipment = '';
  String equipmentType = '0';
  String detailEquipmentType = '0';
  String reportNumber = '';
  String stampNumber = '';
  String performer = '';
  String searchTerm = '';

  String unit = '';
  String statusWork = '0';
  String workType = '0';


  List<EquipmentTypes> equipmentTypeList = RxList.empty();
  List<StringOptionModel> detailEquipmentList = RxList.empty();
  List<StringOptionModel> equipmentTypes = RxList.empty();
  StreamController<int> filterController = StreamController<int>.broadcast();
  StreamController<int> groupTypeController = StreamController<int>.broadcast();
  RxInt workGroupType = 0.obs; // 0 = Đơn vị, 1 = Cho các X

  @override
  void dispose() {
    filterController.close();
    groupTypeController.close();
    super.dispose();
  }

  ListDelegate delegate;

  final optionsStatus = const [
    IntOptionModel(RAppStrings.all, 0),
    IntOptionModel(RAppStrings.unfulfilled, ReportWorkStatusType.unfulfilled),
    IntOptionModel(RAppStrings.doing, ReportWorkStatusType.doing),
    IntOptionModel(RAppStrings.done, ReportWorkStatusType.done),
  ];

  @override
  void onInit() {
    super.onInit();
    getUnits();
  }

  void clearFilter() {
    equipment = '';
    reportNumber = '';
    stampNumber = '';
    performer = '';
    fromDateTime = DateTime.now();
    toDateTime = DateTime.now();
    unit = '0';
    statusWork = '0';
    workType = '0';
    equipmentType = '0';
    detailEquipmentType = '0';
    fromDate = '';
    toDate = '';
  }

  void reloadTab(int index) {
    filterController.sink.add(index);
  }

  Future getUnits() async {
    Future online () async {
      final response = await service.getUnits();
      if (response.isLoadSuccess) {
        unitOptions =
            response.data.map((e) => StringOptionModel(e.name, e.id)).toList();
        unit = response?.data?.first?.id ?? '';
      } else {
        await rShowDialogOneButton(response.message);
      }
    }
    Future offline () async {
      unitOptions.clear();
      final response = await RLocalDataManager.instance.getUnitWorkOffline() ?? List.empty();
      unitOptions.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((element) {
        unitOptions.add(StringOptionModel(element.name, element.id));
      });
    }
    final isOnline = await RConnection.shared.checkConnection();
    if (isOnline) {
      await online();
    }else{
      await offline();
    }
  }

  Future<bool> checkVersionApp() async {
    // final isOnline = await RConnection.shared.checkConnection();
    // if(!isOnline){
    //   return true;
    // }
    // final appVerSion = await getDeviceInfo();
    // final userProfileResponse = await profileService.getUserProfile(isBackgroundMode: true);
    // if (userProfileResponse.isLoadSuccess && userProfileResponse?.data != null) {
    //   if (!userProfileResponse.data.getAppVersion().contains(appVerSion)) {
    //     return false;
    //   }
    // }

    return true;
  }

  Future getDataEquipmentReport() async {
    final isOnline = await RConnection.shared.checkConnection();
    if (isOnline) {
      final response = await service.getDataUnscheduled();
      if (response.isLoadSuccess) {
        equipmentTypes.clear();
        detailEquipmentList.clear();
        equipmentTypes.add(StringOptionModel(RAppStrings.all, '0'));
        detailEquipmentList.add(StringOptionModel(RAppStrings.all, '0'));
        response.data.equipmentTypes.forEach((element) {
          equipmentTypes.add(StringOptionModel(element.name, element.id));
          detailEquipmentList.addAll(element.equipmentDetails.map((e) => StringOptionModel(e.name, e.id)));
          equipmentTypeList.add(EquipmentTypes(
            id: element.id,
            name: element.name,
            equipmentDetails: element.equipmentDetails,
          ));
        });
      }
    } else {
      equipmentTypes.clear();
      final response = await RLocalDataManager.instance.getUnscheduledReportOffline();
      equipmentTypes.clear();
      detailEquipmentList.clear();
      equipmentTypes.add(StringOptionModel(RAppStrings.all, '0'));
      detailEquipmentList.add(StringOptionModel(RAppStrings.all, '0'));

      response?.equipmentTypes?.forEach((element) {
        equipmentTypes.add(StringOptionModel(element.name, element.id));
        detailEquipmentList.addAll(element.equipmentDetails.map((e) => StringOptionModel(e.name, e.id)));
        equipmentTypeList.add(EquipmentTypes(
          id: element.id,
          name: element.name,
          equipmentDetails: element.equipmentDetails,
        ));
      });
    }
  }
}

