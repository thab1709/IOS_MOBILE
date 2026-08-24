// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

import '../../../app_common/networking/api_provider.dart';
import '../../../htdct/services/server_response.dart';
import '../../common/constance/strings.dart';
import '../../common/utils/constance.dart';
import '../../models/department_model.dart';
import '../../models/meter/meter_update.dart';
import '../../models/option_model.dart';
import '../../models/report_meter_model.dart';
import '../../models/sub_report_meter_model.dart';
import '../../models/teams_model.dart';
import '../../models/unit.dart';
import '../responseModel/report_meter_response.dart';

class BBCongToRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<List<ThietBiKiemModel>>>
      getEquipmentInspection() async {
    final data = await _provider.get('/mergeformreport/equipment-inspection',
        backgroundMode: true, isRequireAuth: true);
    final response = ServerResponse<List<ThietBiKiemModel>>.fromJson(data);
    response.setData(data['data']
            .list
            ?.map((e) => ThietBiKiemModel.fromJson(JSON(e)))
            ?.toList() ??
        []);
    return response;
  }

  Future<ServerResponse<ThietBiKiemModel>> createEquipmentInspection(
      String name, String code, String ccx) async {
    final params = <String, String>{
      'name': name,
      'code': code,
      'ccx': ccx,
    };
    final data = await _provider.post(
        '/mergeformreport/add-equipment-inspect', params,
        isRequireAuth: true);
    final response = ServerResponse<ThietBiKiemModel>.fromJson(data);
    response.setData(ThietBiKiemModel.fromJson(JSON(data['data'])));
    return response;
  }

  Future<ServerResponse<MeterDetail>> getMeterDetail(String id) async {
    final data =
        await _provider.get('/mergeformreport/meter/$id', isRequireAuth: true);
    final response = ServerResponse<MeterDetail>.fromJson(data);
    response.setData(MeterDetail.fromJson(JSON(data['data'])));
    return response;
  }

  Future<ServerResponse<MeterDetail>> updateMeterDetail(
      MeterDetail meterDetail) async {
    final data = await _provider.put(
        '/mergeformreport/meter', meterDetail.toJson(),
        isRequireAuth: true);
    final response = ServerResponse<MeterDetail>.fromJson(data);
    response.setData(MeterDetail.fromJson(JSON(data['data'])));
    return response;
  }

  Future<ServerResponse<StringOptionModel>> addMeterMeasuringComment(
      String type, String name) async {
    final params = <String, String>{
      'name': name,
      'type': type,
    };
    final data = await _provider.post(
        '/mergeformreport/add-meter-measuring-comment', params,
        backgroundMode: true, isRequireAuth: true);
    final response = ServerResponse<StringOptionModel>.fromJson(data);
    return response;
  }

  Future<ServerResponse<List<StringOptionModel>>> getMeterMeasuringComment(
      String type) async {
    final params = <String, String>{
      'type': type,
    };
    final data = await _provider.get('/mergeformreport/meter-measuring-comment',
        params: params, backgroundMode: true, isRequireAuth: true);
    final response = ServerResponse<List<StringOptionModel>>.fromJson(data);
    response.setData(data['data']
            ?.list
            ?.map((e) => StringOptionModel(e['name'].string, e['id'].string))
            ?.toList() ??
        []);
    return response;
  }

  Future<ServerResponse<String>> getPdf(
      {String formReportId}) async {
    final param = <String, dynamic>{
      'id': formReportId,
    };
    try {
      final data =
          await _provider.post('/common/get-pdf-meter', param, isRequireAuth: true);
      return ServerResponse<String>.fromJson(data)
        ..setData(data['data'].string);
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<ServerResponse<List<SubReportMeterModel>>> getDetailMergeWork(
      String workId) async {
    try {
      final data = await _provider
          .get('/mergeformreport/detail-meter/$workId', isRequireAuth: true);
      final response = ServerResponse<List<SubReportMeterModel>>.fromJson(data);
      final report = data['data']
          ?.list
          ?.map((e) => SubReportMeterModel.fromJson(JSON(e)))
          ?.toList();
      response.setData(report);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> deleteMeter(String workId) async {
    try {
      final data = await _provider
          .delete('/mergeformreport/delete-meter/$workId', isRequireAuth: true);
      final response = ServerResponse.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<DepartmentModel>>> getDepartment() async {
    final param = {'pageSize': '99'};
    try {
      final data = await _provider.get('/department',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<DepartmentModel>>.fromJson(data);
      final department = <DepartmentModel>[];
      final listData = data['data']?.value != null ? data['data']
          ?.list
          ?.map((e) => DepartmentModel.fromJson(JSON(e)))
          ?.toList() : <DepartmentModel>[];
      department.addAll(listData);
      response.setData(department);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<TeamsModel>>> getTeams(
      {String departmentId}) async {
    final param = {'DepartmentId': departmentId};
    try {
      final data = await _provider.get('/team/teams',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<TeamsModel>>.fromJson(data);
      final teamList = <TeamsModel>[];
      final listData = data['data']
          ?.list
          ?.map((e) => TeamsModel.fromJson(JSON(e)))
          ?.toList();
      teamList.addAll(listData);
      response.setData(teamList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ReportMeterResponse>> getReports({
    String id,
    String unitId,
    String workingStatus,
    String searchTerm,
    num pageIndex = 1,
    String orderBy,
    String orderByDesc,
    String fromDate,
    String toDate,
    num pageOffset,
    bool isNotShowLoading = false,
  }) async {
    final param = {
      'Id': id,
      'UnitId': unitId == '0' ? null : unitId,
      'WorkingStatus': workingStatus == '0' ? null : workingStatus,
      'SearchTerm': searchTerm,
      'FromDate': fromDate,
      'ToDate': toDate,
      'orderBy': orderBy ?? 'descend',
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'pageSize': rAppPageSize.toString(),
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get('/mergeformreport/meter-inspections',
          params: param, isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<ReportMeterResponse>.fromJson(data);
      final report = ReportMeterResponse.fromJson(data);
      response.setData(report);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> approvalOperationTeam({
    String formReportId,
    bool isApproval,
    String content,
  }) async {
    final params = {'id': formReportId, 'note': content ?? ''};
    String endpoint;
    if (isApproval) {
      endpoint = 'operation-accept';
    } else {
      endpoint = 'operation-reject';
    }
    final data = await _provider.post('/formreport/$endpoint', params,
        isRequireAuth: true);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> approvalLeader({
    List<String> ids,
    String content,
    bool isApproval,
    bool isBackgroundMode = false,
  }) async {
    final params = {'note': content ?? '', 'ids': ids};
    String endpoint;
    if (isApproval) {
      endpoint = 'leader-accept';
    } else {
      endpoint = 'leader-reject';
    }

    final data = await _provider.post('/formreport/$endpoint', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> sendToTeam({
    String id,
    String approveId,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {'note': content ?? '', 'id': id, 'approveId': approveId};

    final data = await _provider.post('/mergeformreport/send', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> approvalTeam({
    String id,
    String presidentCompanyUserId,
    String presidentCenterUserId,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'note': content ?? '',
      'id': id,
      'presidentCenterUserId': presidentCenterUserId,
      'presidentCompanyUserId': presidentCompanyUserId
    };

    final data = await _provider.post('/mergeformreport/accept', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<List<UnitReport>>> getUnits() async {
    final param = {'pageSize': '99'};
    try {
      final data = await _provider.get('/unit',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UnitReport>>.fromJson(data);
      final responseWorks = <UnitReport>[];
      responseWorks.add(UnitReport(id: '0', name: RAppStrings.all));
      final works = data['data']?.value != null ? data['data']
          ?.list
          ?.map((e) => UnitReport.fromJson(JSON(e)))
          ?.toList() : <UnitReport>[];
      responseWorks.addAll(works);
      response.setData(responseWorks);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> approvalCenter({
    List<String> ids,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'note': content ?? '',
      'ids': ids,
    };

    final data = await _provider.post(
        '/mergeformreport/accept/president-center', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> approvalCompany({
    List<String> ids,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'note': content ?? '',
      'ids': ids,
    };

    final data = await _provider.post(
        '/mergeformreport/accept/president-company', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> reject({
    List<String> ids,
    String content,
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'note': content ?? '',
      'ids': ids,
    };

    final data = await _provider.post('/mergeformreport/reject', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<List<UserModel>>> getListPersidentCenter() async {
    try {
      final data = await _provider.get('/mergeformreport/president-center',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UserModel>>.fromJson(data);
      final listUser = <UserModel>[];
      final listData =
          data['data']?.value != null ? data['data']?.list?.map((e) => UserModel.fromJson(JSON(e)))?.toList() : <UserModel>[];
      listUser.addAll(listData);
      response.setData(listUser);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UserModel>>> getListPresidentCompany(
      {@required String userPosition}) async {
    try {
      final param = {'UserPosition': userPosition, 'pageSize': '99'};
      final data = await _provider.get('/user',
          isRequireAuth: true, params: param, backgroundMode: true);
      final response = ServerResponse<List<UserModel>>.fromJson(data);
      final listUser = <UserModel>[];
      final listData =
          data['data']?.value != null ? data['data']?.list?.map((e) => UserModel.fromJson(JSON(e)))?.toList() : <UserModel>[];
      listUser.addAll(listData);
      response.setData(listUser);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UserModel>>> getSubstation({String userId}) async {
    final param = <String, dynamic>{'userId': userId};
    try {
      final data = await _provider.get('/formreport/substations',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UserModel>>.fromJson(data);
      final listSubstation = <UserModel>[];
      final listData =
          data['data']?.value != null ? data['data']?.list?.map((e) => UserModel.fromJson(JSON(e)))?.toList() : <UserModel>[];
      listSubstation.addAll(listData);
      response.setData(listSubstation);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<UserModel>>> getListUser({String teamId}) async {
    final param = {'teamId': teamId};
    try {
      final data = await _provider.get('/team/list-user',
          params: param, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<UserModel>>.fromJson(data);
      final listUser = <UserModel>[];
      final listData =
          data['data']?.value != null ? data['data']?.list?.map((e) => UserModel.fromJson(JSON(e)))?.toList() : <UserModel>[];
      listUser.addAll(listData);
      response.setData(listUser);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

