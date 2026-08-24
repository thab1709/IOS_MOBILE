// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/models/additional_model.dart';
import 'package:evnmobile/src/qltnkd/models/create_report_not_plan_model.dart';
import 'package:evnmobile/src/qltnkd/models/department_model.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/models/form_info.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/models/location_offline.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_approval_history_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:evnmobile/src/qltnkd/models/stamp_model.dart';
import 'package:evnmobile/src/qltnkd/models/teams_model.dart';
import 'package:evnmobile/src/qltnkd/models/unit.dart';
import 'package:evnmobile/src/qltnkd/models/work_merge_model.dart';
import 'package:evnmobile/src/qltnkd/services/server_response.dart';
import 'package:g_json/g_json.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../common/utils/report_location_utils.dart';

class RDatabaseBoxName {
  static const nameTemp = 'nameTemp';

  static const listWork = 'rListWork';
  static const listReport = 'rListReport';
  static const listMergeReport = 'rListMergeReport';
  static const listFormTemplate = 'rListFormTemplate';
  static const formTemplate = 'rFormTemplate';
  static const reportFormDetail = 'rReportFormDetail';
  static const centerListReport = 'rCenterListReport';
  static const listTeamsReport = 'rListTeamsReport';
  static const listUserReport = 'rListUserReport';
  static const listLocationReport = 'rListLocalReport';
  static const listHistoryApprove = 'rListHistoryApprove';
  static const listUnitWork = 'rListUnitWork';
  static const listUnscheduledReport = 'rListUnscheduledReport';
  static const listStamps = 'rListStamps';
  static const rLocation = 'rLocation';
}

class RLocalDataManager {
  factory RLocalDataManager() => _instance;
  static final RLocalDataManager _instance = RLocalDataManager._internal();

  RLocalDataManager._internal() {
    //_initHive();
    //getUserProfile();
  }

  static RLocalDataManager get instance => _instance;

  UserProfileModel _userProfileModel;

  String keyListFormTemplate;
  String keyFormTemplate;
  String keyListWorks;
  String keyListMergeReport;
  String keyListReports;
  String keyReportFormDetail;
  String keyCenterListReport;
  String keyTeamListReport;
  String keyUserListReport;
  String keyLocationReport;
  String keyListHistoryApprove;
  String keyListUnitWork;
  String keyListUnscheduledReport;
  String keyRLocation;

  void getUserProfile() {
    _userProfileModel = AppShared.instance.getUserProfile();
    if(_userProfileModel.id == null) {
      return;
    }

    keyListFormTemplate = RDatabaseBoxName.listFormTemplate;
    keyFormTemplate = RDatabaseBoxName.formTemplate;
    keyListWorks = '${RDatabaseBoxName.listWork}_${_userProfileModel.id}';
    keyListReports = '${RDatabaseBoxName.listReport}_${_userProfileModel.id}';
    keyReportFormDetail =
        '${RDatabaseBoxName.reportFormDetail}_${_userProfileModel.id}';
    keyListMergeReport =
        '${RDatabaseBoxName.listMergeReport}_${_userProfileModel.id}';
    keyCenterListReport =
        '${RDatabaseBoxName.centerListReport}_${_userProfileModel.id}';
    keyTeamListReport =
        '${RDatabaseBoxName.listTeamsReport}_${_userProfileModel.id}';
    keyUserListReport =
        '${RDatabaseBoxName.listUserReport}_${_userProfileModel.id}';
    keyLocationReport =
        '${RDatabaseBoxName.listLocationReport}_${_userProfileModel.id}';
    keyListHistoryApprove =
        '${RDatabaseBoxName.listHistoryApprove}_${_userProfileModel.id}';
    keyListUnitWork =
        '${RDatabaseBoxName.listUnitWork}_${_userProfileModel.id}';
    keyListUnscheduledReport =
        '${RDatabaseBoxName.listUnscheduledReport}_${_userProfileModel.id}';
    keyRLocation = '${RDatabaseBoxName.rLocation}_${_userProfileModel.id}';
  }

  Future<void> initHive() async {
    // final directory = await path_provider.getApplicationDocumentsDirectory();
    // Hive.init(directory.path);
    await Hive.openBox(RDatabaseBoxName.listWork);
    await Hive.openBox(RDatabaseBoxName.listMergeReport);
    await Hive.openBox(RDatabaseBoxName.listReport);
    await Hive.openBox(RDatabaseBoxName.listFormTemplate);
    await Hive.openBox(RDatabaseBoxName.formTemplate);
    await Hive.openBox(RDatabaseBoxName.reportFormDetail);
    await Hive.openBox(RDatabaseBoxName.centerListReport);
    await Hive.openBox(RDatabaseBoxName.listUserReport);
    await Hive.openBox(RDatabaseBoxName.listTeamsReport);
    await Hive.openBox(RDatabaseBoxName.listLocationReport);
    await Hive.openBox(RDatabaseBoxName.listHistoryApprove);
    await Hive.openBox(RDatabaseBoxName.listUnitWork);
    await Hive.openBox(RDatabaseBoxName.listUnscheduledReport);
    await Hive.openBox(RDatabaseBoxName.listStamps);
    await Hive.openBox(RDatabaseBoxName.rLocation);
  }

  /// danh sách công việc
  Future clearWorks() async {
    final prefs = Hive.box(RDatabaseBoxName.listWork);
    await prefs.put(keyListWorks, null);
  }

  Future saveWorks(List<ReportWorkItem> worksInPage) async {
    final prefs = Hive.box(RDatabaseBoxName.listWork);
    final oldWorks = await getWorksOffline();
    final works = <ReportWorkItem>[...?oldWorks, ...?worksInPage];
    final data = jsonEncode(works.map((e) => e.toJson()).toList());
    await prefs.put(keyListWorks, data);
  }

  Future<List<ReportWorkItem>> getWorksOffline({
    int workStatus = 0,
    String searchTerm = '',
    String equipmentName = '',
    String reportNumber = '',
    String stampNumber = '',
    String reportType = '',
    String unitId = '',
    String fromDate = '',
    String toDate = '',
  }) async {
    final prefs = Hive.box(RDatabaseBoxName.listWork);
    final jsonString = prefs.get(keyListWorks);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final works = JSON(json)
        .listObject
        .map((e) => ReportWorkItem.fromJson(JSON(e)))
        .toList();

    if (searchTerm.isNotEmpty) {
      works.removeWhere((element) =>
              !element.location.contains(searchTerm) ||
              !element.equipmentName.contains(searchTerm) ||
              !element.getListNameUserImp().contains(searchTerm));

      return works;
    }
    if (equipmentName?.isNotEmpty == true) {
      works
          .removeWhere((element) => element.equipmentName != equipmentName);
    }
    if (reportNumber?.isNotEmpty == true) {
      works
          .removeWhere((element) => element.reportNumber != reportNumber);
    }
    if (stampNumber?.isNotEmpty == true) {
      works.removeWhere((element) => element.stampNumber != stampNumber);
    }
    if (unitId?.isNotEmpty == true) {
      works.removeWhere((element) => element.unitRequest != unitId);
    }
    if (reportType?.isNotEmpty == true) {
      works.removeWhere((element) => element.reportType != reportType);
    }
    if (fromDate?.isNotEmpty == true && toDate?.isNotEmpty == true) {
      final fromDateR = fromDate.toDateFormatLocal();
      final toDateR = toDate.toDateFormatLocal();
      works.removeWhere((element) {
        final dateElement = element.toDate.toDateFormatLocal();
        return fromDateR.isBefore(dateElement) && toDateR.isAfter(dateElement);
      });
    }

    if (workStatus != 0) {
      works.removeWhere((element) => element.workProgress != workStatus);
    }

    return works;
  }

  Future<ReportWorkItem> getWorkDetailOffline({String workId = ''}) async {
    final works = await getWorksOffline();
    final resultWorks =
        works.firstWhere((element) => element.id == workId, orElse: () => null);

    return resultWorks;
  }

  /// danh sách biên bản

  Future clearReports() async {
    final prefs = Hive.box(RDatabaseBoxName.listReport);
    await prefs.put(keyListReports, null);
  }

  Future saveReports(List<ListReportModel> reportsInPage) async {
    final prefs = Hive.box(RDatabaseBoxName.listReport);
    final oldReports = await getReportsOffline();
    final works = <ListReportModel>[...?oldReports, ...?reportsInPage];
    final data = jsonEncode(works.map((e) => e.toJson()).toList());
    await prefs.put(keyListReports, data);
  }

  Future saveMergeReports(List<WorkMergeModel> reportsInPage) async {
    final prefs = Hive.box(RDatabaseBoxName.listMergeReport);
    final oldReports = await getMergeReportsOffline();
    final works = <WorkMergeModel>[...?oldReports, ...?reportsInPage];
    final data = jsonEncode(works.map((e) => e.toJson()).toList());
    await prefs.put(keyListMergeReport, data);
  }

  Future<List<ListReportModel>> getReportsOffline({
    int reportStatus = 0,
    String searchTerm = '',
    String reportType,
    String locationReport,
    String statusReport,
    String userId,
    String teamId,
    String fromDate,
    String toDate,
    String departmentId,
    String contentReport,
  }) async {
    final prefs = Hive.box(RDatabaseBoxName.listReport);
    final jsonString = prefs.get(keyListReports);
    if (jsonString == null) {
      return <ListReportModel>[];
    }
    final json = jsonDecode(jsonString);
    final reports = JSON(json)
        .listObject
        .map((e) => ListReportModel.fromJson(JSON(e)))
        .toList();

    if (searchTerm.isNotEmpty) {
      reports.removeWhere((element) =>
              element.content.contains(searchTerm) ||
              element.reportNumber.contains(searchTerm) ||
              element.equipmentDetail.contains(searchTerm) ||
              element.location.contains(searchTerm));

      return reports;
    }
    if (reportType?.isNotEmpty == true) {
      reports.removeWhere((element) => element.reportType.toString() != reportType);
    }
    if (locationReport?.isNotEmpty == true) {
      reports
          .removeWhere((element) => element.location != locationReport);
    }
    // if (statusReport.isNotEmpty) {
    //   resultReports
    //       .removeWhere((element) => element.workingStatusName != statusReport);
    // }
    if (userId?.isNotEmpty == true) {
      reports.removeWhere((element) => element.userImpId != userId);
    }
    if (teamId?.isNotEmpty == true) {
      reports.removeWhere((element) => element.teamId != teamId);
    }
    if (departmentId?.isNotEmpty == true) {
      reports
          .removeWhere((element) => element.departmentId != departmentId);
    }
    if (fromDate?.isNotEmpty == true && toDate?.isNotEmpty == true) {
      final fromDateR = fromDate.toDateFormatLocal();
      final toDateR = toDate.toDateFormatLocal();
      reports.removeWhere((element) {
        final dateElement = element.createdDate.toDateFormatLocal();
        return fromDateR.isBefore(dateElement) == true &&
            toDateR.isAfter(dateElement) == true;
      });
    }

    if (reportStatus != 0) {
      reports
          .removeWhere((element) => element.workingStatus != reportStatus);
    }

    return reports ?? <ListReportModel>[];
  }

  Future clearMergeReports() async {
    final prefs = Hive.box(RDatabaseBoxName.listMergeReport);
    await prefs.put(keyListMergeReport, null);
  }

  Future<List<WorkMergeModel>> getMergeReportsOffline({
    String reportStatus,
    String searchTerm = '',
    String unitId,
    String fromDate,
    String toDate,
  }) async {
    final prefs = Hive.box(RDatabaseBoxName.listMergeReport);
    final jsonString = prefs.get(keyListMergeReport);
    if (jsonString == null) {
      return <WorkMergeModel>[];
    }
    final json = jsonDecode(jsonString);
    final reports = JSON(json)
        .listObject
        .map((e) => WorkMergeModel.fromJson(JSON(e)))
        .toList();

    if (searchTerm.isNotEmpty) {
      final searches = reports.where((element) =>
          element.location.contains(searchTerm) ||
          element.equipmentName.contains(searchTerm) ||
          element.location.contains(searchTerm) ||
          element.reportMergeModels
                  .firstWhereOrNull((element) => element.stampNumber.contains(searchTerm)) !=
              null);

      return searches;
    }
    // if (unitId?.isNotEmpty == true && unitId != '0') {
    //   reports.removeWhere((element) => element.unitId != unitId);
    // }

    if (reportStatus?.isNotEmpty == true && reportStatus != '0') {
      final filterStatusList = reports?.where((element) =>
      element?.reportMergeModels
          ?.firstWhereOrNull((element) => element.workingStatus.toString() == reportStatus) !=
          null)?.toList() ?? [];
      reports.assignAll(filterStatusList);
    }

    if (fromDate?.isNotEmpty == true && toDate?.isNotEmpty == true) {
      final fromDateR = fromDate.toDateFormatLocal();
      final toDateR = toDate.toDateFormatLocal();
      reports.removeWhere((element) {
        final dateElement = element.createdDate.toDateFormatLocal();
        return fromDateR.isBefore(dateElement) == true &&
            toDateR.isAfter(dateElement) == true;
      });
    }

    return reports ?? <WorkMergeModel>[];
  }

  Future<ListReportModel> getReportDetailOffline({String reportId = ''}) async {
    final reports = await getReportsOffline();
    final resultReports = reports
        .firstWhere((element) => element.id == reportId, orElse: () => null);
    return resultReports;
  }

  /// Danh sách mẫu biên bản
  Future clearListFormTemplate() async {
    final prefs = Hive.box(RDatabaseBoxName.listFormTemplate);
    await prefs.put(keyListFormTemplate, null);
  }

  Future saveListFormTemplate(List<FormInfo> listFormInfo) async {
    final prefs = Hive.box(RDatabaseBoxName.listFormTemplate);
    final oldFormInfo = await getListFormTemplateOffline();
    final newList = <FormInfo>[...?oldFormInfo, ...?listFormInfo];
    final data = jsonEncode(newList.map((e) => e.toJson()).toList());
    await prefs.put(keyListFormTemplate, data);
  }

  Future<List<FormInfo>> getListFormTemplateOffline() async {
    final prefs = Hive.box(RDatabaseBoxName.listFormTemplate);
    final jsonString = prefs.get(keyListFormTemplate);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final reports =
        JSON(json).listObject.map((e) => FormInfo.fromJson(JSON(e))).toList();

    return reports;
  }

  /// Mẫu biên bản
  Future saveFormTemplate(ReportModel reportModel) async {
    final prefs = Hive.box(RDatabaseBoxName.formTemplate);
    final data = jsonEncode(reportModel?.toJson());
    await prefs.put(keyFormTemplate + reportModel.id, data);
  }

  Future<ReportModel> getFormTemplate(String formId) async {
    if(formId == null){
      return null;
    }
    final prefs = Hive.box(RDatabaseBoxName.formTemplate);
    final jsonString = prefs.get(keyFormTemplate + formId);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    return ReportModel.fromJson(JSON(json));
  }

  /// Chi tiết biên bản nhập
  Future clearFormReportDetail() async {
    final prefs = Hive.box(RDatabaseBoxName.reportFormDetail);
    final reports = await getReportsOffline() ?? List<ListReportModel>.empty();

    for (final element in reports) {
      await prefs.put(keyReportFormDetail + element.id, null);
    }
  }

  Future saveReportFormDetail(ReportModelResponse reportModelResponse) async {
    final prefs = Hive.box(RDatabaseBoxName.reportFormDetail);
    final data = jsonEncode(reportModelResponse?.toJson());
    await prefs.put(keyReportFormDetail + reportModelResponse.reportId, data);
  }

  Future clearReportFormDetail(String reportId) async {
    final prefs = Hive.box(RDatabaseBoxName.reportFormDetail);
    await prefs.put(keyReportFormDetail + reportId, null);
  }

  Future<ReportModelResponse> getReportFormDetail(String reportId) async {
    try{
      final prefs = Hive.box(RDatabaseBoxName.reportFormDetail);
      final jsonString = prefs.get(keyReportFormDetail + (reportId ?? ''));
      if (jsonString == null) {
        return null;
      }
      final json = jsonDecode(jsonString);
      return ReportModelResponse.fromJson(JSON(json));
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkReportExist(String id) async {
    final currentWork = (await getWorksOffline())
        ?.firstWhereOrNull((element) => element?.id == id);
    if (currentWork == null) {
      return false;
    }
    if(!currentWork.isAllowToCreateReport){
      return true;
    }
    return false;
  }

  Future deleteWorkOffline(String id) async {
    final worksOffline = await getWorksOffline();
    final currentWork = worksOffline?.firstWhere((element) => element?.id == id);
    if (currentWork == null) {
      return;
    }

    final reports = await getMergeReportsOffline();
    reports.removeWhere((element) => element.id == currentWork.id);

    await clearMergeReports();
    await saveMergeReports(reports);
  }

  Future<ServerResponse> createReportOffline(ReportWorkItem workModel) async {
    var statusCode = 1;
    var message = '';

    if (workModel.formId == null) {
      message = 'Không tìm thấy id mẫu biên bản';
      return ServerResponse<String>(message: message, statusCode: statusCode, data: null);
    }

    //create report form detail
    final listFormReportTemplate = await getListFormTemplateOffline();
    final formTemplate = await getFormTemplate(workModel.formId);
    formTemplate.name = listFormReportTemplate
        .firstWhere((element) => element.id == workModel.formId, orElse: () => null)?.name;

    if(formTemplate == null) {
      message = 'Công việc không có mẫu biên bản này';
      return ServerResponse<String>(message: message, statusCode: statusCode, data: null);
    }


    final listWork = await getWorksOffline();
    final workItem = listWork.firstWhere((element) => element.id == workModel.id,
        orElse: () => null);

    final reportIdTemp = '${workItem.id}${RDatabaseBoxName.nameTemp}';

    //ListFormReport reportInWorkItem;
    if (workItem != null) {
      workItem.workProgress = ReportWorkStatusType.doing;
      workItem.workProgressName = 'Đang thực hiện';
      workItem.isAllowToCreateReport = false;
    }

    //fill người thực hiện
    final tester = formTemplate.fieldsModel
        .firstWhereOrNull(
            (element) => element.fieldType == FieldType.taps)
        ?.fieldModels?.last?.fieldModels?.firstWhereOrNull((element2) => element2.isFieldTester() == true);

    if(tester != null) {
      final options = workItem?.userImps?.map((e) => StringOptionModel(e.name, e.id))?.toList();
      final additionData = AdditionalData(options: options);
      tester.additionalData = additionData;
      tester.value = additionData?.options?.first?.value;
    } else {
      tester.value = null;
      tester.additionalData = null;
    }

    final reportModelResponse = ReportModelResponse(
        reportId: reportIdTemp,
        status: ReportStatusType.Implementing,
        scheduleId: workModel.id,
        reportModel: formTemplate);
    await saveReportFormDetail(reportModelResponse);

    //edit work item
    await clearWorks();
    await saveWorks(listWork);

    //add item to list report
    final workMergeModel = WorkMergeModel(
        id: workItem.id,
        formReportId: reportIdTemp,
        location: workItem.location,
        isAllowEditing: true,
        equipmentName: workItem.equipmentName,
        equipmentTypeName: workItem.equipmentTypeName,
        unitRequest: workItem.unitRequest,
        isSync: false,
        userImp: workModel.userImps,
        createdDate: DateTime.now().toStringFormat(RAppStrings.utcFormatNotZ, isUtc: true),
        workType: workItem.workType);

    final listMergeReport = await getMergeReportsOffline();
    listMergeReport.insert(0, workMergeModel);

    await clearMergeReports();
    await saveMergeReports(listMergeReport);
    await saveReportLocation(workModel.id);
    statusCode = 200;
    message = 'Tạo biên bản offline thành công';

    return ServerResponse<String>(
        message: message, statusCode: statusCode, data: reportIdTemp);
  }

  Future updateReportFormOffline(String reportId, FieldModel fieldModel, String workId) async {
    await saveReportLocation(workId);
    final reports = await getMergeReportsOffline();

    final currentReport = reports
        .firstWhere((element) => element.formReportId == reportId, orElse: () => null);

    if (currentReport != null) {
      currentReport?.isSync = false;
      await clearMergeReports();
      await saveMergeReports(reports);
    }

    final formReportDetail = await getReportFormDetail(reportId);
    //refer
    formReportDetail.reportModel.fieldsModel.firstWhere(
        (element) => element.fieldType == FieldType.taps,
        orElse: () => null).fieldModels = fieldModel.fieldModels;
    formReportDetail.isSync = false;
    await saveReportFormDetail(formReportDetail);
  }

  /// Danh sách trung tâm
  Future saveCenterReport(List<DepartmentModel> listDepartment) async {
    final prefs = Hive.box(RDatabaseBoxName.centerListReport);
    final data = jsonEncode(listDepartment.map((e) => e.toJson()).toList());
    await prefs.put(keyCenterListReport, data);
  }

  Future<List<DepartmentModel>> getDepartmentOffline() async {
    final prefs = Hive.box(RDatabaseBoxName.centerListReport);
    final jsonString = prefs.get(keyCenterListReport);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final department = JSON(json)
        .listObject
        .map((e) => DepartmentModel.fromJson(JSON(e)))
        .toList();
    return department;
  }

  /// Danh sách tổ đội
  Future saveTeamsReport(List<TeamsModel> listTeams) async {
    final prefs = Hive.box(RDatabaseBoxName.listTeamsReport);
    final data = jsonEncode(listTeams.map((e) => e.toJson()).toList());
    await prefs.put(keyTeamListReport, data);
  }

  Future<List<TeamsModel>> getTeamsOffline() async {
    final prefs = Hive.box(RDatabaseBoxName.listTeamsReport);
    final jsonString = prefs.get(keyTeamListReport);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final teams =
        JSON(json).listObject.map((e) => TeamsModel.fromJson(JSON(e))).toList();
    return teams;
  }

  /// danh sách người thực hiện
  Future savePerformers(List<UserModel> listUsers) async {
    final prefs = Hive.box(RDatabaseBoxName.listUserReport);
    final data = jsonEncode(listUsers.map((e) => e.toJson()).toList());
    await prefs.put(keyUserListReport, data);
  }

  Future<List<UserModel>> getPerformerOffline() async {
    final prefs = Hive.box(RDatabaseBoxName.listUserReport);
    final jsonString = prefs.get(keyUserListReport);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final users =
        JSON(json).listObject.map((e) => UserModel.fromJson(JSON(e))).toList();
    return users;
  }

  /// danh sách đia điểm
  Future saveLocationReport(List<UserModel> listLocation) async {
    final prefs = Hive.box(RDatabaseBoxName.listLocationReport);
    final data = jsonEncode(listLocation.map((e) => e.toJson()).toList());
    await prefs.put(keyLocationReport, data);
  }

  Future<List<UserModel>> getLocationReportOffline() async {
    final prefs = Hive.box(RDatabaseBoxName.listLocationReport);
    final jsonString = prefs.get(keyLocationReport);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final locations =
        JSON(json).listObject.map((e) => UserModel.fromJson(JSON(e))).toList();
    return locations;
  }
  /// danh sách lịch sử phê duyệt
  Future saveHistoryApprove(
      List<ApprovalHistoryModel> listHistory) async {
    final prefs = Hive.box(RDatabaseBoxName.listHistoryApprove);
    final oldHistory = await getHistoryApproveOffline();
    final history = <ApprovalHistoryModel>[...?oldHistory, ...?listHistory];
    final data = jsonEncode(history.map((e) => e.toJson()).toList());
    await prefs.put(keyListHistoryApprove, data);
  }

  Future<List<ApprovalHistoryModel>> getHistoryApproveOffline(
      {String workId}) async {
    final prefs = Hive.box(RDatabaseBoxName.listHistoryApprove);
    final jsonString = prefs.get(keyListHistoryApprove);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final histories = JSON(json)?.listObject
        ?.map((e) => ApprovalHistoryModel.fromJson(JSON(e)))
        ?.toList() ?? [];
    if (workId != null) {
      return histories.where((element) => element.workId == workId).toList();
    }
    return histories;
  }
  /// danh sách đơn vị công việc
  Future saveUnitWork(List<UnitReport> listUnit) async {
    final prefs = Hive.box(RDatabaseBoxName.listUnitWork);
    final data = jsonEncode(listUnit.map((e) => e.toJson()).toList());
    await prefs.put(keyListUnitWork, data);
  }

  Future<List<UnitReport>> getUnitWorkOffline() async {
    final prefs = Hive.box(RDatabaseBoxName.listUnitWork);
    final jsonString = prefs.get(keyListUnitWork);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final listUnit =
        JSON(json).listObject.map((e) => UnitReport.fromJson(JSON(e))).toList();
    return listUnit;
  }

  /// danh sách dropw biên bản bổ không theo kế hoạch
  Future saveUnscheduledReportOffline(
      UnscheduledReport unscheduledReport) async {
    final prefs = Hive.box(RDatabaseBoxName.listUnscheduledReport);
    final data = jsonEncode(unscheduledReport.toJson());
    await prefs.put(keyListUnscheduledReport, data);
  }

  Future<UnscheduledReport> getUnscheduledReportOffline() async {
    final prefs = Hive.box(RDatabaseBoxName.listUnscheduledReport);
    final jsonString = prefs.get(keyListUnscheduledReport);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final unscheduledReport = UnscheduledReport.fromJson(JSON(json));
    return unscheduledReport;
  }

  Future<ServerResponse> createUnscheduledReportOffline(
      {String workType,
      String unitId,
      String createdDate,
      String content,
      String userId,
      String username,
      String teamId,
      List<Forms> forms,
      String teamName,
      String equipmentTypeId,
      String equipmentDetailId,
      String equipmentDetailName,
      String departmentId,
      String location,
      String reportNumber,
      String reportTypeName,
      String department,
      String formId}) async {
    var statusCode = 1;
    var message = '';
    String reportIdTemp;
    if (forms.isEmpty) {
      statusCode = 400;
      message = 'Không tìm thấy form biên bản';
      return ServerResponse<String>(message: message, statusCode: statusCode);
    } else {
      // if (workType ==  WorkType.accreditationExperiment.toString()) {
      //   final formExperiment = forms.where((element) => element.type == WorkType.experiment);
      //   final formAccreditation = forms.where((element) => element.type == WorkType.accreditation);
      //   if(formExperiment.isNotEmpty && formAccreditation.isNotEmpty){
      //     final listFormReportTemplate = await getListFormTemplateOffline();
      //     // get form template one
      //     final formTemplateOne = await getFormTemplate(forms.first.id);
      //
      //     if(formTemplateOne == null) {
      //       statusCode = 400;
      //       message = 'Không tìm thấy form biên bản';
      //       return ServerResponse<String>(message: message, statusCode: statusCode);
      //     }
      //     formTemplateOne.name = listFormReportTemplate
      //         .firstWhere((element) => element.id == forms.first.id,orElse: () => null)
      //         .name;
      //
      //     // get form template two
      //     final formTemplateSecond = await getFormTemplate(forms.last.id);
      //
      //     if(formTemplateSecond == null) {
      //       statusCode = 400;
      //       message = 'Không tìm thấy form biên bản';
      //       return ServerResponse<String>(message: message, statusCode: statusCode);
      //     }
      //     formTemplateSecond.name = listFormReportTemplate
      //         .firstWhere((element) => element.id == forms.last.id,orElse: () => null)
      //         .name;
      //
      //
      //     final options = [StringOptionModel(username, userId)];
      //     final additionData = AdditionalData(options: options);
      //     final testerOne = formTemplateOne.fieldsModel
      //         .firstWhereOrNull(
      //             (element) => element.fieldType == FieldType.taps)
      //         ?.fieldModels?.last?.fieldModels?.firstWhereOrNull((element2) => element2.isFieldTester() == true);
      //
      //     if(testerOne != null) {
      //       testerOne.additionalData = additionData;
      //       testerOne.value = additionData.options.first.value;
      //     } else {
      //       testerOne.additionalData = null;
      //     }
      //
      //     final testerSecond = formTemplateSecond.fieldsModel
      //         .firstWhereOrNull(
      //             (element) => element.fieldType == FieldType.taps)
      //         ?.fieldModels?.last?.fieldModels?.firstWhereOrNull((element2) => element2.isFieldTester() == true);
      //
      //     if(testerSecond != null) {
      //       testerSecond.additionalData = additionData;
      //       testerSecond.value = additionData.options.first.value;
      //     } else {
      //       testerSecond.additionalData = null;
      //     }
      //
      //     final reportIdTempFirst =
      //         '${DateTime.now().millisecondsSinceEpoch.toString()}${forms.first.id}${RDatabaseBoxName.nameTemp}';
      //     final reportModelResponseFirst = ReportModelResponse(
      //         reportId: reportIdTempFirst,
      //         status: ReportStatusType.Implementing,
      //         reportModel: formTemplateOne,);
      //
      //     await saveReportFormDetail(reportModelResponseFirst);
      //     final listReportModelFirst = ListReportModel(
      //         id: reportIdTempFirst,
      //         reportType: forms.first.type,
      //         content: content,
      //         createdByName: username,
      //         team: teamName,
      //         teamId: teamId,
      //         equipmentTypeId: equipmentTypeId,
      //         workingStatusName: 'Chưa gửi phê duyệt',
      //         workingStatus: ReportStatusType.Implementing,
      //         workId: null,
      //         equipmentDetailId: equipmentDetailId,
      //         createdDate: createdDate,
      //         location: location,
      //         unitId: unitId,
      //         userImp: username,
      //         userImpId: userId,
      //         reportNumber: reportNumber,
      //         equipmentDetail: equipmentDetailName,
      //         createdBy: username,
      //         departmentId: departmentId,
      //         reportTypeName: forms.first.type == WorkType.experiment
      //             ? RAppStrings.experiment
      //             : RAppStrings.accreditation,
      //         department: department);
      //
      //     final reportIdTempSecond = '${DateTime.now().millisecondsSinceEpoch.toString()}${forms.last.id}${RDatabaseBoxName.nameTemp}';
      //     final reportModelResponseSecond= ReportModelResponse(
      //         reportId: reportIdTempSecond,
      //         status: ReportStatusType.Implementing,
      //         reportModel: formTemplateSecond,);
      //     await saveReportFormDetail(reportModelResponseSecond);
      //     final listReportModelSecond = ListReportModel(
      //         id: reportIdTempSecond,
      //         reportType: forms.last.type,
      //         content: content,
      //         createdByName: username,
      //         team: teamName,
      //         teamId: teamId,
      //         equipmentTypeId: equipmentTypeId,
      //         workingStatusName: 'Chưa gửi phê duyệt',
      //         workingStatus: ReportStatusType.Implementing,
      //         workId: null,
      //         equipmentDetailId: equipmentDetailId,
      //         createdDate: createdDate,
      //         location: location,
      //         unitId: unitId,
      //         userImpId: userId,
      //         userImp: username,
      //         reportNumber: reportNumber,
      //         equipmentDetail: equipmentDetailName,
      //         createdBy: username,
      //         departmentId: departmentId,
      //         reportTypeName: forms.last.type == WorkType.experiment
      //             ? RAppStrings.experiment
      //             : RAppStrings.accreditation,
      //         department: department);
      //
      //     // create form report
      //     final listReport = await getReportsOffline();
      //     listReport.insert(0, listReportModelFirst);
      //     listReport.insert(1, listReportModelSecond);
      //     await clearReports();
      //     await saveReports(listReport);
      //     // await saveReportLocation(reportIdTempFirst);
      //     // await saveReportLocation(reportIdTempSecond);
      //     statusCode = 200;
      //     message = 'Tạo biên bản offline thành công';
      //   } else {
      //     statusCode = 400;
      //     message = 'Không tìm thấy form biên bản';
      //   }
      // }else{

       final form = forms?.where((element) => element.type.toString() == workType)?.toList()?.firstWhere((element) => !element.name.contains('.pdf'));
       if (form == null) {
         statusCode = 400;
         message = 'Không tìm thấy form biên bản';
       } else {
         final listFormReportTemplate = await getListFormTemplateOffline();
         final formTemplate = await getFormTemplate(form.id);
         if(formTemplate == null) {
           statusCode = 400;
           message = 'Không tìm thấy form biên bản';
           return ServerResponse<String>(message: message, statusCode: statusCode,data: null);
         }
         formTemplate.name = listFormReportTemplate
             .firstWhere((element) => element.id == form.id,orElse: () => null)
             .name;
         final options = [StringOptionModel(username, userId)];
         final additionData = AdditionalData(options: options);
          final tester = formTemplate.fieldsModel
              .firstWhereOrNull(
                  (element) => element.fieldType == FieldType.taps)
              ?.fieldModels?.last?.fieldModels?.firstWhereOrNull((element2) => element2.isFieldTester() == true);
          if(tester != null) {
           tester.additionalData = additionData;
           tester.value = additionData.options.first.value;
         } else {
           tester.additionalData = null;
         }

         reportIdTemp = '${DateTime.now().millisecondsSinceEpoch.toString()}${form.id}${RDatabaseBoxName.nameTemp}';
         final reportModelResponse = ReportModelResponse(
             reportId: reportIdTemp,
             status: ReportStatusType.Implementing,
             reportModel: formTemplate,
             isSync: false);
         await saveReportFormDetail(reportModelResponse);
         final listReportModel = ListReportModel(
             id: reportIdTemp,
             reportType: workType.toIntOrNull(),
             content: content,
             createdByName: username,
             team: teamName,
             teamId: teamId,
             equipmentTypeId: equipmentTypeId,
             workingStatusName: 'Chưa gửi phê duyệt',
             workingStatus: ReportStatusType.Implementing,
             workId: null,
             equipmentDetailId: equipmentDetailId,
             createdDate: createdDate,
             location: location,
             unitId: unitId,
             userImp: username,
             userImpId: userId,
             reportNumber: reportNumber,
             equipmentDetail: equipmentDetailName,
             createdBy: username,
             departmentId: departmentId,
             reportTypeName: reportTypeName,
             department: department);
         final listReport = await getReportsOffline();
         listReport.insert(0, listReportModel);
         await clearReports();
         await saveReports(listReport);
         //await saveReportLocation(reportIdTemp);
         statusCode = 200;
         message = 'Tạo biên bản offline thành công';
       }
  //   }
    }

    return ServerResponse<String>(message: message, statusCode: statusCode,data: reportIdTemp);
  }

  Future saveStamps(List<StampModel> list) async {
    if (list == null) return;
    final prefs = Hive.box(RDatabaseBoxName.listStamps);
    final data = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.put(RDatabaseBoxName.listStamps, data);
  }

  Future<List<StampModel>> getStamps() async {
    final prefs = Hive.box(RDatabaseBoxName.listStamps);
    final jsonString = prefs.get(RDatabaseBoxName.listStamps);
    if (jsonString == null) {
      return List.empty();
    }
    final json = jsonDecode(jsonString);
    final list =
        JSON(json)?.listObject?.map((e) => StampModel.fromJson(JSON(e)))?.toList() ?? List.empty();
    return list;
  }

  Future<String> isDuplicateStamp(String stamp, String formReportId) async {
    final stamps = await getStamps();
    final stampsInput = stamp?.split(', ')?.toList() ?? [];
    for(stamp in stampsInput) {
      final stampExist = stamps?.firstWhere((element) => element?.stampCode == stamp, orElse: () => null);
      if(stampExist != null && formReportId != stampExist.formReportId){
        return 'Số tem kiểm định $stamp bị trùng với biên bản số ${stampExist.formReportCode ?? ''}' ;
      }
    }

    return null;
  }

  Future saveReportLocation(String workId) async {
    if(workId == null) return;
    final location = await ReportLocationUtils.getCurrentPositionForSave();
    if (location == null) return;
    final prefs = Hive.box(RDatabaseBoxName.rLocation);
    final locationOffline = LocationOffline(
        workId: workId,
        lat: location.latitude.toString(),
        long: location.longitude.toString());
    final data = jsonEncode(locationOffline.toJson());
    await prefs.put(keyRLocation + locationOffline.workId, data);
  }

  Future<LocationOffline> getReportLocation(String reportOfflineId) async {
    final prefs = Hive.box(RDatabaseBoxName.rLocation);
    final jsonString = prefs.get(keyRLocation + reportOfflineId);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final locationOffline = LocationOffline.fromJson(JSON(json));
    return locationOffline;
  }

  Future clearLocationOffline(LocationOffline locationOffline) async {
    final prefs = Hive.box(RDatabaseBoxName.rLocation);
    await prefs.put(keyRLocation + locationOffline.workId, null);
  }
}

