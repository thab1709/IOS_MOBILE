// @dart=2.9
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/models/workload/create_workload_request.dart';
import 'package:evnmobile/src/qltnkd/models/workload/detail_workload_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/detail_request/detail_workload.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import '../../../htld/models/unit_model.dart';
import '../../common/constance/strings.dart';
import '../../common/utils/constance.dart';
import '../../models/unit.dart';
import '../../models/workload/confirm_mass_scene_schedules.dart';
import '../../screens/verification_report/workload/common/constance_workload.dart';
import '../responseModel/request_response.dart';
import '../responseModel/workload_requests_response.dart';
import '../server_response.dart';

class WorkloadRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<WorkloadRequestsResponse>> getListWorkload(
      {String unitId,
      String requestType,
      int status,
      String searchTerm,
      num pageIndex = 1,
      String orderBy = 'ASC',
      String orderByDesc,
      String fromDate,
      String toDate,
      num pageOffset,
      bool requireAuth = true,
      bool isBackgroundMode = false}) async {
    try {
      final params = <String, dynamic>{
        'UnitId': unitId == '0' ? '' : unitId,
        'RequestType': requestType == '0' ? '' : requestType,
        'FromDate': fromDate,
        'ToDate': toDate,
        'orderBy': orderBy,
        'SearchTerm': searchTerm,
        'pageIndex': pageIndex.toString(),
        'orderByDesc': orderByDesc,
        'pageSize': rAppPageSize.toString(),
        'pageOffset': pageOffset?.toString(),
      };
      if (status != null && status != 0) {
        params.addAll(<String, dynamic>{'Status': status.toString()});
      }
      debugPrint('==== API GET /confirmmassscene PARAMS: $params ====');
      final data = await _provider.get('/confirmmassscene',
          isRequireAuth: requireAuth,
          backgroundMode: isBackgroundMode,
          params: params);

      final response =
          ServerResponse<WorkloadRequestsResponse>.fromJson(JSON(data));
      final dataResult = WorkloadRequestsResponse.fromJson(JSON(data));
      response.setData(dataResult);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<RequestsResponse>> getListRequest(
      {String unitId,
      String requestType,
      int status,
      String searchTerm,
      String fromDate,
      String toDate,
      num pageIndex = 1,
      String orderBy = 'ASC',
      String orderByDesc,
      num pageOffset,
      bool requireAuth = true,
      bool isBackgroundMode = false}) async {
    try {
      final params = <String, dynamic>{
        'UnitId': unitId == '0' ? '' : unitId,
        'RequestType': requestType == '0' ? '' : requestType,
        'orderBy': orderBy,
        'pageIndex': pageIndex.toString(),
        'orderByDesc': orderByDesc,
        'fromDate': fromDate,
        'toDate': toDate,
        'SearchTerm': searchTerm,
        'pageSize': rAppPageSize.toString(),
        'pageOffset': pageOffset?.toString(),
      };
      if (status != null && status != RequestStatusCode.all) {
        params.addAll(<String, dynamic>{'Status': status.toString()});
      }

      final data = await _provider.get('/confirmmassscene/request',
          isRequireAuth: requireAuth,
          backgroundMode: isBackgroundMode,
          params: params);

      final response = ServerResponse<RequestsResponse>.fromJson(JSON(data));
      final dataResult = RequestsResponse.fromJson(JSON(data));
      response.setData(dataResult);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<ConfirmMassSceneSchedules>>> getListWork(
      String requestId,
      String fromDate,
      String toDate,
      ) async {
    try {
      final params = <String, String>{'RequestId': requestId, 'PageSize': '999', 'FromDate': fromDate, 'ToDate': toDate};
      final data = await _provider.get('/confirmmassscene/works',
          isRequireAuth: true, backgroundMode: false, params: params);

      final response =
          ServerResponse<List<ConfirmMassSceneSchedules>>.fromJson(JSON(data));
      final result = JSON(data['data'])
              ?.list
              ?.map((e) => ConfirmMassSceneSchedules.fromJson(JSON(e)))
              ?.toList() ??
          [];
      response.setData(result);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UnitReport>>> getAllUnits() async {
    final param = {'pageSize': '99'};
    try {
      final data = await _provider.get('/unit',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UnitReport>>.fromJson(data);
      final responseWorks = <UnitReport>[];
      responseWorks.add(UnitReport(id: '0', name: RAppStrings.all));
      final works = data['data']
          ?.list
          ?.map((e) => UnitReport.fromJson(JSON(e)))
          ?.toList();
      responseWorks.addAll(works);
      response.setData(responseWorks);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UnitModel>>> getUserUnits({
    bool requireAuth = true,
  }) async {
    try {
      final param = {'pageSize': '999'};
      final data = await _provider.get('/unit',
          params: param, isRequireAuth: requireAuth, backgroundMode: true);
      final listData = data['data']?.value != null ? data['data'].list : null;
      final units = listData != null ? listData.mapIndexed((e, index) {
        final model = UnitModel.fromJson(e);
        model.indexId = index;
        return model;
      }).toList() : <UnitModel>[];
      final response = ServerResponse<List<UnitModel>>.fromJson(data);
      response.setData(units);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> createRequest(
      WorkloadRequestModel createWorkloadRequest) async {
    try {
      final data = await _provider.post(
          '/confirmmassscene', createWorkloadRequest.toJson(),
          isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse<String>.fromJson(data)
        ..setData(JSON(data['data'])?.string);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<DetailWorkloadModel>> getDetailWorkLoad(
      {String workloadId, String fromDate, String toDate}) async {
    try {
      final param = {'fromDate': fromDate, 'toDate': toDate};
      final data = await _provider.get('/confirmmassscene/$workloadId',
          isRequireAuth: true, backgroundMode: false, params: param);
      final response = ServerResponse<DetailWorkloadModel>.fromJson(data);
      final result = DetailWorkloadModel.fromJson(JSON(data['data']));
      response.setData(result);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> getPdf({String id}) async {
    try {
      final params = <String, dynamic>{'Id': id, '_t': DateTime.now().millisecondsSinceEpoch};
      String url = '/confirmmassscene/pdf';
      if (AppEnv.getAppEnv() == ENV.dev) {
        url = 'http://125.212.226.94:5006/tnkd/api/confirmmassscene/pdf';
      }
      final data = await _provider.get(url,
          params: params, isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data)
        ..setData(JSON(data['data']).string);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> updateWorkload(
      {@required String workloadId,
      @required WorkloadRequestModel workloadRequestModel}) async {
    try {
      final data = await _provider.put(
          '/confirmmassscene/$workloadId', workloadRequestModel.toJsonUpdate(),
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data)
        ..setData(JSON(data['data']).string);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> updateWorkloadSignature(
      {@required String workloadId,
      @required Map<String, dynamic> payload}) async {
    try {
      final data = await _provider.put(
          '/confirmmassscene/$workloadId', payload,
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data)
        ..setData(JSON(data['data']).string);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> sendWorkloadToConfirm(
      {@required String workloadId}) async {
    try {
      final data = await _provider.put('/confirmmassscene/send/$workloadId', {},
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data)
        ..setData(JSON(data['data']).string);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> approveWorkload(
      {@required List<String> ids, String note}) async {
    try {
      final idsString = ids.map((e) => e).join(',');
      final params = <String, dynamic>{
        'ids': idsString,
        'Ids': idsString,
        'note': note ?? '',
        'Note': note ?? '',
      };
      final data = await _provider.put('/confirmmassscene/confirm?ids=$idsString&note=${Uri.encodeComponent(note ?? '')}', params,
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data)
        ..setData(JSON(data['data']).string);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> rejectWorkload(
      {@required List<String> ids, String note}) async {
    try {
      final idsString = ids.map((e) => e).join(',');
      final params = <String, dynamic>{
        'ids': idsString,
        'Ids': idsString,
        'note': note ?? '',
        'Note': note ?? '',
      };
      final data = await _provider.put('/confirmmassscene/reject?ids=$idsString&note=${Uri.encodeComponent(note ?? '')}', params,
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data)
        ..setData(JSON(data['data']).string);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> deleteRequest({String id}) async {
    try {
      final data =
          await _provider.delete('/confirmmassscene/$id', isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data)
        ..setData(JSON(data['data']).string);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

