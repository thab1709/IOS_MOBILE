// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';
import '../../models/abnormal/abnormal_raw.dart';
import '../../models/option_model.dart';
import '../responseModel/abnormal_response/abnormal_response.dart';
import '../server_response.dart';

class TAbnormalRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<TAbnormalPopupResponse>> getAbnormalOptions(
      {bool isBackground = true,
      int equipmentCategory,
      int entityType,
      int inspectionType,
      }) async {
    final param = <String, dynamic>{
      'Category':
          equipmentCategory == null ? '' : equipmentCategory.toString(),
      'EntityType': entityType == null ? '' : entityType.toString(),
      'InspectionType': inspectionType == null ? '' : inspectionType.toString(),
    };
    try {
      final data = await _provider.get('/dlabnormal/parent',
          params: param, isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<TAbnormalPopupResponse>.fromJson(data);
      final option = TAbnormalPopupResponse.fromJson(data);
      response.setData(option);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<AbnormalRaw>> addAbnormalOption(
      {bool isBackground = false,
      String name,
      int equipmentCategory,
      int entityType,
      int inspectionType,
      }) async {
    try {
      final params = <String, dynamic>{
        'name': name,
        'category':
            equipmentCategory == null ? '' : equipmentCategory.toString(),
        'entityType': entityType == null ? '' : entityType.toString(),
        'inspectionType': inspectionType == null ? '' : inspectionType.toString(),
      };
      final data = await _provider.post('/dlabnormal/parent', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<AbnormalRaw>.fromJson(data);
      final abnormal = AbnormalRaw.fromJson(JSON(data['data']));
      response.data = abnormal;
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TAbnormalResponse>> getAbnormalList(
      {String searchTerm,
      num pageIndex = 1,
      String orderBy = 'ASC',
      String orderByDesc,
      String fromDate,
      String inspectionCategory,
      String toDate,
      String entityType,
      num pageOffset,
      num pageSize = 10,
      bool isBackground = false,
      String id,
      String equipmentIds,
      String workStatus,}) async {
    final param = {
      'Id': id,
      'Status': workStatus == null ||
              workStatus.split(',').length > 1 ||
              workStatus.contains('3')
          ? ''
          : workStatus,
      'FromDate': fromDate,
      'InspectionCategory': inspectionCategory,
      'EquipmentIds': equipmentIds,
      'EntityType': entityType,
      'ToDate': toDate,
      'SearchTerm': searchTerm ?? '',
      'PageSize': pageSize.toString(),
      'PageIndex': pageIndex.toString(),
      'OrderBy': orderBy,
      'OrderByDesc': orderByDesc,
      'PageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/dlabnormal',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<TAbnormalResponse>.fromJson(data);
      final works = TAbnormalResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TAbnormalDetailResponse>> getAbnormalDetail({
    String id,
    bool isBackground = false,
  }) async {
    final param = <String, dynamic>{
      'Id': id,
    };
    try {
      final data = await _provider.get('/dlabnormal/$id',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<TAbnormalDetailResponse>.fromJson(data);
      final works = TAbnormalDetailResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TAbnormalHistoryResponse>> getAbnormalHistory({
    String id,
    bool isBackground = false,
  }) async {
    final param = {
      'Id': id,
    };
    try {
      final data = await _provider.get('/dlabnormal/$id/histories',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<TAbnormalHistoryResponse>.fromJson(data);
      final works = TAbnormalHistoryResponse.fromJson(data);
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
      final data = await _provider.put('/dlabnormal/${params['id']}', params,
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

  Future<ServerResponse<List<OptionModelString>>> getUsersHandle({
    bool isBackground = false,
  }) async {
    try {
      final data = await _provider.get('/dlabnormal/users',
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<List<OptionModelString>>.fromJson(data);
      final list = data['data']
          ?.listObject
          ?.map((e) => OptionModelString(e['name'], e['id']))
          ?.toList();
      response.setData(list);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<OptionModelString>>> getEquipmentCategories({
    int workType,
    bool isBackground = false,
  }) async {
    try {
      final maps = <String, String>{'WorkType': workType.toString()};
      final data = await _provider.get('/dlabnormal/users',
          isRequireAuth: true, backgroundMode: isBackground, params: maps);
      final response = ServerResponse<List<OptionModelString>>.fromJson(data);
      final list = data['data']
          ?.listObject
          ?.map((e) => OptionModelString(e['name'], e['id'],))
          ?.toList();
      response.setData(list);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<OptionModelString>>> getEquipments({
    String id,
    String entityType,
    String equipmentCategory,
    bool isBackground = false,
  }) async {
    try {
      final maps = <String, String>{
        'Id': id,
        'EntityType': entityType,
        'InspectionCategory': equipmentCategory,
      };

      final data = await _provider.get('/dlabnormal/equipments',
          isRequireAuth: true, backgroundMode: isBackground, params: maps);
      final response = ServerResponse<List<OptionModelString>>.fromJson(data);
      final list = data['data']
          ?.listObject
          ?.map((e) => OptionModelString(e['name'], e['id']))
          ?.toList();
      response.setData(list);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

