// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htdct/models/line/line_node_model.dart';
import 'package:evnmobile/src/htdct/services/responseModel/line_response/line_equiqment_response.dart';
import 'package:evnmobile/src/htdct/services/responseModel/line_response/line_general_info_response.dart';
import 'package:evnmobile/src/htdct/services/responseModel/line_response/line_node_response.dart';
import 'package:evnmobile/src/htdct/services/responseModel/line_response/line_same_response.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app_common/utils/utils.dart';
import '../../common/utils/common.dart';
import '../../models/line/line_equipment_model.dart';
import '../responseModel/abnormal_response/abnormal_response.dart';
import '../responseModel/line_response/line_content_night_response.dart';
import '../responseModel/line_response/line_violate_inspection_response.dart';
import '../responseModel/work_response.dart';

class LineRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<LineNodesResponse>> getLineInspect(
      {String idLine,
      String idTicket,
      bool isUpdate = false,
      bool isBackground = false,
      bool isUnderSystem = false}) async {
    try {
      final params = {
        'Id': idLine,
        if (isUpdate) 'LineInspectId': idTicket,
        'IsUnderSystem': isUnderSystem.toString()
      };
      final data = await _provider.get('/lineinspect/listnodeinspect',
          isRequireAuth: true, params: params, backgroundMode: isBackground);
      final response = ServerResponse<LineNodesResponse>.fromJson(data);
      final lineInspectList = LineNodesResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineNodesResponse>> deleteNode(
      {String idTicket, String idNode}) async {
    try {
      final params = {'nodeId': idNode};
      final data = await _provider.delete('/lineinspect/$idTicket/node',
          isRequireAuth: true, params: params);
      final response = ServerResponse<LineNodesResponse>.fromJson(data);
      final lineInspectList = LineNodesResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> addNode(
      {@required Map<String, dynamic> params,
      bool isBackground = false}) async {
    try {
      final data = await _provider.post('/lineinspect/addnode', params,
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

  Future<ServerResponse<LineEquipmentResponse>> getLineEquipment({
    String workId,
    List<String> listNodes,
    bool isBackground = false,
  }) async {
    try {
      Future<ServerResponse<LineEquipmentResponse>> fetch(int pageIndex,
          {bool isBackgroundMode}) async {
        ProgressHUD.show();
        final params = {
          'workId': workId,
          'listNodes': listNodes,
          'pageIndex': pageIndex.toString(),
          'pageSize': '50'
        };
        final data = await _provider.post(
            '/lineinspect/listequipmentbynodes', params,
            isRequireAuth: true, backgroundMode: isBackgroundMode);
        final response = ServerResponse<LineEquipmentResponse>.fromJson(data);
        response.setData(LineEquipmentResponse.fromJson(data));
        return response;
      }

      final listResponse = <LineEquipmentModel>[];
      final result = await fetch(1, isBackgroundMode: true);
      if (result.isLoadSuccess == true) {
        listResponse.addAll(result.data.list);
        final listPage = <int>[];
        if (result.data.paging.totalPages > 1) {
          for (var i = 2; i <= result.data.paging.totalPages; i++) {
            listPage.add(i);
          }

          await Future.forEach<int>(listPage, (element) async {
            final result = await fetch(element, isBackgroundMode: true);
            if (result.isLoadSuccess == true) {
              listResponse.addAll(result.data.list);
            }
          });
        }
      } else {
        ProgressHUD.dismiss();
        return result;
      }

      final response = ServerResponse<LineEquipmentResponse>(statusCode: 200);
      response.setData(LineEquipmentResponse()..list = listResponse);
      ProgressHUD.dismiss();
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> updateNodeLine(
      {String idTicket,
      List<LineNodeModel> listNodes,
      List<Map<String, String>> listEquipment,
      bool isBackground = false}) async {
    try {
      final location = await getCurrentPosition();
      final address = await getNameByLocation(location?.latitude, location?.longitude);
      final params = {
        'id': idTicket,
        'nodes': listNodes,
        'lineInspectEquipments': listEquipment,
        'address': address
      };
      final data = await _provider.put('/lineinspect/$idTicket/update', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      final idTicketRes = data['data'].stringValue;
      response.setData(idTicketRes);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> createLineTicket(
      {
        @required Position location,
        String inspectionType,
      String workId,
      List<String> listNodes,
      List<Map<String, String>> listEquipment,

      bool isBackground = true}) async {
    try {
      final address = await getNameByLocation(location?.latitude, location?.longitude);

      final param = <String, dynamic>{
        'inspectionType': inspectionType,
        'nodes': listNodes,
        'lineInspectEquipments': listEquipment,
        'workId': workId,
        'longitude': location?.longitude,
        'latitude': location?.latitude,
        'address': address,
      };
      final data = await _provider.post('/lineinspect', param,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      final idTicket = data['data'].stringValue;
      response.setData(idTicket);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineGeneralInfoResponse>> getGeneralInfo(
      {String idTicket, bool isBackground = false}) async {
    try {
      final data = await _provider.get('/lineinspect/$idTicket',
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<LineGeneralInfoResponse>.fromJson(data);
      final info = LineGeneralInfoResponse.fromJson(data);
      response.setData(info);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> updateViolateTicket({
    @required Map<String, dynamic> params,
    String idTicket,
  }) async {
    try {
      final data = await _provider.put(
          '/lineinspect/$idTicket/updateviolate', params,
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

  Future<ServerResponse> createViolateTicket(
      {@required Map<String, dynamic> params, String idTicket}) async {
    try {
      final data = await _provider.post('/lineinspect/violate', params,
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

  Future<ServerResponse<LineViolateInspectionResponse>> getListViolateInspect({
    int typeViolation,
    String idTicket,
    String searchTerm,
    String trackingStatus,
    String fromDate,
    String toDate,
    num pageIndex = 1,
    bool isFilter = false,
  }) async {
    try {
      final params = isFilter
          ? {
              'Id': idTicket,
              'TypeViolation': typeViolation.toString(),
              'FromDate': fromDate,
              'ToDate': toDate,
              'PageIndex': pageIndex.toString(),
              'SearchTerm': searchTerm ?? '',
            }
          : {
              'Id': idTicket,
              'TypeViolation': typeViolation.toString(),
              'PageIndex': pageIndex.toString(),
              'SearchTerm': searchTerm ?? '',
            };

      final data = await _provider.get('/lineinspect/listviolate',
          isRequireAuth: true, params: params);
      final response =
          ServerResponse<LineViolateInspectionResponse>.fromJson(data);

      final lineInspectList = LineViolateInspectionResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ViolateInspectionResponse>> getViolateInspectDetail(
      {String id,
      bool isBackground = false
      }) async {
    try {
      final data = await _provider.get('/lineinspect/$id/violatedetail',
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<ViolateInspectionResponse>.fromJson(data);
      final lineInspectList = ViolateInspectionResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> deleteViolateInspection({String id}) async {
    try {
      final data = await _provider.delete('/lineinspect/$id/deleteviolate',
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineContentNightResponse>> getContentNightTimeDetail(
      {String id}) async {
    try {
      final data = await _provider.get('/lineinspect/$id/content/night-time',
          isRequireAuth: true);
      final response = ServerResponse<LineContentNightResponse>.fromJson(data);
      final lineInspectList = LineContentNightResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> updateContentNightTimeDetail({
    @required Map<String, dynamic> params,
    String idTicket,
  }) async {
    try {
      final data = await _provider.put(
          '/lineinspect/$idTicket/content/night-time', params,
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

  Future<ServerResponse<LineSameResponse>> getSameLine(
      {Map<String, dynamic> params}) async {
    try {
      final data = await _provider.post(
          '/lineinspect/equipment/copysameline', params,
          isRequireAuth: true, backgroundMode: false);

      final response = ServerResponse<LineSameResponse>.fromJson(data);
      final lineInspectList = LineSameResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<WorkCurrentUserResponse>> getInspectByLine(
      {String lineId, bool isBackground = false}) async {
    try {
      final data = await _provider.get('/lineinspect/inspect-by-line/$lineId',
          params: {'lineId': lineId ?? ''},
          isRequireAuth: true,
          backgroundMode: isBackground);
      final response = ServerResponse<WorkCurrentUserResponse>.fromJson(data);
      final lineInspectList = WorkCurrentUserResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<WorkCurrentUserResponse>> getAllLine(
      {String lineId, bool isBackground = false}) async {
    try {
      final data = await _provider.get('/line/get-all',
          isRequireAuth: true,
          backgroundMode: isBackground);
      final response = ServerResponse<WorkCurrentUserResponse>.fromJson(data);
      final lineInspectList = WorkCurrentUserResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<StringOptionsResponse>> getAbnormalOptions(
      {bool isBackground = true, int typeViolation}) async {
    final param = <String, dynamic>{
      'typeViolation': typeViolation == null ? '' : typeViolation.toString(),
    };
    try {
      final data = await _provider.get('/lineinspect/violate',
          params: param, isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<StringOptionsResponse>.fromJson(data);
      final option = StringOptionsResponse.fromJson(data);
      response.setData(option);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> addAbnormalOption(
      {bool isBackground = false, String name, int typeViolation}) async {
    try {
      final params = <String, dynamic>{
        'name': name,
        'typeViolation': typeViolation == null ? '' : typeViolation.toString(),
      };
      final data = await _provider.post('/lineinspect/new-violate', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

