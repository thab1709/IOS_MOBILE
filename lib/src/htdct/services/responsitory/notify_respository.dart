// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/models/group_model.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';
import '../../models/notify/user_position.dart';
import '../../models/option_model.dart';
import '../../models/team_model.dart';
import '../responseModel/notify_response/notify_response.dart';

class NotifyRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<NotifyResponse>> getNotify(
      {int type,
      String fromDate,
      String toDate,
      String searchTerm,
      num pageSize = 10,
      num pageIndex = 1,
      String orderBy = 'ASC',
      String orderByDesc,
      num pageOffset,
      bool isBackground = false,
      bool getAllReceive = false}) async {
    final param = getAllReceive
        ? {
            'Type': '2',
          }
        : {
            'Type': '${type ?? '2'}',
            'FromDate': fromDate,
            'ToDate': toDate,
            'SearchTerm': searchTerm ?? '',
            'PageSize': pageSize.toString(),
            'PageIndex': pageIndex.toString(),
            'OrderByDesc': orderByDesc,
            'PageOffset': pageOffset?.toString(),
          };
    try {
      final data = await _provider.get('/notification/paging',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<NotifyResponse>.fromJson(data);
      final works = NotifyResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<NotifyDetailResponse>> getNotifyDetail({
    String id,
    bool isBackground = false,
  }) async {
    try {
      final data = await _provider.get('/notification/$id',
          params: {}, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<NotifyDetailResponse>.fromJson(data);
      final works = NotifyDetailResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> getTotalDelivery({
    bool isBackground = false,
  }) async {
    try {
      final data = await _provider.get('/notification/total-delivery',
          params: {}, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> seenNotify(
      {String notifyId, bool isBackground = false}) async {
    try {
      final data = await _provider.put('/notification/seen/$notifyId', {},
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      final res = data['data'].stringValue;
      response.setData(res);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<OptionModelString>>> getUserByPosition(
      {@required int userPosition, bool backgroundMode = false}) async {
    final param = <String, dynamic>{'userPosition': userPosition.toString()};
    try {
      final data = await _provider.get('/user/getuserx6byposition',
          params: param, isRequireAuth: true, backgroundMode: backgroundMode);
      final response = ServerResponse<List<OptionModelString>>.fromJson(data);
      final users = data['data']
              ?.list
              ?.map((e) => UserPositionModel.fromJson(e))
              ?.toList() ??
          [];
      final result = users.map((e) => OptionModelString(e.name, e.id)).toList();
      response.setData(result);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<OptionModelString>>> getListTeam(
      {String idGroup, bool isBackground = false}) async {
    try {
      final param = {
        'UserGroupIds': idGroup,
      };
      final data = await _provider.get('/userteam/get-team-by-usergroup',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<List<OptionModelString>>.fromJson(data);
      final result = data['data']?.list?.map((e) {
            final team = TeamModel.fromJson(e);
            return OptionModelString(team.userGroupName, team.id);
          })?.toList() ??
          [];

      response.setData(result);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<OptionModelString>>> getListGroup(
      {bool isBackground = false}) async {
    try {
      final data = await _provider.get('/usergroup/groupx6',
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<List<OptionModelString>>.fromJson(data);
      final result = data['data']?.list?.map((e) {
            final team = GroupModel.fromJson(JSON(e));
            return OptionModelString(team.name, team.id);
          })?.toList() ??
          [];

      response.setData(result);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<OptionModelString>>> getListEmployees(
      {@required String groupID,
      @required String teamID,
      bool isBackground = false}) async {
    try {
      final params = <String, dynamic>{
        'UserGroupId': groupID,
        'UserTeamId': teamID,
        'IsEmployee': false.toString(),
      };
      final data = await _provider.get('/user/getuserbyuserteamorusergroup',
          isRequireAuth: true, params: params, backgroundMode: isBackground);
      final response = ServerResponse<List<OptionModelString>>.fromJson(data);
      final result = data['data']?.list?.map((e) {
            final team = UserPositionModel.fromJson(e);
            return OptionModelString(team.name, team.id);
          })?.toList() ??
          [];

      response.setData(result);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> sendFeedback({
    @required Map<String, dynamic> request,
    bool isBackground = false,
  }) async {
    try {
      final data = await _provider.post('/notification', request,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse.fromJson(data);
      response.setData(data['data'].stringValue);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

