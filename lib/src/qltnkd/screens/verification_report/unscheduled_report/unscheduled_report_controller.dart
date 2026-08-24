// @dart=2.9
import 'package:evnmobile/src/app_common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/models/create_report_not_plan_model.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

import '../../../../app_common/shared/app_shared.dart';

class UnscheduledReportController extends GetxController {
  final service = ReportRepository();

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  String fromDate = '';
  String toDate = '';
  String unit = '0';
  String workType = '0';
  String reportType = ReportStatus.reportNotPlan.toString();
  String teamId = '0';
  String userId = '0';
  String locationReport = '0';
  String content = '';
  String departmentId = '0';

  RxList<ListReportModel> listReport = RxList.empty();

  int page = 1;
  final isHasLoadMore = false.obs;
  final isShowLoading = false.obs;
  bool isFirstLoad = false;
  ListDelegate delegate;

  final optionsStatus = const [
    IntOptionModel(RAppStrings.all, ReportStatusType.all),
    IntOptionModel(RAppStrings.workImplementing, ReportStatusType.Implementing),
    IntOptionModel(RAppStrings.rejected, ReportStatusType.Rejected),
    IntOptionModel(RAppStrings.waitingForTeamApproval, ReportStatusType.WaitingForTeamApproval),
    IntOptionModel(RAppStrings.waitingForCenterApproval, ReportStatusType.WaitingForCenterApproval),
    IntOptionModel(RAppStrings.approvalCompany, ReportStatusType.WaitingForCompanyApproval),
    IntOptionModel(RAppStrings.approved, ReportStatusType.Completed),
  ];

  List<EquipmentTypes> equipmentTypeList = RxList.empty();
  List<StringOptionModel> department = RxList.empty();
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
    if (AppShared.instance.getUserProfile().isHasCreateFormReport() && !RUserRole.isOperator) {
      getDataUnscheduledReport();
    }
    getTeams();
    getListUser();
    getSubstation();
  }

  Future getDepartment() async {
    Future getDepartmentOnline() async {
      final response = await service.getDepartment();
      if (response.isLoadSuccess) {
        department.add(StringOptionModel(RAppStrings.all, '0'));
        response.data.forEach((e) => department.add(StringOptionModel(e.name, e.id)));
      }
    }

    Future getDepartmentOffline() async {
      department.clear();
      final response = await RLocalDataManager.instance.getDepartmentOffline() ?? List.empty();
      department.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((e) => department.add(StringOptionModel(e.name, e.id)));
    }

    if (await Connection.shared.isHasConnection()) {
      await getDepartmentOnline();
    } else {
      await getDepartmentOffline();
    }
  }

  void reloadLoad() {
    getFormReport(ListTypeLoad.refresh);
  }

  void _initDateSearch() {
    final currentDate = DateTime.now();
    final date1 = DateTime(currentDate.year, currentDate.month, 1);
    final date = DateTime(currentDate.year, currentDate.month + 1, 0);
    fromDateTime = date1;
    toDateTime = date;
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
    reloadLoad();
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
      final response = await RLocalDataManager.instance.getTeamsOffline() ?? List.empty();
      teams.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((e) => teams.add(StringOptionModel(e.name, e.id)));
    }

    if (await Connection.shared.isHasConnection()) {
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
      final response = await RLocalDataManager.instance.getPerformerOffline() ?? List.empty();
      users.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((e) => users.add(StringOptionModel(e.name, e.id)));
    }

    if (await Connection.shared.isHasConnection()) {
      await getListUserOnline();
    } else {
      await getListUserOffline();
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
      final response = await RLocalDataManager.instance.getLocationReportOffline() ?? List.empty();
      listSubstation.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((e) => listSubstation.add(StringOptionModel(e.name, e.id)));
    }

    if (await Connection.shared.isHasConnection()) {
      await getSubstationOnline();
    } else {
      await getSubstationOffline();
    }
  }

  Future getDataUnscheduledReport() async {
    Future getDataUnscheduledReportOnline() async {
      final response = await service.getDataUnscheduled();
      if (response.isLoadSuccess) {
        unitOptions.add(StringOptionModel('Vui lòng chọn', '0'));
        equipmentTypes.add(StringOptionModel('Vui lòng chọn', '0'));
        response.data.units.forEach((element) {
          unitOptions.add(StringOptionModel(element.name, element.id));
        });
        response.data.equipmentTypes.forEach((element) {
          equipmentTypes.add(StringOptionModel(element.name, element.id));
          equipmentTypeList.add(EquipmentTypes(
            id: element.id,
            name: element.name,
            equipmentDetails: element.equipmentDetails,
          ));
        });
      }
    }

    Future getDataUnscheduledReportOffline() async {
      unitOptions.clear();
      equipmentTypes.clear();
      final response = await RLocalDataManager.instance.getUnscheduledReportOffline();
      unitOptions.add(StringOptionModel('Vui lòng chọn', '0'));
      equipmentTypes.add(StringOptionModel('Vui lòng chọn', '0'));
      response?.units?.forEach((element) {
        unitOptions.add(StringOptionModel(element.name, element.id));
      });
      response?.equipmentTypes?.forEach((element) {
        equipmentTypes.add(StringOptionModel(element.name, element.id));
        equipmentTypeList.add(EquipmentTypes(
            id: element.id, name: element.name, equipmentDetails: element.equipmentDetails));
      });
    }

    if (await Connection.shared.isHasConnection()) {
      await getDataUnscheduledReportOnline();
    } else {
      await getDataUnscheduledReportOffline();
    }
  }

  Future getFormReport(ListTypeLoad type) async {
    Future getReportsOnline() async {
      if (type == ListTypeLoad.loadMore) {
        page = page + 1;
      } else if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
        page = 1;
      } else if (type == ListTypeLoad.refresh) {
        page = 1;
      }

      final response = await service.getFormReport(
          fromDate: fromDate,
          toDate: toDate,
          userId: userId,
          locationReport: locationReport,
          departmentId: departmentId,
          contentReport: content,
          scheduleType: reportType,
          teamId: teamId,
          pageIndex: page,
          isNotShowLoading: type == ListTypeLoad.load);
      isFirstLoad = true;

      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        listReport.clear();
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {
        listReport.clear();
      }

      if (response.isLoadSuccess) {
        isShowLoading.value = false;
        listReport.addAll(response.data.listReport ?? List.empty());
        listReport.refresh();
        update();
      } else {
        isShowLoading.value = false;
        await rShowDialogOneButton(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    }

    Future getReportsOffline(
        {int statusReports,
        String fromDate,
        String toDate,
        String reportType,
        String departmentId,
        String userId,
        String teamId,
        String locationReport,
        String contentReport}) async {
      listReport.clear();
      final response = await RLocalDataManager.instance.getReportsOffline(
              reportStatus: statusReports,
              fromDate: fromDate,
              toDate: toDate,
              reportType: reportType,
              departmentId: departmentId,
              userId: userId,
              teamId: teamId,
              locationReport: locationReport,
              contentReport: contentReport) ??
          List.empty();
      isFirstLoad = true;
      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {}

      listReport.assignAll(response);
      listReport.refresh();
    }

    if (await Connection.shared.isHasConnection()) {
      await getReportsOnline();
    } else {
      await getReportsOffline(
          statusReports: 0,
          fromDate: fromDate,
          toDate: toDate,
          reportType: workType == '0' ? '' : workType,
          departmentId: departmentId == '0' ? '' : departmentId,
          userId: userId == '0' ? '' : userId,
          teamId: teamId == '0' ? '' : teamId,
          locationReport: locationReport == '0' ? '' : locationReport,
          contentReport: content);
    }
  }
}

