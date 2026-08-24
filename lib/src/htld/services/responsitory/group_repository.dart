// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/services/responseModel/general_infomation_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/group_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/person_perform_response.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:flutter/material.dart';

class GroupRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<PersonPerformResponse>> getPersonPerform({
    String workId,
    bool requireAuth = true,
  }) async {
    try {
      final data = await _provider.get('/group',
          params: {
            'WorkId': workId,
            'pageSize': '99',
            'pageIndex': '1',
            'orderBy': 'ASC',
            'OrderByDesc': 'ASC',
            'pageOffset': '1',
          },
          isRequireAuth: requireAuth);
      final response = ServerResponse<PersonPerformResponse>.fromJson(data);
      response.setData(PersonPerformResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GroupResponse>> getGroup({
    @required String formId,
    @required String endpoint,
    bool requireAuth = true,
  }) async {
    try {
      final data = await _provider.get('/$endpoint/$formId/group',
          isRequireAuth: requireAuth);
      final response = ServerResponse<GroupResponse>.fromJson(data);
      response.setData(GroupResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> createOrUpdateGroup(
    String formId,
    Map map,
    String endpoint, {
    bool requireAuth = true,
  }) async {
    try {
      final data = await _provider.put('/$endpoint/$formId/group', map,
          isRequireAuth: requireAuth);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

