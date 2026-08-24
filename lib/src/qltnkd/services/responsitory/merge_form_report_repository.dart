import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/qltnkd/common/utils/constance.dart';
import 'package:evnmobile/src/qltnkd/models/merge_report_pdf_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_merge_model.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/approval_history_response.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/list_report_director_company_response.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import '../server_response.dart';

class MergerFormReportRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<MergeReportResponse>> getReportForLeader({
    @required String endPoint,
    String id,
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
      'Id': id,
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

  Future<ServerResponse<List<ReportMergeModel>>> getDetailMergeWork(
      String workId,
      {bool isBackgroundMode = false}) async {
    try {
      final data = await _provider.get('/mergeformreport/$workId',
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<List<ReportMergeModel>>.fromJson(data);
      final report = data['data']
          ?.list
          ?.map((e) => ReportMergeModel.fromJson(JSON(e)))
          ?.toList();
      response.setData(report);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> recallReport(String workId,
      {bool isBackgroundMode = false}) async {
    try {
      final params = <String, dynamic>{'scheduleId': workId};
      final data = await _provider.post(
          '/mergeformreport/recall-formreport', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> cancelReport(String workId, String note,
      {bool isBackgroundMode = false}) async {
    try {
      final params = <String, dynamic>{'scheduleId': workId, 'note': note};
      final data = await _provider.post(
          '/mergeformreport/cancel-formreport', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<MergeReportResponse>> getReports({
    String id,
    String formReportId,
    String unitId,
    String workingStatus,
    String searchTerm,
    num pageIndex = 1,
    String orderBy,
    String equipmentType,
    String detailEquipmentType,
    String orderByDesc,
    String fromDate,
    String toDate,
    num pageOffset,
    bool isNotShowLoading = false,
    bool isPaperReport,
  }) async {
    final param = {
      'Id': id,
      'FormReportId': formReportId,
      'UnitId': unitId == '0' ? null : unitId,
      'WorkingStatus': workingStatus == '0' ? null : workingStatus,
      'SearchTerm': searchTerm,
      'FromDate': fromDate,
      'IsPaperFormReport': isPaperReport?.toString(),
      'ToDate': toDate,
      'EquipmentTypeId': equipmentType == '0' ? null : equipmentType,
      'EquipmentDetailId': detailEquipmentType == '0' ? null : detailEquipmentType,
      'orderBy': orderBy ?? 'descend',
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'pageSize': rAppPageSize.toString(),
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/mergeformreport',
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

  Future<ServerResponse<String>> createReports(
    String scheduleId,
    String equipmentTypeId,
    String equipmentDetailId, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'scheduleId': scheduleId,
        'equipmentTypeId': equipmentTypeId,
        'equipmentDetailId': equipmentDetailId,
      };

      final data = await _provider.post('/mergeformreport', map,
          isRequireAuth: requireAuth, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> createConstructionReports(
    String scheduleId,
    String equipmentTypeId,
    String equipmentDetailId, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'scheduleId': scheduleId,
        'equipmentTypeId': equipmentTypeId,
        'equipmentDetailId': equipmentDetailId,
      };

      final data = await _provider.post('/constructionformreport', map,
          isRequireAuth: requireAuth, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }


  Future<ServerResponse<String>> updatePaperForm(
    String scheduleId, {
    bool isPaperFormReport = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'scheduleId': scheduleId,
        'isPaperFormReport': isPaperFormReport.toString(),
      };

      final data = await _provider.post('/mergeformreport/update-paper-form', map,
          isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> createReportsCopy(
    String scheduleId,
    String formReportId,
    String equipmentTypeId,
    String equipmentDetailId, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'formReportId': formReportId,
        'scheduleId': scheduleId,
        'equipmentTypeId': equipmentTypeId,
        'equipmentDetailId': equipmentDetailId,
      };

      final data = await _provider.post('/formreport/copy-formreport', map,
          isRequireAuth: requireAuth, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> confirmComplete(
    String scheduleId, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'scheduleId': scheduleId,
      };

      final data = await _provider.post('/individualjob/confirm-complete', map,
          isRequireAuth: requireAuth, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> createMeterReport(
    String scheduleId, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'scheduleId': scheduleId,
      };

      final data = await _provider.post(
          '/mergeformreport/create-meter-formreport', map,
          isRequireAuth: requireAuth, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
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
    final data = await _provider.post('/formreport/$endpoint', params,
        isRequireAuth: true);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> approvalLeader({
    List<String> ids,
    String content,
    bool isApproval,
    bool isBackgroundMode = false,
  }) async {
    final params = {'note': content ?? '', 'ids': ids};
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

  Future<ServerResponse<String>> sendToTeam({
    String id,
    String approveId,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {'note': content ?? '', 'id': id, 'approveId': approveId};

    final data = await _provider.post('/mergeformreport/send', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> approvalTeam({
    String id,
    String presidentCompanyUserId,
    String presidentCenterUserId,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'note': content ?? '',
      'id': id,
      'presidentCenterUserId': presidentCenterUserId,
      'presidentCompanyUserId': presidentCompanyUserId
    };

    final data = await _provider.post('/mergeformreport/accept', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> approvalCenter({
    List<String> ids,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'note': content ?? '',
      'ids': ids,
    };

    final data = await _provider.post(
        '/mergeformreport/accept/president-center', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> approvalCompany({
    List<String> ids,
    String content,
    bool isRedSignature = false,
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'note': content ?? '',
      'ids': ids,
      'isRedSignature': isRedSignature,
    };

    final data = await _provider.post(
        '/mergeformreport/accept/president-company', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> reject({
    List<String> ids,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'note': content ?? '',
      'ids': ids,
    };

    final data = await _provider.post('/mergeformreport/reject', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> sendOperation({
    String formReportId,
    String content,
    String approveId,
  }) async {
    final params = {
      'formReportId': formReportId,
      'note': content ?? '',
      'approveId': approveId
    };
    final data = await _provider.post('/formreport/operation-send', params,
        isRequireAuth: true);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<ApprovalHistoryResponse>> getApprovalHistory(
      {String id,
      String orderByDesc,
      String pageOffset,
      bool backgroundMode = true}) async {
    final param = <String, dynamic>{
      'id': id,
      'pageIndex': '1',
      'pageSize': '99',
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/mergeformreport/approvalhistory',
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

  Future<ServerResponse<List<MergeReportPDFModel>>> getMergeReportPDF(
      String workId) async {
    try {
      final data = await _provider.get('/mergeformreport/$workId/pdfs',
          isRequireAuth: true);
      final response = ServerResponse<List<MergeReportPDFModel>>.fromJson(data);
      final report = data['data']
          ?.list
          ?.map((e) => MergeReportPDFModel.fromJson(JSON(e)))
          ?.toList();
      response.setData(report);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> createReportsCopyUnschedule(
    String formReportId,
    String groupId,
    String workType,
    String unitId,
    String equipmentTypeId,
    String equipmentDetailId,
    String createdDate,
    String location,
    String note, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'formReportId': formReportId,
        'groupId': groupId,
        'workType': int.tryParse(workType ?? '0') ?? 0,
        'unitId': unitId,
        'equipmentTypeId': equipmentTypeId,
        'equipmentDetailId': equipmentDetailId,
        'createdDate': createdDate,
        'location': location,
        'note': note,
      };

      final data = await _provider.post('/formreport/copy-formReport-unschedule', map,
          isRequireAuth: requireAuth, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      if (response.isLoadSuccess) {
          response.setData(data['data'].stringValue);
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> copyConstructionReports(
    String formReportId,
    String scheduleId,
    String equipmentTypeId,
    String equipmentDetailId, {
    bool requireAuth = true,
    bool isNotShowLoading = false,
  }) async {
    try {
      final map = {
        'formReportId': formReportId,
        'scheduleId': scheduleId,
        'equipmentTypeId': equipmentTypeId,
        'equipmentDetailId': equipmentDetailId,
      };

      final data = await _provider.post('/constructionformreport/copy-formreport', map,
          isRequireAuth: requireAuth, backgroundMode: isNotShowLoading);
      final response = ServerResponse<String>.fromJson(data);
      if (response.isLoadSuccess) {
        response.setData(data['data'].stringValue);
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}
