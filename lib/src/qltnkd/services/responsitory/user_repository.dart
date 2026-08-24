// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/htld/models/unit_model.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:flutter/material.dart';

class ReportUserRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<UserProfileModel>> getUserProfile({
    bool requireAuth = true,
    bool isBackgroundMode = false
  }) async {
    try {
      final data =
          await _provider.get('/user/profile', isRequireAuth: requireAuth, backgroundMode: isBackgroundMode);
      final userProfile = UserProfileModel.fromJson(data['data']);
      await AppShared.instance.persistentUserProfile(userProfile);
      final response = ServerResponse<UserProfileModel>.fromJson(data);
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
          params: param, isRequireAuth: requireAuth);
      final listData = data['data']?.value != null ? data['data'].list : null;
      final units = listData != null ? listData.mapIndexed((e, index) {
        final model = UnitModel.fromJson(e);
        model.indexId = index;
        return model;
      }).toList() : <UnitModel>[];
      units.insert(0, UnitModel(name: 'Tất cả', id: '', indexId: -1));
      final response = ServerResponse<List<UnitModel>>.fromJson(data);
      response.setData(units);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

