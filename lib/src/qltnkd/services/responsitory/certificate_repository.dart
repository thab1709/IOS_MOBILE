// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/constance.dart';
import 'package:evnmobile/src/qltnkd/models/pdf_model.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/approval_history_response.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/list_certificate_model.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import '../server_response.dart';

class CertificateRepository{
  final _provider = ApiProvider();

  Future<ServerResponse<ListCertificateResponse>> getListCertificate(
      {String status,
        String certificateType,
        String teamId,
        String departmentId,
        String userImp,
        String fromDate,
        String toDate,
        String content,
        String location,
        String workType,
        String unitId,
        String searchTerm,
        num pageIndex = 1,
        bool isNotShowLoading = false,
        num pageOffset}) async {
    final param = <String, dynamic>{
      'status': status == '0' ? '' : status,
      'certificateType': certificateType == '0' ? '' : certificateType,
      'teamId': teamId == '0' ? '' : teamId,
      'departmentId': departmentId == '0' ? '' : departmentId,
      'userImp': userImp == '0' ? '' : userImp,
      'fromDate': fromDate,
      'toDate': toDate,
      'content': content,
      'location': location == '0' ? '' : location,
      'workType': workType == '0' ? '' : workType,
      'unitId': unitId == '0' ? '' : unitId,
      'searchTerm': searchTerm,
      'pageSize':  rAppPageSize.toString(),
      'pageIndex': pageIndex.toString(),
      'orderBy': 'A',
      'orderByDesc': pageOffset?.toString(),
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/certificate',
          params: param, isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<ListCertificateResponse>.fromJson(data);
      final certificates = ListCertificateResponse.fromJson(data);
      response.setData(certificates);
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
      'CertificateId': formReportId,
      'pageIndex': '1',
      'pageSize': '99',
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/certificate/approvalhistory',
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

    final data = await _provider.post('/certificate/$endpoint', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<List<PDFModel>>.fromJson(data);
    final result = data['data'].listObject?.map((e) => PDFModel.fromJson(JSON(e)))?.toList() ?? [];
    response.data = result;
    return response;
  }

  Future<ServerResponse<String>> getPdf({String id}) async {
    final param = <String, dynamic>{'certificateId': id};
    try {
      final data = await _provider.post('/common/get-pdf-certificate', param, isRequireAuth: true);
      return ServerResponse<String>.fromJson(data)..setData(data['data'].string);
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<ServerResponse<String>> exportCertificate({String id, int type}) async {
    final param = <String, dynamic>{'formReportId': id, 'type': type};
    try {
      final data = await _provider.post('/certificate', param, isRequireAuth: true);
      return ServerResponse<String>.fromJson(data)..setData(data['data'].string);
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<ServerResponse<String>> signatureCertificate(
      {String certificateId}) async {
    final param = <String, dynamic>{
      'certificateId': certificateId,
    };
    try {
      final data = await _provider.get('/certificate/digitalsign',
          params: param, isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return ServerResponse();
    }
  }

}
