// @dart=2.9
import 'package:collection/collection.dart';
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';

import '../../models/day_night/ticket.dart';
import '../responseModel/non_pmis_response/template_response.dart';

class NonPmisRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<TemplateResponse>> getContent({
    @required String idTicket,
    @required TestType testType,
    bool isBackground = false,
  }) async {
    try {
      var pathByType = '';
      if (testType == TestType.subStation) {
        pathByType = 'substationinspect';
      }  else if(testType == TestType.line) {
        pathByType = 'lineinspect';
      }
      else
      {
        pathByType = 'nonpmisinspect';
      }

      final data = await _provider.get('/$pathByType/$idTicket/content/nonpmis',
          isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<TemplateResponse>.fromJson(data);
      final teamList = TemplateResponse.fromJson(data['data']);
      response.setData(teamList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<StringOptionsResponse>> getOptions(
      {@required Map<String, dynamic> params,
      bool isBackground = false}) async {
    try {
      final data = await _provider.post('/common/datafordropdown', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<StringOptionsResponse>.fromJson(data);

      final list = StringOptionsResponse.fromJson(data);
      response.setData(list);

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
  Future<ServerResponse<StringMoreOptionsResponse>> getMoreOptions(
      {String searchTerm, String source,int pageIndex, bool isBackground = false, String Ids, String InspectId}) async {
    final param={
      'Source': source??'',
      'SearchTerm':searchTerm??'',
      'PageIndex': '1',
      'OrderByDesc': '',
      'PageSize': '${pageIndex*100}',
      'PageOffset': '',
      'Ids':Ids??'',
      'InspectId':InspectId??''
    };
    try {
      final data = await _provider.get('/common/datafordropdown-paging', params: param,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<StringMoreOptionsResponse>.fromJson(data);

      final list = StringMoreOptionsResponse.fromJson(data);
      response.setData(list);

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> updateContent({
    @required String idTicket,
    @required Map<String, dynamic> params,
    @required TestType testType,
  }) async {
    try {
      var pathByType = '';
      if (testType == TestType.subStation) {
        pathByType = 'substationinspect';
      }  else if(testType == TestType.line) {
        pathByType = 'lineinspect';
      }
      else
      {
        pathByType = 'nonpmisinspect';
      }

      final data = await _provider.put(
          '/$pathByType/$idTicket/content/nonpmis', params,
          isRequireAuth: true);
      final response = ServerResponse.fromJson(data);
      final idTicketRes = data['data'].stringValue;
      response.setData(idTicketRes);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<StringOptionsResponse>> getCreatedUser() async {
    try {
      final data = await _provider.get('/work/get-created-user',
          isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse<StringOptionsResponse>.fromJson(data);

      final list = StringOptionsResponse.fromJson(data);
      response.setData(list);

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
  Future<ServerResponse<StringOptionsResponse>> getScheduleType() async {
    try {
      final data = await _provider.get('/work/get-schedule-type',
          isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse<StringOptionsResponse>.fromJson(data);

      final list = StringOptionsResponse.fromJson(data);
      response.setData(list);

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

