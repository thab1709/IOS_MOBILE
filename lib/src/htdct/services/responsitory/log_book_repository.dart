// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import '../responseModel/log_book_response/check_operation_response.dart';

class LogBookRepository {
  final _provider = ApiProvider();

  Future<ServerResponse> createCheckOperationNote(
      {@required Map<String, dynamic> params,
      bool isBackground = false}) async {
    try {
      final data = await _provider.post(
          '/checkoperationnote/createcheckoperationnote', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      final dataRes = data['data'].stringValue;
      response.setData(dataRes);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
  Future<ServerResponse> createCheckNote(
      {@required Map<String, dynamic> params,
      bool isBackground = false}) async {
    try {
      final data = await _provider.post(
          '/checknote/createchecknote', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      final dataRes = data['data'].stringValue;
      response.setData(dataRes);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> updateCheckOperationNote(
      {@required Map<String, dynamic> params,
      bool isBackground = false}) async {
    try {
      final data = await _provider.post(
          '/checkoperationnote/updatecheckoperationnote', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      final dataRes = data['data'].stringValue;
      response.setData(dataRes);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
  Future<ServerResponse> updateCheckNote(
      {@required Map<String, dynamic> params,
      bool isBackground = false}) async {
    try {
      final data = await _provider.post(
          '/checknote/updatechecknote', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      final dataRes = data['data'].stringValue;
      response.setData(dataRes);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> deleteCheckOperation({String id}) async {
    try {
      final data = await _provider.delete('/checkoperationnote/$id',
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
  Future<ServerResponse<String>> deleteCheckNote({String id}) async {
    try {
      final data = await _provider.delete('/checknote/$id',
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<dynamic>> getOperationCheckList(
      {String eventTypes,
      String userGroups,
      String substations,
      String lines,
      String fromDate,
      String toDate,
      String searchTerm,
      String beginDate,
      String endDate,
      String createdUserId,
      bool isBackground = false,
      TicketType ticketType = TicketType.operationLog}) async {
    final param = ticketType == TicketType.operationLog
        ? {
            'EventTypes': eventTypes ?? '',
            'UserGroups': userGroups ?? '',
            'Substations': substations ?? '',
            'Lines': lines ?? '',
            'SearchTerm': searchTerm ?? '',
            'FromDate': fromDate,
            'ToDate': toDate,
            'BeginDate': beginDate,
            'EndDate': endDate,
            'CreatedUserId': createdUserId
          }
        : {
            'EventTypes': eventTypes ?? '',
            'UserGroups': userGroups ?? '',
            'Substations': substations ?? '',
            'Lines': lines ?? '',
            'SearchTerm': searchTerm ?? '',
            'FromDate': fromDate,
            'ToDate': toDate,
          };
    try {
      if (ticketType == TicketType.operationLog) {
        final data = await _provider.get(
            '/checkoperationnote/listcheckoperationnote',
            params: param,
            isRequireAuth: true,
            backgroundMode: isBackground);
        final response = ServerResponse<CheckOperationResponse>.fromJson(data);
        final works = CheckOperationResponse.fromJson(data);
        response.setData(works);
        return response;
      } else {
        final data = await _provider.get(
            '/checknote/listchecknote',
            params: param,
            isRequireAuth: true,
            backgroundMode: isBackground);

        final response = ServerResponse<GroupCheckNoteResponse>.fromJson(data);
        final works = GroupCheckNoteResponse.fromJson(data);
        response.setData(works);
        return response;
      }
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<CheckOperationModelResponse>> getOperation({
    String id,
    bool isBackground = false,
  }) async {
    try {
      final data = await _provider.get('/checkoperationnote/$id',
          isRequireAuth: true, backgroundMode: isBackground);

      final response =
          ServerResponse<CheckOperationModelResponse>.fromJson(data);
      final works = CheckOperationModelResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
  Future<ServerResponse<CheckCheckNoteModelResponse>> getCheckNote({
    String id,
    bool isBackground = false,
  }) async {
    try {
      final data = await _provider.get('/checknote/$id',
          isRequireAuth: true, backgroundMode: isBackground);

      final response =
          ServerResponse<CheckCheckNoteModelResponse>.fromJson(data);
      final works = CheckCheckNoteModelResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TotalCheckResponse>> getTotalCheckNote() async {
    try {
      final data = await _provider.get('/report/totalchecknote',
          isRequireAuth: true, backgroundMode: true);

      final response = ServerResponse<TotalCheckResponse>.fromJson(data);
      final works = TotalCheckResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

