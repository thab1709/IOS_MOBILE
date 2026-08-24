// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/utils/constance.dart';
import 'package:evnmobile/src/qltnkd/common/utils/report_location_utils.dart';
import 'package:evnmobile/src/qltnkd/map/model/a.dart';
import 'package:evnmobile/src/qltnkd/models/create_report_not_plan_model.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/models/additional_model.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/qltnkd/models/department_model.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/models/pdf_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_merge_model.dart';
import 'package:evnmobile/src/qltnkd/models/teams_model.dart';
import 'package:evnmobile/src/qltnkd/models/unit.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/approval_history_response.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/list_report_director_company_response.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/list_report_response.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/report_work_response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../responseModel/form_report_copy_response_model.dart';
import '../server_response.dart';

class ReportRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<String>> getReportIdByCode(String code) async {
    try {
      final data = await _provider.get(
        '/formreport/by-code',
        params: <String, dynamic>{'code': code},
        isRequireAuth: true,
        backgroundMode: true,
      );
      final response = ServerResponse<String>.fromJson(data);
      if (response.isLoadSuccess) {
        response.setData(data['data']['id'].stringValue);
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse<String>(
        message: 'Không thể tải biên bản. Vui lòng thử lại.',
      );
    }
  }

  Future<ServerResponse<ReportModelResponse>> getReportFormDetail(String id,
      {bool isNotShowLoading = false}) async {
    try {
      final data = await _provider.get('/formreport/$id',
          isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<ReportModelResponse>.fromJson(data);
      response.setData(ReportModelResponse.fromJson(data['data']));
      return response;
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ReportModel>> updateReport(String id, FieldModel fieldModel,
      {bool isBackgroundMode = false, List<File> files}) async {
    try {
      final params = <String, dynamic>{};

      await fieldModel.getValues(params);

      final map = <String, String>{
        'formReportId': id,
        'fieldValues': jsonEncode(params),
      };

      final data = await _provider.putMultipart('/formreport', map,
          isRequireAuth: true, backgroundMode: isBackgroundMode, files: files);
      final response = ServerResponse<ReportModel>.fromJson(data);
      if (data['data'] != null) {
        response.setData(ReportModel.fromJson(JSON(data['data'])));
      }
      return response;
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> syncPmisCbm(String formReportId, {bool isBackgroundMode = true}) async {
    try {
      final map = <String, String>{
        'formReportId': formReportId,
      };
      final data = await _provider.post('/formreport/sync-pmis-cbm', map,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<String>.fromJson(data);
      if (data['data'] != null) {
        response.setData(data['data'].toString());
      }
      return response;
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse<String>(message: 'Lỗi đồng bộ PMIS');
    }
  }

  Future<ServerResponse<String>> evaluateThreshold(
      Map<String, dynamic> payload,
      {bool isBackgroundMode = true}) async {
    try {
      final token = AppShared.instance.getUserToken();
      final headers = <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
      
      final baseUrl = AppEnv.getServerUrl();
      final url = Uri.parse('$baseUrl/thresholdcategory/evaluate');
      
      debugPrint('API request: $url');
      debugPrint('API log query: ${jsonEncode(payload)}');

      // Thường các API có action định dạng động từ (evaluate) sẽ dùng POST
      final res = await http.post(url, headers: headers, body: jsonEncode(payload));
      
      debugPrint('API log code: ${res.statusCode}');
      debugPrint('API log Response: ${res.body}');

      final data = jsonDecode(res.body);
      final response = ServerResponse<String>.fromJson(JSON(data));
      if (data['data'] != null) {
        response.setData(data['data'].toString());
      }
      return response;
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse();
    }
  }

  Future<JSON> importExcelData(File file, String formId) async {
    final token = AppShared.instance.getUserToken();
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    try {
      ProgressHUD.show();
      final baseUrl = AppEnv.getServerUrl();
      debugPrint('API import-excel request: $baseUrl/formreport/import-excel-data');
      final request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/formreport/import-excel-data'));
      request.headers.addAll(headers);
      final fileData = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(fileData);
      if (formId != null && formId.isNotEmpty) {
        request.fields['formId'] = formId;
      }
      
      final requestResponse = await request.send();
      final responseString = await requestResponse.stream.bytesToString();
      debugPrint('API import-excel code: ${requestResponse.statusCode}');
      debugPrint('API import-excel response: $responseString');
      final jsonResponse = JSON.parse(responseString);
      ProgressHUD.dismiss();
      return jsonResponse;
    } catch (e) {
      ProgressHUD.dismiss();
      debugPrint(e.toString());
      return JSON({'statusCode': 500, 'message': 'Lỗi kết nối'});
    }
  }

  Future<ServerResponse<ReportWorkResponse>> getListWork({
    String unitId,
    String equipmentName,
    String equipmentType,
    String detailEquipmentType,
    String workProgress,
    String reportNumber,
    String stampNumber,
    String workType,
    String searchTerm,
    num pageIndex = 1,
    String orderBy = 'ASC',
    String orderByDesc,
    String fromDate,
    String toDate,
    num pageOffset,
    bool isNotShowLoading = false,
    bool isPaperFormReport,
    int groupType = 0,
  }) async {
    final param = {
      'UnitId': unitId == '0' ? null : unitId,
      'EquipmentName': equipmentName,
      'SearchTerm': searchTerm,
      'EquipmentTypeId': equipmentType == '0' ? null : equipmentType,
      'EquipmentDetailId': detailEquipmentType == '0' ? null : detailEquipmentType,
      'WorkProgress': workProgress == '0' ? null : workProgress,
      'ReportNumber': reportNumber,
      'StampNumber': stampNumber,
      'WorkType': workType == '0' ? null : workType,
      'FromDate': fromDate?.isEmpty == true ? null : fromDate,
      'ToDate': toDate?.isEmpty == true ? null : toDate,
      'orderBy': orderBy,
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'pageSize': rAppPageSize.toString(),
      'pageOffset': pageOffset?.toString(),
    };
    if (isPaperFormReport != null) {
      param['IsPaperFormReport'] = isPaperFormReport.toString();
    }
    String endpoint = '/individualjob';
    if (groupType == 1) {
      endpoint = '/constructionschedule/individual-job';
    }
    try {
      final data = await _provider.get(endpoint,
          params: param, isRequireAuth: true, backgroundMode: isNotShowLoading);
      
      final str = data.toString();
      for (var i = 0; i < str.length; i += 800) {
        debugPrint(str.substring(i, i + 800 > str.length ? str.length : i + 800));
      }

      if (groupType == 1) {
        debugPrint('==== CHO CAC X API RESPONSE ====');
      }
      final response = ServerResponse<ReportWorkResponse>.fromJson(data);
      final works = ReportWorkResponse.fromJson(data);
      if (groupType == 1 && fromDate?.isNotEmpty == true && toDate?.isNotEmpty == true) {
        try {
          DateTime qStart = DateTime.parse(fromDate).toLocal();
          DateTime qEnd = DateTime.parse(toDate).toLocal();
          qStart = DateTime(qStart.year, qStart.month, qStart.day);
          qEnd = DateTime(qEnd.year, qEnd.month, qEnd.day, 23, 59, 59);

          works.list.retainWhere((item) {
            if (item.clonedDate != null) {
              return item.clonedDate.compareTo(qStart) >= 0 && item.clonedDate.compareTo(qEnd) <= 0;
            }
            return true; // Keep original items if they don't have a clonedDate
          });
        } catch (e) {
          debugPrint('Error filtering cloned jobs: $e');
        }
      }
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<FormReportCopyResponseModel>> getFormReportCopy({
    String scheduleId,
    String equipmentDetailId,
    String equipmentTypeId,
    String searchTerm,
    num pageIndex = 1,
    String orderBy = 'ASC',
    String orderByDesc,
    num pageOffset,
    bool isNotShowLoading = false,
    int groupType = 0,
  }) async {
    final param = {
      'ScheduleId': scheduleId,
      'EquipmentDetailId': equipmentDetailId,
      if (equipmentTypeId != null) 'EquipmentTypeId': equipmentTypeId,
      'SearchTerm': searchTerm,
      'orderBy': orderBy,
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'pageSize': rAppPageSize.toString(),
      'pageOffset': pageOffset?.toString(),
    };
    
    String endpoint = '/formreport/formreport-copy-paging';
    if (groupType == 1) {
      endpoint = '/constructionformreport/formreport-copy-paging';
    }

    try {
      final data = await _provider.get(endpoint,
          params: param, isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<FormReportCopyResponseModel>.fromJson(data);
      final works = FormReportCopyResponseModel.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }


  Future<ServerResponse<String>> createFromReport(
    ReportWorkItem workItem, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'formId': workItem.formId ?? '',
        'scheduleId': workItem.id,
      };

      final data = await _provider.post('/formreport', map,
          isRequireAuth: requireAuth, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> addGeneralData(
    String name,
    String type,
    String formId, {
    bool requireAuth = true,
  }) async {
    try {
      final map = {
        'name': name,
        'type': type,
        'formId': formId,
      };

      final data =
          await _provider.post('/formreport/general-data', map, isRequireAuth: requireAuth);
      final response = ServerResponse<String>.fromJson(data);
      response.setData(data['data']['id'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UnitReport>>> getUnits() async {
    final param = {'pageSize': '99'};
    try {
      final data = await _provider.get('/unit',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UnitReport>>.fromJson(data);
      final responseWorks = <UnitReport>[];
      responseWorks.add(UnitReport(id: '0', name: RAppStrings.all));
      final works = data['data']?.value != null ? data['data']?.list?.map((e) => UnitReport.fromJson(JSON(e)))?.toList() : <UnitReport>[];
      responseWorks.addAll(works);
      response.setData(responseWorks);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<ReportType>>> getScheduleType() async {
    final param = {'pageSize': '99'};
    try {
      final data = await _provider.get('/productionplan/schedule-type',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<ReportType>>.fromJson(data);
      final reportTypes = <ReportType>[];
      reportTypes.add(ReportType(id: 0, name: RAppStrings.all));
      final listData = data['data']?.value != null ? data['data']?.list?.map((e) => ReportType.fromJson(JSON(e)))?.toList() : <ReportType>[];
      reportTypes.addAll(listData);
      response.setData(reportTypes);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ReportWorkItem>> getWorkDetail(String workId) async {
    try {
      final data =
          await _provider.get('/individualjob/$workId', isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse<ReportWorkItem>.fromJson(data);
      final reportWork = ReportWorkItem.fromJson(JSON(data['data']));
      response.setData(reportWork);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ListReportModel>> getReportInfoDetail(String reportId) async {
    try {
      final data = await _provider.get('/formreport/info/$reportId',
          isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse<ListReportModel>.fromJson(data);
      final reportWork = ListReportModel.fromJson(JSON(data['data']));
      response.setData(reportWork);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ListReportResponse>> getFormReport(
      {String searchTerm,
      String locationReport,
      String statusReport,
      String userId,
      String teamId,
      String fromDate,
      String toDate,
      String departmentId,
      String contentReport,
      String orderBy = 'descend',
      String scheduleType,
      num pageIndex = 1,
      bool isNotShowLoading = false,
      String orderByDesc,
      num pageOffset}) async {
    final param = <String, dynamic>{
      'searchTerm': searchTerm,
      'fromDate': fromDate,
      'toDate': toDate,
      'location': locationReport == '0' ? '' : locationReport,
      'content': contentReport,
      'teamId': teamId == '0' ? '' : teamId,
      //'ReportType': reportType == '0' ? '' : reportType,
      'userId': userId == '0' ? '' : userId,
      'departmentId': departmentId == '0' ? '' : departmentId,
      'status': statusReport == '0' ? '' : statusReport,
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'orderBy': orderBy,
      'ScheduleType': scheduleType == '0' ? '' : scheduleType,
      'pageSize': rAppPageSize.toString(),
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/formreport',
          params: param, isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<ListReportResponse>.fromJson(data);
      final report = ListReportResponse.fromJson(data);
      response.setData(report);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<DepartmentModel>>> getDepartment() async {
    final param = {'pageSize': '99'};
    try {
      final data = await _provider.get('/department',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<DepartmentModel>>.fromJson(data);
      final department = <DepartmentModel>[];
      final listData = data['data']?.value != null ? data['data']?.list?.map((e) => DepartmentModel.fromJson(JSON(e)))?.toList() : <DepartmentModel>[];
      department.addAll(listData);
      response.setData(department);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<TeamsModel>>> getTeams({String departmentId}) async {
    final param = {'DepartmentId': departmentId};
    try {
      final data = await _provider.get('/team/teams',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<TeamsModel>>.fromJson(data);
      final teamList = <TeamsModel>[];
      final listData = data['data']?.value != null ? data['data']?.list?.map((e) => TeamsModel.fromJson(JSON(e)))?.toList() : <TeamsModel>[];
      teamList.addAll(listData);
      response.setData(teamList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UserModel>>> getListUser({String teamId}) async {
    final param = {'teamId': teamId};
    try {
      final data = await _provider.get('/team/list-user',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UserModel>>.fromJson(data);
      final listUser = <UserModel>[];
      final listData = data['data']?.value != null ? data['data']?.list?.map((e) => UserModel.fromJson(JSON(e)))?.toList() : <UserModel>[];
      listUser.addAll(listData);
      response.setData(listUser);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UserModel>>> getListPersidentCenter() async {
    try {
      final data = await _provider.get('/mergeformreport/president-center',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UserModel>>.fromJson(data);
      final listUser = <UserModel>[];
      final listData = data['data']?.value != null ? data['data']?.list?.map((e) => UserModel.fromJson(JSON(e)))?.toList() : <UserModel>[];
      listUser.addAll(listData);
      response.setData(listUser);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UserModel>>> getListPresidentCompany(
      {@required String userPosition}) async {
    try {
      final param = {'UserPosition': userPosition, 'pageSize': '99'};
      final data =
          await _provider.get('/user', isRequireAuth: true, params: param, backgroundMode: true);
      final response = ServerResponse<List<UserModel>>.fromJson(data);
      final listUser = <UserModel>[];
      final listData = data['data']?.value != null ? data['data']?.list?.map((e) => UserModel.fromJson(JSON(e)))?.toList() : <UserModel>[];
      listUser.addAll(listData);
      response.setData(listUser);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UserModel>>> getSubstation({String userId}) async {
    final param = <String, dynamic>{'userId': userId};
    try {
      final data = await _provider.get('/formreport/substations',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UserModel>>.fromJson(data);
      final listSubstation = <UserModel>[];
      final listData = data['data']?.value != null ? data['data']?.list?.map((e) => UserModel.fromJson(JSON(e)))?.toList() : <UserModel>[];
      listSubstation.addAll(listData);
      response.setData(listSubstation);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ApprovalHistoryResponse>> getApprovalHistory(
      {String formReportId,
      String orderByDesc,
      String pageOffset,
      bool backgroundMode = true}) async {
    final param = <String, dynamic>{
      'formReportId': formReportId,
      'pageIndex': '1',
      'pageSize': '99',
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/formreport/approvalhistory',
          params: param, isRequireAuth: true, backgroundMode: backgroundMode);
      final response = ServerResponse<ApprovalHistoryResponse>.fromJson(data);
      final approvalHistory = ApprovalHistoryResponse.fromJson(data);
      response.setData(approvalHistory);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> signatureReport({String formReportId}) async {
    final param = <String, dynamic>{
      'formReportId': formReportId,
    };
    try {
      final data = await _provider.get('/formreport/digitalsign',
          params: param, isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<PDFModel>>> sendApproval({
    List<String> formReportId,
    String content,
    String status,
    bool isApproval,
    bool isBackgroundMode = false,
  }) async {
    final params = {'note': content ?? '', 'ids': formReportId};
    String endpoint;
    if (isApproval) {
      switch (int.parse(status)) {
        case ReportStatusType.Implementing:
          endpoint = 'send';
          break;

        case ReportStatusType.Rejected:
          endpoint = 'send';
          break;
        default:
          endpoint = 'accept';
      }
    } else {
      endpoint = 'reject';
    }

    final data = await _provider.post('/formreport/$endpoint', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<List<PDFModel>>.fromJson(data);
    final result = data['data'].listObject?.map((e) => PDFModel.fromJson(JSON(e)))?.toList() ?? [];
    response.data = result;
    return response;
  }

  Future<ServerResponse<String>> sendOperation({
    String formReportId,
    String content,
    String approveId,
  }) async {
    final params = {'formReportId': formReportId, 'note': content ?? '', 'approveId': approveId};
    final data = await _provider.post('/formreport/operation-send', params, isRequireAuth: true);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<List<TeamsModel>>> getRoleOperationApprove() async {
    final data = await _provider.get('/user/role-operation-approve',
        isRequireAuth: true, backgroundMode: true);
    final response = ServerResponse<List<TeamsModel>>.fromJson(data);
    response.data = data['data']?.value != null ? data['data']?.listObject?.map((e) => TeamsModel.fromJson(JSON(e)))?.toList() ?? [] : [];
        List.empty();
    return response;
  }

  Future<ServerResponse<String>> approvalOperationTeam({
    String formReportId,
    bool isApproval,
    String content,
  }) async {
    final params = {'id': formReportId, 'note': content ?? ''};
    String endpoint;
    if (isApproval) {
      endpoint = 'operation-accept';
    } else {
      endpoint = 'operation-reject';
    }
    final data = await _provider.post('/formreport/$endpoint', params, isRequireAuth: true);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> approvalLeader({
    List<String> formReportIds,
    String content,
    bool isApproval,
    bool isBackgroundMode = false,
  }) async {
    final params = {'note': content ?? '', 'ids': formReportIds};
    String endpoint;
    if (isApproval) {
      endpoint = 'leader-accept';
    } else {
      endpoint = 'leader-reject';
    }

    final data = await _provider.post('/formreport/$endpoint', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> getPdf({String formReportId, bool isGroup, bool isViewPDFUnscheduled, bool isCbm = false}) async {
    final param = <String, dynamic>{'FormReportId': formReportId, 'isGroup': isViewPDFUnscheduled ? null : isGroup, 'IsCbm': isCbm};
    try {
      final data = await _provider.post('/common/get-pdf', param, isRequireAuth: true);
      return ServerResponse<String>.fromJson(data)..setData(data['data'].string);
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<ServerResponse<String>> createReportNotPlan(
      {String workType,
      String unitId,
      String equipmentTypeId,
      String equipmentDetailId,
      String userId,
      String teamId,
      String departmentId,
      String createdDate,
      String location,
      String content,
      bool backgroundMode = false,
      }) async {
    final params = {
      'workType': workType == '0' ? '' : workType,
      'unitId': unitId == '0' ? '' : unitId,
      'equipmentTypeId': equipmentTypeId,
      'equipmentDetailId': equipmentDetailId,
      'userId': userId,
      'teamId': teamId,
      'departmentId': departmentId,
      'createdDate': createdDate,
      'location': location,
      'note': content
    };
    final data = await _provider.post('/formreport/unscheduled-report', params,
        isRequireAuth: true, backgroundMode: backgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    response.setData(data['data']?.value != null ? data['data']?.listObject?.map((e) => JSON(e)?.string)?.first : null);
    return response;
  }

  Future<ServerResponse<UnscheduledReport>> getDataUnscheduled() async {
    try {
      final data = await _provider.get('/formreport/unscheduled-report/data',
          isRequireAuth: true, backgroundMode: true);
      
      final str = data.toString();
      for (var i = 0; i < str.length; i += 800) {
        debugPrint(str.substring(i, i + 800 > str.length ? str.length : i + 800));
      }

      final response = ServerResponse<UnscheduledReport>.fromJson(data);
      final report = UnscheduledReport.fromJson(data['data']);
      response.setData(report);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<void> sendLocation(
    String reportId, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
    Position position,
    int type = 1,
  }) async {
    try {
      if (reportId == null) return;
      final location = position ??
          await ReportLocationUtils.getCurrentPositionForSave();
      if (location == null) {
        if (type == 3) {
          SnackBarHUD.show('Không thể lấy toạ độ, vui lòng kiểm tra lại định vị');
        }
        return;
      }

      final map = {
        'id': reportId,
        'longitude': location.longitude.toString(),
        'latitude': location.latitude.toString(),
        'type': type,
      };

      final apiResponse = await _provider.post('/formreport/form-report-location', map,
          isRequireAuth: requireAuth, backgroundMode: true);
          
      if (type == 3 && apiResponse != null) {
        SnackBarHUD.show('Lấy toạ độ thành công (Kinh độ : ${location.longitude.toStringAsFixed(8)}, Vĩ độ : ${location.latitude.toStringAsFixed(8)})');
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future sendLocationOffline(
    String reportId,
    String lat,
    String long, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
    int type = 1,
  }) async {
    try {
      final map = {
        'id': reportId,
        'longitude': long,
        'latitude': lat,
        'type': type,
      };

      await _provider.post('/formreport/form-report-location', map,
          isRequireAuth: requireAuth, backgroundMode: true);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<ServerResponse<DataReportLocation>> getReportLocation(
    String reportId,
  ) async {
    try {
      final data = await _provider.get('/formreport/$reportId/location',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<DataReportLocation>.fromJson(data);
      response.setData(DataReportLocation.fromJson(JSON(data['data'])));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ReportModelResponse>> createCertificate(String id, int type,
      {bool isNotShowLoading = false}) async {
    try {
      final params = {
        'formReportId': id,
        'type': type.toString(),
      };
      final data = await _provider.post('/certificate', params,
          isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<ReportModelResponse>.fromJson(data);
      return response;
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<ReportMergeModel>>> getDetailMergeWork(String workId) async {
    try {
      final data = await _provider.get('/mergeformreport/$workId', isRequireAuth: true);
      final response = ServerResponse<List<ReportMergeModel>>.fromJson(data);
      final report = data['data']?.value != null ? data['data']?.list?.map((e) => ReportMergeModel.fromJson(JSON(e)))?.toList() : <ReportMergeModel>[];
      response.setData(report);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<MergeReportResponse>> getMergeWork({
    @required String endPoint,
    String unitId,
    String searchTerm,
    num pageIndex = 1,
    String orderBy = 'ASC',
    String orderByDesc,
    String fromDate,
    String toDate,
    num pageOffset,
    bool isNotShowLoading = false,
  }) async {
    final param = {
      'UnitId': unitId == '0' ? null : unitId,
      'SearchTerm': searchTerm,
      'FromDate': fromDate,
      'ToDate': toDate,
      'orderBy': orderBy,
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'pageSize': rAppPageSize.toString(),
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/mergeformreport/$endPoint',
          params: param, isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<MergeReportResponse>.fromJson(data);
      final report = MergeReportResponse.fromJson(data);
      response.setData(report);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

