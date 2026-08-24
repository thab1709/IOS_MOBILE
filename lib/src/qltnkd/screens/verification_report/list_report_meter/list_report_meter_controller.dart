// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/models/create_report_not_plan_model.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:get/get.dart';

import '../../../services/responsitory/bb_cong_to_repository.dart';

class ListReportMeterController extends GetxController {
  final service = BBCongToRepository();

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  final page = 1.obs;
  String fromDate = '';
  String toDate = '';
  String unit = '0';
  bool isHasLoadMore = false;
  String workType = '0';
  String reportType = '0';
  String teamId = '0';
  String userId = '0';
  String locationReport = '0';
  String content = '';
  String departmentId = '0';
  bool isNewToOld = true;

  StreamController<int> filterController = StreamController<int>.broadcast();

  @override
  void dispose() {
    filterController.close();
    super.dispose();
  }


  final optionsStatus = [
    const IntOptionModel(RAppStrings.all, ReportStatusType.all),
    const IntOptionModel(RAppStrings.workImplementing, ReportStatusType.Implementing),
    const IntOptionModel(RAppStrings.rejected, ReportStatusType.Rejected),
    const IntOptionModel(RAppStrings.waitingForTeamApproval,
        ReportStatusType.WaitingForTeamApproval),
    const IntOptionModel(RAppStrings.waitingForCenterApproval,
        ReportStatusType.WaitingForCenterApproval),
    // const IntOptionModel(RAppStrings.approvalCompany,
    //     ReportStatusType.WaitingForCompanyApproval),
    const IntOptionModel(RAppStrings.approved, ReportStatusType.Completed),
  ];

  List<EquipmentTypes> equipmentTypeList = RxList.empty();
  // List<EquipmentDetails>
  List<StringOptionModel> department = RxList.empty();
  RxList<ListReportModel> listReport = RxList.empty();
  List<StringOptionModel> teams = RxList.empty();
  List<StringOptionModel> presidentCenters = RxList.empty();
  List<StringOptionModel> presidentCompanies = RxList.empty();
  List<StringOptionModel> users = RxList.empty();
  List<StringOptionModel> listSubstation = RxList.empty();
  List<StringOptionModel> unitOptions = RxList.empty();
  List<StringOptionModel> equipmentTypes = RxList.empty();
  List<StringOptionModel> usersRoleOperationApproval = RxList.empty();


  @override
  void onInit() {
    super.onInit();
    _initDateSearch();
    //getDepartment();
    //getTeams();
    //getListUser();
    //getSubstation();
    getUnits();
    getListPresidentCenter();
    getListPresidentCompanies();
  }

  Future getDepartment() async {
    Future getDepartmentOnline() async {
      final response = await service.getDepartment();
      if (response.isLoadSuccess) {
        department.add(StringOptionModel(RAppStrings.all, '0'));
        response.data
            .forEach((e) => department.add(StringOptionModel(e.name, e.id)));
      }
    }

    Future getDepartmentOffline() async {
      department.clear();
      final response =
          await RLocalDataManager.instance.getDepartmentOffline() ??
              List.empty();
      department.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((e) => department.add(StringOptionModel(e.name, e.id)));
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getDepartmentOnline();
    } else {
      await getDepartmentOffline();
    }
  }

  void reloadTab(int index) {
    filterController.sink.add(index);
  }

  void _initDateSearch() {
    fromDateTime = DateTime.now();
    toDateTime = DateTime.now();
    fromDate = '';
    toDate = '';
  }

  void clearFilter() {
    fromDate = '';
    toDate = '';
    userId = '0';
    locationReport = '0';
    departmentId = '0';
    content = '';
    teamId = '0';
  }

  Future getUnits() async {
    Future getUnitsOnline () async {
      final response = await service.getUnits();
      if (response.isLoadSuccess) {
        unitOptions =
            response.data.map((e) => StringOptionModel(e.name, e.id)).toList();
        unit = response?.data?.first?.id ?? '';
      } else {
        await rShowDialogOneButton(response.message);
      }
    }
    Future getUnitsOffline () async {
      unitOptions.clear();
      final response = await RLocalDataManager.instance.getUnitWorkOffline() ?? List.empty();
      unitOptions.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((element) {
        unitOptions.add(StringOptionModel(element.name, element.id));
      });
    }
    final isOnline = await RConnection.shared.checkConnection();
    if (isOnline) {
      await getUnitsOnline();
    }else{
      await getUnitsOffline();
    }
  }

  Future getTeams() async {
    Future getTeamsOnline() async {
      final response = await service.getTeams();
      if (response.isLoadSuccess) {
        teams.add(StringOptionModel(RAppStrings.all, '0'));
        response.data.forEach((element) {
          teams.add(StringOptionModel(element.name, element.id));
        });
      }
    }

    Future getTeamsOffline() async {
      teams.clear();
      final response =
          await RLocalDataManager.instance.getTeamsOffline() ?? List.empty();
      teams.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((e) => teams.add(StringOptionModel(e.name, e.id)));
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getTeamsOnline();
    } else {
      await getTeamsOffline();
    }
  }

  Future getListUser() async {
    Future getListUserOnline() async {
      final response = await service.getListUser();
      if (response.isLoadSuccess) {
        users.add(StringOptionModel(RAppStrings.all, '0'));
        response.data.forEach((element) {
          users.add(StringOptionModel(element.name, element.id));
        });
      }
    }

    Future getListUserOffline() async {
      users.clear();
      final response = await RLocalDataManager.instance.getPerformerOffline() ??
          List.empty();
      users.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((e) => users.add(StringOptionModel(e.name, e.id)));
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getListUserOnline();
    } else {
      await getListUserOffline();
    }
  }

  Future getListPresidentCenter() async {
    Future getOnline() async {
      final response = await service.getListPersidentCenter();
      if (response.isLoadSuccess) {
        presidentCenters.add(StringOptionModel(RAppStrings.pleaseSelect, '0'));
        response.data.forEach((element) {
          presidentCenters.add(StringOptionModel(element.name, element.id));
        });
      }
    }

    // Future getOffline() async {
    //   users.clear();
    //   final response = await RLocalDataManager.instance.getPerformerOffline() ??
    //       List.empty();
    //   users.add(StringOptionModel(RAppStrings.all, '0'));
    //   response.forEach((e) => users.add(StringOptionModel(e.name, e.id)));
    // }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getOnline();
    } else {
     // await getListUserOffline();
    }
  }

  Future getListPresidentCompanies() async {
    Future getOnline() async {
      final response = await service.getListPresidentCompany(
          userPosition: UserPosition.KDTN_PresidentCompany.toString());
      if (response.isLoadSuccess) {
        presidentCompanies.add(StringOptionModel(RAppStrings.pleaseSelect, '0'));
        response.data.forEach((element) {
          presidentCompanies.add(StringOptionModel(element.name, element.id));
        });
      }
    }

    // Future getOffline() async {
    //   users.clear();
    //   final response = await RLocalDataManager.instance.getPerformerOffline() ??
    //       List.empty();
    //   users.add(StringOptionModel(RAppStrings.all, '0'));
    //   response.forEach((e) => users.add(StringOptionModel(e.name, e.id)));
    // }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getOnline();
    } else {
     // await getListUserOffline();
    }
  }

  Future getSubstation() async {
    Future getSubstationOnline() async {
      final response = await service.getSubstation();
      if (response.isLoadSuccess) {
        listSubstation.add(StringOptionModel(RAppStrings.all, '0'));
        response?.data?.forEach((element) {
          listSubstation.add(StringOptionModel(element.name, element.id));
        });
      }
    }

    Future getSubstationOffline() async {
      listSubstation.clear();
      final response =
          await RLocalDataManager.instance.getLocationReportOffline() ??
              List.empty();
      listSubstation.add(StringOptionModel(RAppStrings.all, '0'));
      response
          .forEach((e) => listSubstation.add(StringOptionModel(e.name, e.id)));
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getSubstationOnline();
    } else {
      await getSubstationOffline();
    }
  }

}

