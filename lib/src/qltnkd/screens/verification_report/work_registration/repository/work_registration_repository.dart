// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/models/work_registration_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_history_model.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';

class WorkRegistrationRepository {
  final ApiProvider _provider = ApiProvider();
  String get _baseUrl {
    if (AppEnv.getAppEnv() == ENV.dev) {
      return 'http://125.212.226.94:5006/tnkd/api/workregistration';
    }
    return '${AppEnv.getServerUrl()}/workregistration';
  }

  Future<ServerResponse<List<WorkRegistrationModel>>> getList({
    String searchTerm,
    DateTime fromDate,
    DateTime toDate,
    String constructionId,
    String qlvhUnitId,
    DateTime confirmDateFrom,
    DateTime confirmDateTo,
    String createdBy,
    String confirmBy,
    String patcId,
    int status,
    int pageIndex = 1,
    int pageSize = 15,
    bool isBackgroundMode = false,
  }) async {
    try {
      final params = <String, dynamic>{
        'pageIndex': pageIndex,
        'pageSize': pageSize,
      };

      if (searchTerm != null && searchTerm.isNotEmpty) params['searchTerm'] = searchTerm;
      if (constructionId != null && constructionId.isNotEmpty) params['constructionId'] = constructionId;
      if (qlvhUnitId != null && qlvhUnitId.isNotEmpty) params['qlvhUnitId'] = qlvhUnitId;
      if (fromDate != null) params['registerDateFrom'] = fromDate.toStringFormat(RAppStrings.yyyyMMdd);
      if (toDate != null) params['registerDateTo'] = toDate.toStringFormat(RAppStrings.yyyyMMdd);
      if (confirmDateFrom != null) params['confirmDateFrom'] = confirmDateFrom.toStringFormat(RAppStrings.yyyyMMdd);
      if (confirmDateTo != null) params['confirmDateTo'] = confirmDateTo.toStringFormat(RAppStrings.yyyyMMdd);
      if (createdBy != null && createdBy.isNotEmpty) params['createdBy'] = createdBy;
      if (confirmBy != null && confirmBy.isNotEmpty) params['confirmBy'] = confirmBy;
      if (patcId != null && patcId.isNotEmpty) params['patcId'] = patcId;
      if (status != null) params['status'] = status;

      final res = await _provider.post('$_baseUrl/paging', params, isRequireAuth: true, backgroundMode: isBackgroundMode);
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        final list = res['data'].list?.map((e) => WorkRegistrationModel.fromJson(e))?.toList() ?? [];
        return ServerResponse(statusCode: 200, data: list);
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getListWorkRegistration: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<WorkRegistrationDetailModel>> getDetail(String id) async {
    try {
      final res = await _provider.get('$_baseUrl/$id', isRequireAuth: true, backgroundMode: true);
      if (res != null) {
        if (res['statusCode'] != null && res['statusCode'].integer == 200 && res['data'] != null) {
          return ServerResponse(statusCode: 200, data: WorkRegistrationDetailModel.fromJson(res['data']));
        }
        if (res['id'] != null || res['code'] != null) {
          return ServerResponse(statusCode: 200, data: WorkRegistrationDetailModel.fromJson(res));
        }
      }
      return ServerResponse(statusCode: 400, message: 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getWorkRegistrationDetail: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> create(Map<String, dynamic> body) async {
    try {
      final res = await _provider.post(_baseUrl, body, isRequireAuth: true);
      debugPrint('createWorkRegistration res: ${res?.rawString()}');
      if (res != null && (res.value == true || (res.value is String && res.value.toString().isNotEmpty) || res['statusCode'].integer == 200)) {
        return ServerResponse(statusCode: 200, data: 'Thành công', message: 'Thành công');
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi tạo mới');
    } catch (e) {
      debugPrint('Error createWorkRegistration: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<List<StringOptionModel>>> getApprovedPatcList() async {
    try {
      final res = await _provider.get('$_baseUrl/approved-patc', isRequireAuth: true, backgroundMode: true);
      // Case 1: API trả về trực tiếp mảng JSON (List)
      if (res != null && res.list != null) {
        final list = res.list.map((e) {
          final code = e['code']?.string ?? '';
          final name = e['constructionName']?.string ?? '';
          final title = code.isNotEmpty && name.isNotEmpty ? '$code - $name' : (code.isNotEmpty ? code : name);
          return StringOptionModel(title, e['id']?.string);
        }).toList();
        return ServerResponse(statusCode: 200, data: list);
      }

      // Case 2: API trả về JSON Object có chứa data và statusCode
      if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
        final list = res['data'].list?.map((e) {
          final code = e['code']?.string ?? '';
          final name = e['constructionName']?.string ?? '';
          final title = code.isNotEmpty && name.isNotEmpty ? '$code - $name' : (code.isNotEmpty ? code : name);
          return StringOptionModel(title, e['id']?.string);
        })?.toList() ?? [];
        return ServerResponse(statusCode: 200, data: list);
      }

      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getApprovedPatcList: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> update(String id, Map<String, dynamic> body) async {
    try {
      final res = await _provider.put('$_baseUrl/$id', body, isRequireAuth: true);
      debugPrint('updateWorkRegistration res: ${res?.rawString()}');
      if (res != null && (res.value == true || res['statusCode'].integer == 200)) {
        return ServerResponse(statusCode: 200, data: 'Thành công', message: 'Thành công');
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi cập nhật');
    } catch (e) {
      debugPrint('Error updateWorkRegistration: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> delete(String id) async {
    try {
      final res = await _provider.delete('$_baseUrl/$id', isRequireAuth: true);
      if (res != null) {
        if (res.value is Map && res['statusCode'].value != null && res['statusCode'].integer != 200) {
          return ServerResponse(statusCode: 400, message: res['message']?.string ?? 'Xóa thất bại');
        }
        return ServerResponse(statusCode: 200, data: 'Thành công', message: 'Thành công');
      }
      return ServerResponse(statusCode: 400, message: 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error deleteWorkRegistration: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<List<WorkRegistrationAttachmentModel>>> uploadFiles(List<File> files) async {
    try {
      final token = AppShared.instance.getUserToken();
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/upload'));
      request.headers['Authorization'] = 'Bearer $token';
      for (final file in files) {
        final fileData = await http.MultipartFile.fromPath('files', file.path);
        request.files.add(fileData);
      }
      final streamedRes = await request.send();
      final responseBody = await streamedRes.stream.bytesToString();
      if (streamedRes.statusCode == 200) {
        final rawJson = jsonDecode(responseBody);
        List<WorkRegistrationAttachmentModel> list = [];
        if (rawJson['data'] != null && rawJson['data'] is List) {
          for (var item in rawJson['data'] as List) {
            list.add(WorkRegistrationAttachmentModel(
              filePath: item['filePath']?.toString(),
              fileName: item['fileName']?.toString(),
              fileSize: item['fileSize'] != null ? int.tryParse(item['fileSize'].toString()) : null,
              contentType: item['contentType']?.toString(),
            ));
          }
        }
        return ServerResponse(statusCode: 200, data: list);
      }
      return ServerResponse(statusCode: 400, message: 'Upload thất bại');
    } catch (e) {
      debugPrint('Error uploadWorkRegistrationFiles: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<WorkRegistrationDetailModel>> getPatcFiles(String patcId) async {
    try {
      final res = await _provider.get('$_baseUrl/patc-files/$patcId', isRequireAuth: true, backgroundMode: true);
      if (res != null) {
        if (res['statusCode']?.integer == 200 && res['data'] != null) {
          return ServerResponse(statusCode: 200, data: WorkRegistrationDetailModel.fromJson(res['data']));
        }
        // Fallback for raw response
        if (res['patcSignedFilePath'] != null || res['patcFileName'] != null || res['bbksFiles'] != null) {
          return ServerResponse(statusCode: 200, data: WorkRegistrationDetailModel.fromJson(res));
        }
        return ServerResponse(statusCode: 200, data: WorkRegistrationDetailModel.fromJson(res));
      }
      return ServerResponse(statusCode: 400, message: 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getPatcFiles: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<List<Map<String, dynamic>>>> getApprovedPatc() async {
    try {
      final res = await _provider.get('$_baseUrl/approved-patc', isRequireAuth: true, backgroundMode: true);
      if (res != null) {
        final jsonList = (res['statusCode'] != null && res['statusCode'].integer == 200 && res['data'] != null) 
            ? res['data'].list 
            : res.list;
            
        final list = jsonList?.map((item) => <String, dynamic>{
          'id': item['id'].string,
          'code': item['code'].string,
          'constructionName': item['constructionName'].string,
          'constructionId': item['constructionId'].string,
          'qlvhUnitName': item['qlvhUnitName'].string,
          'qlvhUnitId': item['qlvhUnitId'].string,
        })?.toList() ?? [];
        return ServerResponse(statusCode: 200, data: list);
      }
      return ServerResponse(statusCode: 400, message: 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getApprovedPatc: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> send(String id, String receiverNote) async {
    try {
      final res = await _provider.post('$_baseUrl/send', {
        'ids': [id],
        'receiverNote': receiverNote ?? ''
      }, isRequireAuth: true);
      if (res != null && (res['statusCode']?.integer == 200 || res == true)) {
        return ServerResponse(statusCode: 200, data: 'Thành công');
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error sendWorkRegistration: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> approve(String id) async {
    try {
      final res = await _provider.post('$_baseUrl/approve', {'ids': [id]}, isRequireAuth: true);
      if (res != null && (res['statusCode']?.integer == 200 || res == true)) {
        return ServerResponse(statusCode: 200, data: 'Thành công');
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error approveWorkRegistration: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<String>> reject(String id, String note) async {
    try {
      final res = await _provider.post('$_baseUrl/reject', {'ids': [id], 'note': note}, isRequireAuth: true);
      if (res != null && (res['statusCode']?.integer == 200 || res == true)) {
        return ServerResponse(statusCode: 200, data: 'Thành công');
      }
      return ServerResponse(statusCode: 400, message: res != null ? res['message']?.string : 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error rejectWorkRegistration: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }

  Future<ServerResponse<List<SurveyHistoryModel>>> getHistory(String id) async {
    try {
      final res = await _provider.get('$_baseUrl/$id/history', isRequireAuth: true, backgroundMode: true);
      if (res != null) {
        final jsonList = (res['statusCode'] != null && res['statusCode'].integer == 200 && res['data'] != null) 
            ? res['data'].list 
            : res.list;
            
        if (jsonList != null) {
          final list = jsonList.map((e) => SurveyHistoryModel.fromJson(e))?.toList() ?? [];
          return ServerResponse(statusCode: 200, data: list);
        }
      }
      return ServerResponse(statusCode: 400, message: 'Lỗi kết nối');
    } catch (e) {
      debugPrint('Error getHistoryWorkRegistration: $e');
      return ServerResponse(statusCode: 400, message: e.toString());
    }
  }
}
