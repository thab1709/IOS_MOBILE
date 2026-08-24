// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/services/responseModel/equipment_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/line_note_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/line_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/substation_response.dart';
import 'package:flutter/material.dart';

import '../server_response.dart';

class SubstationRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<SubstationResponse>> getListSubstation(
      {@required String searchTerm,@required String inspectType, bool requireAuth = true,}) async {
    try {
      final data = await _provider.get('/substation', isRequireAuth: requireAuth, params: {
        'searchTerm' : searchTerm,
        'inspectType' : inspectType,
        'pageSize' : '9999',
        'pageIndex' : '1',
        'orderBy' : 'ASC',
        'OrderByDesc' : 'ASC',
        'pageOffset' : '1',
      });
      final response = ServerResponse<SubstationResponse>.fromJson(data);
      response.setData(SubstationResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

 Future<ServerResponse<LineResponse>> getListLine(
      {String searchTerm,
        String parentId,
        bool requireAuth = true,}) async {
    try {
      final data = await _provider.get('/line', isRequireAuth: requireAuth, params: {
        'ParentId': parentId,
        'SearchTerm' : searchTerm,
        'pageSize' : '9999',
        'pageIndex' : '1',
        'orderBy' : 'ASC',
        'OrderByDesc' : 'ASC',
        'pageOffset' : '1',
      });
      final response = ServerResponse<LineResponse>.fromJson(data);
      response.setData(LineResponse.fromJson(data));

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineModel>> getLine({String parentId, String inspectId, bool isBackgroundMode = false}) async {
    final param = {
      'lineIspectId': inspectId
    };
    try {
      final data = await _provider.get('/line/$parentId', params: param,isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<LineModel>.fromJson(data);
      response.setData(LineModel.fromJson(data['data']));

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineNodesResponse>> getLineNodes(
      String lineId, int pageIndex, {bool isBackgroundMode = false}) async {
    final param = {
      'pageSize': '50',
      'pageIndex': pageIndex?.toString() ?? '',
      'orderBy': 'ASC',
      'OrderByDesc': 'ASC',
      'pageOffset': '1',
    };

    try {
      final data = await _provider.get('/lineinspect/$lineId/nodes',
          params: param, isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<LineNodesResponse>.fromJson(data)
        ..setData(LineNodesResponse.fromJson(data));

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<EquipmentResponse>> getAllEquipmentInLine(
      String lineId, int pageIndex, {bool isBackgroundMode = false}) async {
    final param = {
      'id': lineId,
      'pageSize': '100',
      'pageIndex': pageIndex?.toString() ?? '',
      'orderBy': 'ASC',
      'OrderByDesc': 'ASC',
      'pageOffset': '1',
    };

    try {
      final data = await _provider.get(
          '/lineinspect/equipment-all',
          params: param,
          isRequireAuth: true,
      backgroundMode: isBackgroundMode);
      final response = ServerResponse<EquipmentResponse>.fromJson(data)
        ..setData(EquipmentResponse.fromJson(data));

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<EquipmentResponse>> getEquipmentLine({List<String> substationIds , int page = 1, int pageSize = 9999, bool isBackgroundMode = false}) async {
    try {
      final params = {
        'SubstationId': substationIds,
        'pageSize' : pageSize.toString(),
        'pageIndex' : page.toString(),
        'orderBy' : 'ASC',
        'OrderByDesc' : 'ASC',
        'pageOffset' : '1',
      };

      final data = await _provider
          .post('/lineinspect/equipment', params, isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<EquipmentResponse>.fromJson(data);
      response.setData(EquipmentResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
  Future<ServerResponse<EquipmentResponse>> getListEquipment({
    @required String substationId,
    @required String inspectType,
    String searchTerm,
    String ticketId,
    bool requireAuth = true,
    bool isBackground = false
  }) async {
    try {
      final data = await _provider
          .get('/equipment', isRequireAuth: requireAuth, params: {
        'SubstationId': substationId,
        'InspectType': inspectType,
        'EntityId': ticketId,
        'searchTerm': searchTerm,
         'pageSize': '9999',
        'pageIndex': '1',
        'orderBy': 'ASC',
        'OrderByDesc': 'ASC',
        'pageOffset': '1',
      },
      backgroundMode: isBackground
      );
      final response = ServerResponse<EquipmentResponse>.fromJson(data);
      response.setData(EquipmentResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

