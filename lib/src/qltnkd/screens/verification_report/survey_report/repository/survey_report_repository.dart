import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:evnmobile/app_env.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_history_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';

class SurveyReportRepository {
  final ApiProvider _provider = ApiProvider();
  String get _baseUrl => AppEnv.getServerUrl();

  Future<ServerResponse<List<SurveyReportModel>>> getListSurveyReport(
      {String searchTerm,
      String fromDate,
      String toDate,
      String constructionName,
      String constructionId,
      String qlvhUnitId,
      String confirmDateFrom,
      String confirmDateTo,
      int status,
      bool hasPatc,
      String createdBy,
      num pageIndex = 1,
      num pageSize = 10,
      bool requireAuth = true,
      bool isBackgroundMode = false}) async {
    try {
      final params = <String, dynamic>{
        'pageIndex': pageIndex.toString(),
        'pageSize': pageSize.toString(),
      };
      
      if (searchTerm != null && searchTerm.isNotEmpty) {
        params['searchTerm'] = searchTerm;
      }
      if (fromDate != null && fromDate.isNotEmpty) {
        params['fromDate'] = fromDate;
      }
      if (toDate != null && toDate.isNotEmpty) {
        params['toDate'] = toDate;
      }
      if (constructionName != null && constructionName.isNotEmpty) {
        params['constructionName'] = constructionName;
      }
      if (constructionId != null && constructionId.isNotEmpty) {
        params['constructionId'] = constructionId;
      }
      if (qlvhUnitId != null && qlvhUnitId.isNotEmpty) {
        params['qlvhUnitId'] = qlvhUnitId;
      }
      if (confirmDateFrom != null && confirmDateFrom.isNotEmpty) {
        params['confirmDateFrom'] = confirmDateFrom;
      }
      if (confirmDateTo != null && confirmDateTo.isNotEmpty) {
        params['confirmDateTo'] = confirmDateTo;
      }
      if (status != null && status > 0) {
        params['status'] = status.toString();
      }
      if (hasPatc != null) {
        params['hasPatc'] = hasPatc.toString();
      }
      if (createdBy != null && createdBy.isNotEmpty) {
        params['createdBy'] = createdBy;
      }

      final res = await _provider.get('$_baseUrl/surveyreport',
          isRequireAuth: requireAuth,
          backgroundMode: isBackgroundMode,
          params: params);

      final response = ServerResponse<List<SurveyReportModel>>.fromJson(res);
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        final result = res['data'].list?.map((e) => SurveyReportModel.fromJson(e))?.toList() ?? [];
        response.setData(result);
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<SurveyReportModel>> getDetail(
      {@required String id}) async {
    try {
      final data = await _provider.get('$_baseUrl/surveyreport/$id',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<SurveyReportModel>.fromJson(data);
      if (data['data'] != null) {
        response.setData(SurveyReportModel.fromJson(data['data']));
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<SurveyHistoryModel>>> getHistory(
      {@required String id}) async {
    try {
      final res = await _provider.get('$_baseUrl/surveyreport/$id/history',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<SurveyHistoryModel>>.fromJson(res);
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        final result = res['data'].list?.map((e) => SurveyHistoryModel.fromJson(e))?.toList() ?? [];
        response.setData(result);
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<dynamic>> sendSurveyReport({@required String id, String note = ''}) async {
    try {
      final payload = {'note': note};
      final data = await _provider.post('$_baseUrl/surveyreport/$id/send', payload,
          isRequireAuth: true);
      return ServerResponse<dynamic>.fromJson(data);
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> getPdf({String id}) async {
    final url = AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/surveyreport/$id/pdf' : '$_baseUrl/surveyreport/$id/pdf';
    debugPrint('--- survey_report_repository PDF url: $url ---');
    return ServerResponse<String>(statusCode: 200, message: 'Thành công', data: url);
  }

  Future<ServerResponse<String>> createSurveyReport(Map<String, dynamic> payload) async {
    try {
      final data = await _provider.post('$_baseUrl/surveyreport', payload,
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data);
      if (data['data'] != null) {
        response.setData(JSON(data['data'])['id'].stringValue ?? '');
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> updateSurveyReport(String id, Map<String, dynamic> payload) async {
    try {
      final data = await _provider.put('$_baseUrl/surveyreport/$id', payload,
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data);
      if (data['data'] != null) {
        response.setData(JSON(data['data'])['id'].stringValue ?? '');
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<dynamic>> deleteSurveyReport(String id) async {
    try {
      final data = await _provider.delete('$_baseUrl/surveyreport/$id',
          isRequireAuth: true);
      return ServerResponse<dynamic>.fromJson(data);
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> uploadAttachment(String surveyReportId, File file) async {
    try {
      final token = AppShared.instance.getUserToken();
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/surveyreport/upload-attachment'));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      request.fields['surveyReportId'] = surveyReportId;
      var fileData = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(fileData);
      
      final streamResponse = await request.send();
      final responseString = await streamResponse.stream.bytesToString();
      final jsonMap = jsonDecode(responseString);
      
      final response = ServerResponse<String>.fromJson(JSON(jsonMap));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<bool>> deleteAttachment(String attachmentId) async {
    try {
      final res = await _provider.delete('/surveyreport/attachment/$attachmentId');
      return ServerResponse<bool>.fromJson(res);
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> uploadWordFile(String id, File file) async {
    try {
      final token = AppShared.instance.getUserToken();
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/surveyreport/$id/upload'));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      var fileData = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(fileData);
      
      final streamResponse = await request.send();
      final responseString = await streamResponse.stream.bytesToString();
      final jsonMap = jsonDecode(responseString);
      
      final response = ServerResponse<String>.fromJson(JSON(jsonMap));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse(message: error.toString(), statusCode: 500);
    }
  }

  Future<ServerResponse<String>> downloadTemplate(String id, String savePath) async {
    try {
      final token = AppShared.instance.getUserToken();
      final url = '$_baseUrl/surveyreport/$id/template';
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // Assume it returns file bytes
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        return ServerResponse<String>(statusCode: 200, message: 'Thành công', data: savePath);
      } else {
        // Maybe it returned a JSON with error
        return ServerResponse<String>(statusCode: response.statusCode, message: 'Lỗi tải file');
      }
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse(message: error.toString(), statusCode: 500);
    }
  }

  Future<ServerResponse<dynamic>> approveSurveyReport({@required List<String> ids}) async {
    try {
      final payload = {'ids': ids};
      final data = await _provider.post('$_baseUrl/surveyreport/approve', payload,
          isRequireAuth: true);
      return ServerResponse<dynamic>.fromJson(data);
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse(message: error.toString(), statusCode: 500);
    }
  }

  Future<ServerResponse<dynamic>> rejectSurveyReport({@required List<String> ids, @required String note}) async {
    try {
      final payload = {'ids': ids, 'note': note};
      final data = await _provider.post('$_baseUrl/surveyreport/reject', payload,
          isRequireAuth: true);
      return ServerResponse<dynamic>.fromJson(data);
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse(message: error.toString(), statusCode: 500);
    }
  }

  static List<StringOptionModel> _cachedConstructions;
  static List<StringOptionModel> _cachedUnits;

  Future<ServerResponse<List<StringOptionModel>>> getConstructions() async {
    if (_cachedConstructions != null && _cachedConstructions.isNotEmpty) {
      final response = ServerResponse<List<StringOptionModel>>();
      response.setData(_cachedConstructions);
      response.statusCode = 200;
      return response;
    }
    try {
      final data = await _provider.get(
          '$_baseUrl/construction/all?pageSize=9999&isGetAll=true',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<StringOptionModel>>.fromJson(data);
      final jsonList = (data['statusCode'] != null && data['statusCode'].integer == 200 && data['data'] != null) 
          ? data['data'].list 
          : data.list;

      final result = jsonList != null
          ? jsonList.map((e) => StringOptionModel(
                  JSON(e)['name'].stringValue, JSON(e)['id'].stringValue))
              ?.toList() ?? []
          : <StringOptionModel>[];
      response.setData(result);
      if (result.isNotEmpty) _cachedConstructions = result;
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<StringOptionModel>>> getUnits() async {
    if (_cachedUnits != null && _cachedUnits.isNotEmpty) {
      final response = ServerResponse<List<StringOptionModel>>();
      response.setData(_cachedUnits);
      response.statusCode = 200;
      return response;
    }
    try {
      final data = await _provider.get('$_baseUrl/unit?IsAll=true',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<StringOptionModel>>.fromJson(data);
      final result = data['data']?.value != null 
          ? JSON(data['data'])
              ?.list
              ?.map((e) => StringOptionModel(
                  JSON(e)['name'].stringValue, JSON(e)['id'].stringValue))
              ?.toList() ?? []
          : <StringOptionModel>[];
      response.setData(result);
      if (result.isNotEmpty) _cachedUnits = result;
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<StringOptionModel>>> getEmployees(String unitId) async {
    try {
      final data = await _provider.get(
          '$_baseUrl/usersigncertificate/users?unitId=$unitId&isGetAll=true',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<StringOptionModel>>.fromJson(data);
      // Fallback cho tên nhân viên có thể là fullName hoặc name
      final result = JSON(data['data'])
              ?.list
              ?.map((e) {
                final fullName = JSON(e)['fullName'].stringValue;
                final name = JSON(e)['name'].stringValue;
                final position = JSON(e)['userPositionName'].string ?? '';
                return StringOptionModel(
                  (fullName != null && fullName.isNotEmpty) ? fullName : name,
                  JSON(e)['id'].stringValue,
                  position,
                );
              })
              ?.toList() ??
          [];
      response.setData(result);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> externalSign(String id, String participantId, Uint8List signatureImageBytes) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/surveyreport/$id/external-sign'),
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

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      debugPrint('EXTERNAL_SIGN_RAW_BBKS: $responseData');
      
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
        debugPrint('EXTERNAL_SIGN_PARSE_ERROR_BBKS: $e, STATUS: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
           return ServerResponse<String>(message: 'Ký thành công', statusCode: 200);
        }
        return ServerResponse<String>(message: 'Có lỗi xảy ra: $e', statusCode: response.statusCode);
      }
    } catch (error) {
      debugPrint('EXTERNAL_SIGN_ERROR_BBKS: $error');
      return ServerResponse<String>(message: 'Có lỗi xảy ra trong quá trình xử lý: $error');
    }
  }
}
