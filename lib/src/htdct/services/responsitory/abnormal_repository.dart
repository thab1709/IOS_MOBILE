// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:flutter/material.dart';
import '../responseModel/abnormal_response/abnormal_response.dart';
import '../server_response.dart';

class AbnormalRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<StringOptionsResponse>> getAbnormalOptions(
      {bool isBackground = true,
      String substationInspectId,
      String lineInspectId,
      int equipmentCategory,
      int workType}) async {
    final param = <String, dynamic>{
      'equipmentCategory':
          equipmentCategory == null ? '' : equipmentCategory.toString(),
      'workType': workType == null ? '' : workType.toString(),
    };
    try {
      final data = await _provider.get('/abnormal/parent',
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
      {bool isBackground = false,
      String name,
      String substationInspectId,
      String lineInspectId,
      int equipmentCategory,
      int workType}) async {
    try {
      final params = <String, dynamic>{
        'name': name,
        'equipmentCategory':
            equipmentCategory == null ? '' : equipmentCategory.toString(),
        'workType': workType == null ? '' : workType.toString(),
      };
      final data = await _provider.post('/abnormal', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<AbnormalResponse>> getAbnormalList(
      {String searchTerm,
      num pageIndex = 1,
      String orderBy = 'ASC',
      String orderByDesc,
      String fromDate,
      String toDate,
      num pageOffset,
      num pageSize = 10,
      bool isBackground = false,
      String id,
      int X6InspectType,
      String equipmentIds,
      String workStatus,
      bool isViolate = false,
      String nodeIds,
      String equipmentCategories}) async {
    final param = {
      'Id': id,
      'X6InspectType': '${X6InspectType ?? '1'}',
      'EquipmentIds': equipmentIds ?? '',
      'Status': workStatus == null ||
              workStatus.split(',').length > 1 ||
              workStatus.contains('3')
          ? ''
          : workStatus,
      'FromDate': fromDate,
      'ToDate': toDate,
      'SearchTerm': searchTerm ?? '',
      'PageSize': pageSize.toString(),
      'PageIndex': pageIndex.toString(),
      'OrderBy': orderBy,
      'OrderByDesc': orderByDesc,
      'PageOffset': pageOffset?.toString(),
      'IsViolate': isViolate.toString(),
      'NodeIds': nodeIds ?? '',
      'EquipmentCategories': equipmentCategories ?? ''
    };
    try {
      final data = await _provider.get('/abnormal',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<AbnormalResponse>.fromJson(data);
      final works = AbnormalResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<AbnormalDetailResponse>> getAbnormalDetail({
    String id,
    bool isBackground = false,
  }) async {
    final param = <String, dynamic>{
      'Id': id,
    };
    try {
      final data = await _provider.get('/abnormal/$id',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<AbnormalDetailResponse>.fromJson(data);
      final works = AbnormalDetailResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<AbnormalHistoryResponse>> getAbnormalHistory({
    String id,
    bool isBackground = false,
  }) async {
    final param = {
      'Id': id,
    };
    try {
      final data = await _provider.get('/abnormal/$id/history',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<AbnormalHistoryResponse>.fromJson(data);
      final works = AbnormalHistoryResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> updateAbnormal(
      {@required Map<String, dynamic> params,
      bool isBackground = false}) async {
    try {
      final data = await _provider.put('/abnormal/${params['id']}', params,
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

  Future<ServerResponse> updateViolate(
      {@required Map<String, dynamic> params,
        bool isBackground = false}) async {
    try {
      final data = await _provider.put('/abnormal/${params['id']}/updateviolate', params,
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
}

