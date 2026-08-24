// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/services/responseModel/popups_model/popup_response.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import '../../../models/day_night/ticket.dart';

class TransformersRepository {
  final _provider = ApiProvider();

  Future<ServerResponse> put(
      {@required String ticketId,
      @required Map<String, dynamic> params,
      @required String endpoint,
      bool backgroundMode = false,
      TestType testType = TestType.subStation}) async {

    var url = '';
    if (testType == TestType.subStation) {
      url = 'substationinspect';
    } else {
      url = 'lineinspect';
    }
    final data = await _provider.put(
        '/$url/$ticketId/content/$endpoint', params,
        backgroundMode: backgroundMode, isRequireAuth: true);
    final response = ServerResponse<PopupResponse>.fromJson(data);
    response.setData(PopupResponse.fromJson(data));
    return response;
  }

  Future<ServerResponse> lineCopy(
      {@required String ticketId,
        @required Map<String, dynamic> params,
        @required String endpoint,
        bool backgroundMode = false,
        TestType testType = TestType.subStation
      }) async {
    var url = '';
    if (testType == TestType.subStation) {
      url = 'substationinspect';
    } else {
      url = 'lineinspect';
    }
    final data = await _provider.put(
        '/$url/$ticketId/content/$endpoint/copy', params,
        backgroundMode: backgroundMode, isRequireAuth: true);
    final response = ServerResponse<PopupResponse>.fromJson(data);
    response.setData(PopupResponse.fromJson(data));
    return response;
  }

  Future<ServerResponse> get(
      {@required String ticketId,
      @required String equipmentId,
      @required String endpoint,
      TestType testType = TestType.subStation}) async {
    var url = '';
    if (testType == TestType.subStation) {
      url = 'substationinspect';
    } else {
      url = 'lineinspect';
    }
    final data = await _provider.get('/$url/$ticketId/content/$endpoint',
        params: {'equipmentId': equipmentId}, isRequireAuth: true);
    final response = ServerResponse<JSON>.fromJson(data);
    response.setData(data);
    return response;
  }

  Future<ServerResponse> getTestInfoGeneral(
      {@required String ticketId}) async {
    final data = await _provider.get('/lineinspect/$ticketId/generaltest', isRequireAuth: true);
    final response = ServerResponse<JSON>.fromJson(data);
    response.setData(data);
    return response;
  }

  Future<ServerResponse> putTestInfoGeneral(
      {@required Map<String, dynamic> params,
        TestType testType = TestType.subStation}) async {
    final data = await _provider.post(
        '/lineinspect/generaltest', params, isRequireAuth: true);
    final response = ServerResponse<PopupResponse>.fromJson(data);
    response.setData(PopupResponse.fromJson(data));
    return response;
  }
}

