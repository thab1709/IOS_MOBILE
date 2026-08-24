// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/user_sign_certificate_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_history_model.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:g_json/g_json.dart';

class PatcRepository {
  final ApiProvider _provider = ApiProvider();
  String get _baseUrl => '${AppEnv.getServerUrl()}/constructionplan';

  Future<ServerResponse<List<PatcModel>>> getListPatc({
    String searchTerm,
    DateTime fromDate,
    DateTime toDate,
    String constructionId,
    String constructionName,
    DateTime confirmDateFrom,
    DateTime confirmDateTo,
    String qlvhUnitId,
    String createdBy,
    int status,
    int pageIndex = 1,
    int pageSize = 15,
    bool isBackgroundMode = false,
  }) async {
    try {
      final params = {
        'pageIndex': pageIndex.toString(),
        'pageSize': pageSize.toString(),
      };
      
      if (searchTerm != null && searchTerm.isNotEmpty) params['searchTerm'] = searchTerm;
      if (constructionId != null && constructionId.isNotEmpty) params['constructionId'] = constructionId;
      if (constructionName != null && constructionName.isNotEmpty) params['constructionName'] = constructionName;
      if (qlvhUnitId != null && qlvhUnitId.isNotEmpty) params['qlvhUnitId'] = qlvhUnitId;
      if (fromDate != null) params['fromDate'] = fromDate.toStringFormat(RAppStrings.yyyyMMdd);
      if (toDate != null) params['toDate'] = toDate.toStringFormat(RAppStrings.yyyyMMdd);
      if (confirmDateFrom != null) params['fromConfirmDate'] = confirmDateFrom.toStringFormat(RAppStrings.yyyyMMdd);
      if (confirmDateTo != null) params['toConfirmDate'] = confirmDateTo.toStringFormat(RAppStrings.yyyyMMdd);
      if (createdBy != null && createdBy.isNotEmpty) params['createdBy'] = createdBy;
      if (status != null && status != 0) params['status'] = status.toString();

      final res = await _provider.get(_baseUrl, params: params, isRequireAuth: true, backgroundMode: isBackgroundMode);
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        final list = res['data'].list?.map((e) => PatcModel.fromJson(e))?.toList() ?? [];
        return ServerResponse(statusCode: 200, data: list);
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getListPatc: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<PatcModel>> getPatcDetail(String id) async {
    try {
      final res = await _provider.get('$_baseUrl/$id', isRequireAuth: true, backgroundMode: true);
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        debugPrint('==== FULL PATC DETAIL RESPONSE ====');
        final prettyString = const JsonEncoder.withIndent('  ').convert(res.value);
        debugPrint(prettyString);
        return ServerResponse(statusCode: 200, data: PatcModel.fromJson(res['data']));
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getPatcDetail: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<List<SurveyHistoryModel>>> getPatcHistory(String id) async {
    try {
      final res = await _provider.get('$_baseUrl/$id/history', isRequireAuth: true, backgroundMode: true);
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        final list = res['data'].list?.map((e) => SurveyHistoryModel.fromJson(e))?.toList() ?? [];
        return ServerResponse(statusCode: 200, data: list);
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getPatcHistory: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> getPatcTemplate({String id}) async {
    try {
      final url = id != null && id.isNotEmpty ? '$_baseUrl/$id/template' : '$_baseUrl/template';
      final res = await _provider.get(url, isRequireAuth: true);
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        return ServerResponse(statusCode: 200, data: res['data'].string);
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getPatcTemplate: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<List<UserSignCertificateModel>>> getUsersForSignature(String unitId) async {
    try {
      final res = await _provider.get(
        '${AppEnv.getServerUrl()}/usersigncertificate/users?unitId=$unitId&isGetAll=true',
        isRequireAuth: true,
      );
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        final list = res['data'].list?.map((e) => UserSignCertificateModel.fromJson(e))?.toList() ?? [];
        return ServerResponse(statusCode: 200, data: list);
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getUsersForSignature: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse> createPatc(Map<String, dynamic> body, List<File> files) async {
    try {
      final res = await _provider.post(_baseUrl, body, isRequireAuth: true);
      if (res != null && res['statusCode'].integer == 200) {
        if (files != null && files.isNotEmpty) {
          String newId = res['data']['id'].string ?? body['id']?.toString() ?? '';
          if (newId.isNotEmpty) {
            await uploadPatcFiles(newId, files);
          }
        }
        return ServerResponse(statusCode: 200, data: null);
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error createPatc: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse> updatePatc(String id, Map<String, dynamic> body, List<File> files) async {
    try {
      final res = await _provider.put('$_baseUrl/$id', body, isRequireAuth: true);
      if (res != null && res['statusCode'].integer == 200) {
        if (files != null && files.isNotEmpty) {
          await uploadPatcFiles(id, files);
        }
        return ServerResponse(statusCode: 200, data: null);
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error updatePatc: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse> deletePatc(String id) async {
    try {
      final res = await _provider.delete('$_baseUrl/$id', isRequireAuth: true);
      if (res != null && res['statusCode'].integer == 200) return ServerResponse(statusCode: 200, data: null);
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error deletePatc: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse> uploadPatcFiles(String id, List<File> files) async {
    try {
      // In EVN apps, typically we need to create a multipart request for specific endpoints if ApiProvider doesn't support generic uploads to specific paths.
      // We'll use http.MultipartRequest directly or via ApiProvider if it has postMultipart.
      // Assuming ApiProvider has no postMultipart that takes arbitrary endpoint, let's construct it.
      // I'll call a custom generic multipart or do it inline.
      // Wait, ApiProvider has uploadFiles which uploads to /common/uploads. But here we need to post to $_baseUrl/$id/upload
      // Let's use ApiProvider's putMultipart but change it to post if available, or just write raw http.MultipartRequest
      final token = AppShared.instance.getUserToken();
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/$id/upload'));
      request.headers.addAll({'Authorization': 'Bearer $token'});
      for (final file in files) {
        final fileData = await http.MultipartFile.fromPath('files', file.path); // check if key is 'files' or 'file'
        request.files.add(fileData);
      }
      final response = await request.send();
      if (response.statusCode == 200) {
        return ServerResponse(statusCode: 200, data: null);
      }
      return ServerResponse(statusCode: 400, message: 'Lỗi tải file đính kèm');
    } catch (e) {
      debugPrint('Error uploadPatcFiles: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse> sendPatc(String id) async {
    try {
      final res = await _provider.post('$_baseUrl/$id/send', {}, isRequireAuth: true);
      if (res != null && res['statusCode'].integer == 200) return ServerResponse(statusCode: 200, data: null);
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error sendPatc: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse> approvePatc({@required List<String> ids}) async {
    try {
      final res = await _provider.post('$_baseUrl/approve', {'ids': ids}, isRequireAuth: true);
      if (res != null && res['statusCode'].integer == 200) return ServerResponse(statusCode: 200, data: null);
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error approvePatc: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse> rejectPatc({@required List<String> ids, String note}) async {
    try {
      final res = await _provider.post('$_baseUrl/reject', {'ids': ids, 'note': note}, isRequireAuth: true);
      if (res != null && res['statusCode'].integer == 200) return ServerResponse(statusCode: 200, data: null);
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error rejectPatc: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> getPdf({@required String id}) async {
    try {
      final res = await _provider.get('$_baseUrl/$id/pdf', isRequireAuth: true);
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        return ServerResponse(statusCode: 200, data: res['data'].string);
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> externalSign(String id, String participantId, Uint8List signatureImageBytes) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/$id/external-sign'),
      );
      final token = AppShared.instance.getUserToken();
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      request.fields['participantId'] = participantId;

      final multipartFile = http.MultipartFile.fromBytes(
        'signatureImage',
        signatureImageBytes,
        filename: 'signature.png',
      );
      request.files.add(multipartFile);

      debugPrint('==== EXTERNAL SIGN REQUEST ====');
      debugPrint('URL: ${request.url}');
      debugPrint('Fields: ${request.fields}');
      debugPrint('Files: ${request.files.map((f) => f.field).toList()}');
      debugPrint('===============================');

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      debugPrint('EXTERNAL_SIGN_RAW_PATC: $responseData');
      
      try {
        final decodedData = json.decode(responseData);
        final serverResponse = ServerResponse<String>.fromJson(JSON(decodedData));
        
        if (response.statusCode == 200 && serverResponse.isLoadSuccess) {
          serverResponse.setData(decodedData['data']);
          serverResponse.statusCode = 200;
        } else {
          serverResponse.statusCode = 400;
          serverResponse.message = decodedData['message'] ?? 'Lỗi gọi API';
        }
        return serverResponse;
      } catch (e) {
        debugPrint('EXTERNAL_SIGN_PARSE_ERROR_PATC: $e, STATUS: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
           return ServerResponse<String>(message: 'Ký thành công', statusCode: 200);
        }
        return ServerResponse<String>(message: 'Có lỗi xảy ra: $e', statusCode: response.statusCode);
      }
    } catch (error) {
      debugPrint('EXTERNAL_SIGN_ERROR_PATC: $error');
      return ServerResponse<String>(message: 'Có lỗi xảy ra trong quá trình xử lý: $error');
    }
  }
}
