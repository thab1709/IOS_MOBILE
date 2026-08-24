// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/models/create_report_not_plan_model.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

class ListCertificateController extends GetxController {
  final service = ReportRepository();

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  final page = 1.obs;
  String fromDate = '';
  String toDate = '';
  String unit = '0';
  bool isHasLoadMore = false;
  String certificateType = '0';
  String teamId = '0';
  String userId = '0';
  String location = '0';
  String content = '';
  String departmentId = '0';
  bool isHasValueFilterChange = false;

  final optionsStatus = const [
    IntOptionModel(RAppStrings.all, CertificateStatusType.all),
    IntOptionModel(RAppStrings.workImplementing, CertificateStatusType.Implementing),
    IntOptionModel(RAppStrings.rejected, CertificateStatusType.Rejected),
    IntOptionModel(RAppStrings.waitingForTeamApproval,
        CertificateStatusType.WaitingForTeamApproval),
    IntOptionModel(RAppStrings.waitingForCenterApproval,
        CertificateStatusType.WaitingForCenterApproval),
    IntOptionModel(RAppStrings.approvalCompany,
        CertificateStatusType.WaitingForCompanyApproval),
    IntOptionModel(RAppStrings.approved, CertificateStatusType.Completed),
  ];

  List<EquipmentTypes> equipmentTypeList = RxList.empty();
  // List<EquipmentDetails>
  List<StringOptionModel> department = RxList.empty();
  RxList<ListReportModel> listReport = RxList.empty();
  List<StringOptionModel> teams = RxList.empty();
  List<StringOptionModel> users = RxList.empty();
  List<StringOptionModel> listSubstation = RxList.empty();
  List<StringOptionModel> unitOptions = RxList.empty();
  List<StringOptionModel> equipmentTypes = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    _initDateSearch();
    getDepartment();
    getTeams();
    getListUser();
    //getSubstation();
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

  void reloadAllTab() {
    isHasValueFilterChange = true;
  }

  void _initDateSearch() {
    final currentDate = DateTime.now();
    final date1 = DateTime(currentDate.year, currentDate.month, 1);
    final date = DateTime(currentDate.year, currentDate.month + 1, 0);
    fromDateTime = date1;
    toDateTime = date;
    fromDate = date1.formatFirstDate();
    toDate = date.formatSecondDate();
  }

  void clearFilter() {
    fromDate = '';
    toDate = '';
    userId = '0';
    location = '0';
    departmentId = '0';
    content = '';
    teamId = '0';
    reloadAllTab();
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

  // Future getSubstation() async {
  //   Future getSubstationOnline() async {
  //     final response = await service.getSubstation();
  //     if (response.isLoadSuccess) {
  //       listSubstation.add(StringOptionModel(RAppStrings.all, '0'));
  //       response?.data?.forEach((element) {
  //         listSubstation.add(StringOptionModel(element.name, element.id));
  //       });
  //     }
  //   }
  //
  //   Future getSubstationOffline() async {
  //     listSubstation.clear();
  //     final response =
  //         await RLocalDataManager.instance.getLocationReportOffline() ??
  //             List.empty();
  //     listSubstation.add(StringOptionModel(RAppStrings.all, '0'));
  //     response
  //         .forEach((e) => listSubstation.add(StringOptionModel(e.name, e.id)));
  //   }
  //
  //   final isOnline = await RConnection.shared.checkConnection();
  //
  //   if (isOnline) {
  //     await getSubstationOnline();
  //   } else {
  //     await getSubstationOffline();
  //   }
  // }
  //
  // Future getDataUnscheduledReport() async {
  //   Future getDataUnscheduledReportOnline() async {
  //     final response = await service.getDataUnscheduled();
  //     if (response.isLoadSuccess) {
  //       unitOptions.add(StringOptionModel('Vui lòng chọn', '0'));
  //       equipmentTypes.add(StringOptionModel('Vui lòng chọn', '0'));
  //       response.data.units.forEach((element) {
  //         unitOptions.add(StringOptionModel(element.name, element.id));
  //       });
  //       response.data.equipmentTypes.forEach((element) {
  //         equipmentTypes.add(StringOptionModel(element.name, element.id));
  //         equipmentTypeList.add(EquipmentTypes(
  //             id: element.id,
  //             name: element.name,
  //             equipmentDetails: element.equipmentDetails,
  //         ));
  //       });
  //     }
  //   }
  //
  //   Future getDataUnscheduledReportOffline() async {
  //     unitOptions.clear();
  //     equipmentTypes.clear();
  //     final response = await RLocalDataManager.instance.getUnscheduledReportOffline();
  //     unitOptions.add(StringOptionModel('Vui lòng chọn', '0'));
  //     equipmentTypes.add(StringOptionModel('Vui lòng chọn', '0'));
  //     response?.units?.forEach((element) {
  //       unitOptions.add(StringOptionModel(element.name, element.id));
  //     });
  //     response?.equipmentTypes?.forEach((element) {
  //       equipmentTypes.add(StringOptionModel(element.name, element.id));
  //       equipmentTypeList.add(EquipmentTypes(
  //           id: element.id,
  //           name: element.name,
  //           equipmentDetails: element.equipmentDetails));
  //     });
  //
  //   }
  //
  //   final isOnline = await RConnection.shared.checkConnection();
  //   if (isOnline) {
  //     await getDataUnscheduledReportOnline();
  //   } else {
  //     await getDataUnscheduledReportOffline();
  //   }
  //}
}

