// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;

class ApiProvider {
  // Shared persistent client — reuses TCP+TLS connections across all requests.
  static final http.Client _client = http.Client();

  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  final codeNoInternet = 700;
  static const _timeOut = 360;
  final codeTimeOut = 504;
  final commonCode = 10000;

  JSON _handleException(dynamic e, bool isBackgroundMode) {
    if (!isBackgroundMode) {
      ProgressHUD.dismiss();
    }
    debugPrint('API Exception: $e');
    if (e is SocketException) {
      return JSON(errorResponse(AppStrings.noInternet, codeNoInternet));
    } else if (e is TimeoutException) {
      return JSON(errorResponse(AppStrings.timeOutError, codeTimeOut));
    } else {
      return JSON(errorResponse(
          AppEnv.isDev() ? e.toString() : 'Đã có lỗi xảy ra. Xin thử lại sau!', commonCode));
    }
  }

  Map errorResponse(String message, int code) {
    return ServerResponse(message: message, statusCode: code).toJson();
  }

  Future<JSON> get(String url,
      {Map<String, dynamic> params,
      bool isRequireAuth = false,
      bool backgroundMode = false}) async {
    try {
      if (isRequireAuth) {
        final token = AppShared.instance.getUserToken();
        header.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
        debugPrint('Bearer $token');
      }
      if (!backgroundMode) {
        ProgressHUD.show();
      }
      // Build clean params: loại bỏ null, chuỗi rỗng, và 'null' string
      final cleanParams = <String, String>{};
      params?.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty && value.toString() != 'null') {
          cleanParams[key] = value.toString();
        }
      });
      final queryString = Uri(queryParameters: cleanParams).query;
      final requestUrl = url.startsWith('http') ? url : '${AppEnv.getServerUrl()}$url';
      debugPrint('API request: $requestUrl');
      debugPrint('API Query: $queryString');
      final response = await _client
          .get(
            Uri.parse('$requestUrl${queryString.isNotEmpty ? '?$queryString' : ''}'),
            headers: header,
          )
          .timeout(const Duration(seconds: _timeOut));
      debugPrint('API log code: ${response.statusCode}');
      final responseJson =
          _response(response, isBackgroundMode: backgroundMode);
      return responseJson;
    } catch (e) {
      return _handleException(e, backgroundMode);
    }
  }


  Future<JSON> post(String url, Map<dynamic, dynamic> params,
      {bool isRequireAuth = false, bool backgroundMode = false}) async {
    if (isRequireAuth) {
      final token = AppShared.instance.getUserToken();
      final strToken = 'API log Authorization Token: Bearer $token';
      for (var i = 0; i < strToken.length; i += 800) {
        debugPrint(strToken.substring(i, i + 800 > strToken.length ? strToken.length : i + 800));
      }
      header.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    }
    
    // Add Postman-like headers
    header.addAll({
      'User-Agent': 'PostmanRuntime/7.32.3',
      'Accept': '*/*',
      'Connection': 'keep-alive',
    });
    
    try {
      if (!backgroundMode) {
        ProgressHUD.show();
      }
      final body = jsonEncode(params);
      final requestUrl = url.startsWith('http') ? url : '${AppEnv.getServerUrl()}$url';
      debugPrint('API request: $requestUrl');
      final response = await _client
          .post(Uri.parse(requestUrl),
              body: body, headers: header)
          .timeout(const Duration(seconds: _timeOut));
      debugPrint('API log: ${response.request}');
      debugPrint(
          'API log query: ${response.statusCode}  ${jsonEncode(params)}');
      debugPrint('API log code: ${response.statusCode}');

      final responseJson =
          _response(response, isBackgroundMode: backgroundMode);
      return responseJson;
    } catch (e) {
      return _handleException(e, backgroundMode);
    }
  }

  Future<JSON> put(String url, Map<dynamic, dynamic> params,
      {bool isRequireAuth = false, bool backgroundMode = false}) async {
    if (isRequireAuth) {
      final token = AppShared.instance.getUserToken();
      header.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    }
    try {
      if (!backgroundMode) {
        ProgressHUD.show();
      }
      final query = jsonEncode(params);
      final requestUrl = url.startsWith('http') ? url : '${AppEnv.getServerUrl()}$url';
      debugPrint('API request: $requestUrl');
      final response = await _client
          .put(Uri.parse(requestUrl),
              body: query, headers: header)
          .timeout(const Duration(seconds: _timeOut));
      debugPrint('API log: ${response.request}');
      debugPrint('API log query:  ${jsonEncode(params)}');
      debugPrint('API log code: ${response.statusCode}');
      final responseJson =
          _response(response, isBackgroundMode: backgroundMode);
      return responseJson;
    } catch (e) {
      return _handleException(e, backgroundMode);
    }
  }

  Future<JSON> delete(String url,
      {bool isRequireAuth = true, Map<dynamic, dynamic> params}) async {
    if (isRequireAuth) {
      final token = AppShared.instance.getUserToken();
      header.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    }
    try {
      ProgressHUD.show();
      params?.removeWhere((key, value) => value == null || value == '');
      final queryString = Uri(queryParameters: params).query;
      final requestUrl = url.startsWith('http') ? url : '${AppEnv.getServerUrl()}$url';
      final response = await _client
          .delete(
            Uri.parse('$requestUrl${'?$queryString'}'),
            headers: header,
          )
          .timeout(const Duration(seconds: _timeOut));
      debugPrint('API log query: $queryString');
      debugPrint('API log: ${response.request}');
      debugPrint('API log code: ${response.statusCode}');

      final responseJson = _response(response);
      return responseJson;
    } catch (e) {
      return _handleException(e, false);
    }
  }

  Future<JSON> putMultipart(String endPoint, Map<String, String> params,
      {bool isRequireAuth = false,
      bool backgroundMode = false,
      List<File> files}) async {
    final Map<String, String> header = {};
    if (isRequireAuth) {
      final token = AppShared.instance.getUserToken();
      if (token == null || token.isEmpty) {
        return JSON(errorResponse('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.', 401));
      }
      header.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      if (!backgroundMode) {
        ProgressHUD.show();
      }

      final request = http.MultipartRequest('PUT', Uri.parse('${AppEnv.getServerUrl()}$endPoint'));
      request.headers.addAll(header);

      if (params != null) {
        request.fields.addAll(params);
      }

      if (files != null && files.isNotEmpty) {
        debugPrint('putMultipart: Bắt đầu gửi ${files.length} file đính kèm...');
        for (final file in files) {
          final length = await file.length();
          debugPrint('putMultipart: Gửi file ${file.path.split('/').last} (kích thước: ${(length / 1024 / 1024).toStringAsFixed(2)} MB)');
          final fileData = await http.MultipartFile.fromPath('files_', file.path,
                  contentType: parser.MediaType('application', 'octet-stream'))
              .timeout(const Duration(seconds: _timeOut));
          request.files.add(fileData);
        }
      } else {
        request.fields['files_'] = '';
      }

      debugPrint('API request: ${AppEnv.getServerUrl()}$endPoint');
      debugPrint('API log: PUT ${AppEnv.getServerUrl()}$endPoint');
      debugPrint('API log query: $params');

      final requestResponse = await request.send();
      debugPrint('API log code: ${requestResponse.statusCode}');
      
      final responseString = await requestResponse.stream.bytesToString();
      debugPrint('API log Response: $responseString');

      if (!backgroundMode) {
        ProgressHUD.dismiss();
      }

      if (responseString.toString().startsWith('<html>')) {
        return JSON(errorResponse(responseString.toString(), commonCode));
      }
      final jsonResponse = JSON.parse(responseString);
      return jsonResponse;
    } catch (e) {
      return _handleException(e, backgroundMode);
    }
  }

  Future<JSON> uploadFile(File file, {bool backgroundMode = false}) async {
    final token = AppShared.instance.getUserToken();
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.acceptEncodingHeader: 'accept: application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.connectionHeader: 'keep-alive'
    };
    try {
      if (!backgroundMode) {
        ProgressHUD.show();
      }
      final request = http.MultipartRequest(
          'POST', Uri.parse('${AppEnv.getServerUrl()}/common/upload'));
      request.headers.addAll(headers);
      debugPrint('API request: ${AppEnv.getServerUrl()}/common/upload');
      parser.MediaType mediaType;
      final ext = file.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg'].contains(ext)) {
        mediaType = parser.MediaType('image', 'jpeg');
      } else if (ext == 'png') {
        mediaType = parser.MediaType('image', 'png');
      } else if (ext == 'pdf') {
        mediaType = parser.MediaType('application', 'pdf');
      } else if (ext == 'doc' || ext == 'docx') {
        mediaType = parser.MediaType('application', 'msword');
      } else if (ext == 'xls' || ext == 'xlsx') {
        mediaType = parser.MediaType('application', 'vnd.ms-excel');
      } else {
        mediaType = parser.MediaType('application', 'octet-stream');
      }
      final fileDAta = await http.MultipartFile.fromPath('file', file.path,
              contentType: mediaType)
          .timeout(const Duration(seconds: _timeOut));
      request.files.add(fileDAta);
      final requestResponse = await request.send();
      final responseString = await requestResponse.stream.bytesToString();
      debugPrint('API log code: ${requestResponse.statusCode}');
      debugPrint('API log Response: $responseString');
      final jsonResponse = JSON.parse(responseString);
      if (!backgroundMode) {
        ProgressHUD.dismiss();
      }
      return jsonResponse;
    } catch (e) {
      debugPrint('API upload error: $e');
      return _handleException(e, backgroundMode);
    }
  }

  Future<JSON> uploadFiles(List<File> files,
      {bool backgroundMode = false}) async {
    final token = AppShared.instance.getUserToken();
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.acceptEncodingHeader: 'accept: application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.connectionHeader: 'keep-alive'
    };
    try {
      if (!backgroundMode) {
        ProgressHUD.show();
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('${AppEnv.getServerUrl()}/common/uploads'));
      if (AppShared.instance.getAppType() == AppType.HTDCT) {
        request = http.MultipartRequest(
            'POST', Uri.parse('${AppEnv.getServerUrl()}/common/upload'));
      }
      request.headers.addAll(headers);
      for (final file in files) {
        parser.MediaType mediaType;
        final ext = file.path.split('.').last.toLowerCase();
        if (['jpg', 'jpeg'].contains(ext)) {
          mediaType = parser.MediaType('image', 'jpeg');
        } else if (ext == 'png') {
          mediaType = parser.MediaType('image', 'png');
        } else if (ext == 'pdf') {
          mediaType = parser.MediaType('application', 'pdf');
        } else if (ext == 'doc' || ext == 'docx') {
          mediaType = parser.MediaType('application', 'msword');
        } else if (ext == 'xls' || ext == 'xlsx') {
          mediaType = parser.MediaType('application', 'vnd.ms-excel');
        } else {
          mediaType = parser.MediaType('application', 'octet-stream');
        }
        final fileDAta = await http.MultipartFile.fromPath('files', file.path,
                contentType: mediaType)
            .timeout(const Duration(seconds: _timeOut));
        request.files.add(fileDAta);
      }
      final requestResponse = await request.send();
      final responseString = await requestResponse.stream.bytesToString();
      debugPrint('API log: ${requestResponse.request}');
      debugPrint('API log code: ${requestResponse.statusCode}');
      debugPrint('API log res: ${responseString.toString()}');
      if (!backgroundMode) {
        ProgressHUD.dismiss();
      }
      if (responseString.toString().startsWith('<html>')) {
        return JSON(errorResponse(responseString.toString(), commonCode));
      }
      final jsonResponse = JSON.parse(responseString);
      return jsonResponse;
    } catch (e) {
      return _handleException(e, backgroundMode);
    }
  }

  dynamic _response(http.Response response, {bool isBackgroundMode = false}) {
    JSON jsonData;
    if (!isBackgroundMode) {
        ProgressHUD.dismiss();
    }

    switch (response.statusCode) {
      case 403:
        if (!isBackgroundMode) {
          handle403();
        }
        return JSON(errorResponse('Bạn không có quyền sử dụng chức năng này.', 403));
      case 401:
        handle401();
        return JSON(errorResponse('Phiên đăng nhập đã hết hạn.', 401));
      case 500:
        debugPrint('API log 500 Response Body: ${response.body}');
        return JSON(errorResponse(
            'Lỗi hệ thống. Vui lòng liên hệ Quản trị viên để được hỗ trợ!${AppEnv.isDev() ? '\nStatus code: 500' : ''}',
            500));
        break;
    }

    if (response.body == null) {
      return JSON(errorResponse(
          'Yêu cầu không hợp lệ! Vui lòng liên hệ Quản trị viên để được hỗ trợ!${AppEnv.isDev() ? '\nStatus code: ${response.statusCode}' : ''}',
          response.statusCode));
    }

    try {
      jsonData = JSON.parse(response.body);
      if (jsonData.value == null && response.body != null && response.body.trim().isNotEmpty && response.body.trim() != 'null') {
        jsonData = JSON({'statusCode': response.statusCode, 'message': response.body});
      }
      debugPrint('API log Response: ${jsonData.rawString()}');
      if (jsonData.value == null && response.statusCode == 200) {
        jsonData = JSON({'statusCode': 200, 'message': 'Thành công'});
      }
    } catch (error) {
      debugPrint('API log Response: ${response.body.toString()}');
      debugPrint('API log error: ${error.toString()}');

      if (response.statusCode == 200 && response.body.toString().trim().isEmpty) {
        return JSON({'statusCode': 200, 'message': 'Thành công'});
      }

      if (response.body.toString().startsWith('<html>') ||
          response.body.toString().startsWith('<!doctype html5>')) {
        return JSON(errorResponse(response.body.toString(), 999));
      }

      return JSON(errorResponse(
          'Yêu cầu không hợp lệ! Vui lòng liên hệ Quản trị viên để được hỗ trợ!${AppEnv.isDev() ? '\nStatus code: 999' : ''}',
          999));
    }

    switch (response.statusCode) {
      case 200:
        return jsonData;
      case 400:
        return jsonData;
      default:
        return JSON(errorResponse(
            'Yêu cầu không hợp lệ! Vui lòng liên hệ Quản trị viên để được hỗ trợ!${AppEnv.isDev() ? '\nStatus code: ${response.statusCode}' : ''}',
            response.statusCode));
    }
  }

  Future handle401() async {
    await showDialogError('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!',
        action: () async {
      await AppShared.instance.persistentUserToken('');
      await Get.offAllNamed(Routes.selectModule);
    });
  }

  Future handle403() async {
    await showDialogError('Bạn không có quyền sử dụng chức năng này!',
        action: () {
      Get.back();
    });
  }
}

