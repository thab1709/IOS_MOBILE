// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/models/group_in_unit_model.dart';
import 'package:evnmobile/src/htld/models/unit_model.dart';
import 'package:evnmobile/src/htld/services/responseModel/user_profifle_response.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:evnmobile/src/htld/shared_preferences/app_shared.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<UserProfileResponse>> getUserProfile({
    bool requireAuth = true,
  }) async {
    try {
      final data = await _provider.get('/user/profile',
          isRequireAuth: requireAuth, backgroundMode: true);
      final userProfile = UserProfileResponse.fromJson(data);
      if(userProfile?.userProfile?.id != null) {
        await AppShared.instance.persistentUserProfile(userProfile.userProfile);
      }
      final response = ServerResponse<UserProfileResponse>.fromJson(data);
      response.setData(userProfile);
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
      units.insert(0, UnitModel(name: 'Tất cả đơn vị', id: '0', indexId: -1));
      final response = ServerResponse<List<UnitModel>>.fromJson(data);
      response.setData(units);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<GroupInUnitModel>>> getUserGroup({
    String unitId,
    bool requireAuth = true,
  }) async {
    try {
      final param = {'pageSize': '999', 'UnitId': unitId};
      final data = await _provider.get('/usergroup',
          params: param, isRequireAuth: requireAuth, backgroundMode: true);
      final listData = data['data']?.value != null ? data['data'].list : null;
      final groups = listData != null ? listData.mapIndexed((e, index) {
        final model = GroupInUnitModel.fromJson(e);
        model.indexId = index;
        return model;
      }).toList() : <GroupInUnitModel>[];
      groups.insert(
          0, GroupInUnitModel(name: 'Tất cả phòng, đội', id: '0', indexId: -1));
      final response = ServerResponse<List<GroupInUnitModel>>.fromJson(data);
      response.setData(groups);
      if (response?.data != null) {
        final listGroups = MAppShared.shared.groups;
        listGroups.add(ListUserGroup(unitId: unitId, groups: response.data));
        MAppShared.shared.groups = listGroups;
        await MAppShared.shared.saveGroups(listGroups);
      }

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

