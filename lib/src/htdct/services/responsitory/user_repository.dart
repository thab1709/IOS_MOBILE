// @dart=2.9
import 'package:collection/collection.dart';
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/services/responseModel/user_profifle_response.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';

import '../../models/day_night/ticket.dart';
import '../../models/work_current_user_model.dart';
import '../responseModel/group_response.dart';
import '../responseModel/log_book_response.dart';
import '../responseModel/station_response.dart';
import '../responseModel/team_response.dart';
import '../responseModel/work_response.dart';

class UserRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<UserProfileResponse>> getUserProfile({
    bool requireAuth = true,
    bool backgroundMode = true,
  }) async {
    try {
      final data = await _provider.get('/user/profile',
          isRequireAuth: requireAuth, backgroundMode: backgroundMode);
      final userProfile = UserProfileResponse.fromJson(data);
      if (userProfile?.userProfile?.id != null) {
        await AppShared.instance
            .persistentUserProfileDCT(userProfile.userProfile);
      }
      final response = ServerResponse<UserProfileResponse>.fromJson(data);
      response.setData(userProfile);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<StationResponse>> getListTBA(
      {TestType testType, bool isBackground = true}) async {
    try {
      var url = '';
      if (testType == TestType.subStation) {
        url = '/substation/substation-assign-current-user';
      } else {
        url = '/line/line-assign-current-user';
      }
      final queries = {'PageSize': '999', 'PageIndex': '1'};
      final data = await _provider.get(url,
          isRequireAuth: true, backgroundMode: isBackground, params: queries);
      final response = ServerResponse<StationResponse>.fromJson(data);
      final subStation = StationResponse.fromJson(data);
      if (subStation != null) {
        if (testType == TestType.subStation) {
          await AppShared.instance.saveListSubstationHTDCT(subStation.list);
        } else {
          await AppShared.instance.saveListLineHTDCT(subStation.list);
        }
      }
      response.setData(subStation);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<WorkCurrentUserResponse>> getLineOrSubstation(
      {TestType testType, bool isBackground = false}) async {
    final param = {
      'Type': testType == TestType.line?'2':'1',
    };
    try {
      final data = await _provider.get('/checknote/substation-or-line',
          params: param, isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<WorkCurrentUserResponse>.fromJson(data);
      final works = WorkCurrentUserResponse.fromJson(data);
      if (works.list != null) {
        if (testType == TestType.subStation) {
          await AppShared.instance.saveListAllSubstationHTDCT(works.list);
        } else {
          await AppShared.instance.saveListAllLineHTDCT(works.list);
        }
      }
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }


  Future<ServerResponse<GroupResponse>> getListGroup(
      {bool isBackground = true}) async {
    try {
      final queries = {'PageSize': '999', 'PageIndex': '1'};
      final data = await _provider.get('/usergroup/x6',
          isRequireAuth: true, backgroundMode: isBackground, params: queries);
      final response = ServerResponse<GroupResponse>.fromJson(data);
      final groupList = GroupResponse.fromJson(data);
      if (groupList.list != null) {
        groupList.list.forEachIndexed((index, element) {
          getListTeam(idGroup: element.id, isBackground: true);
        });
        await AppShared.instance.saveGroupsHTDCT(groupList.list);
      }
      response.setData(groupList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TeamResponse>> getListTeam(
      {String idGroup, bool isBackground = true}) async {
    try {
      final param = {
        'UserGroupIds': idGroup,
        'PageSize': '999',
        'PageIndex': '1'
      };
      final data = await _provider.get('/userteam/get-team-by-usergroup',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<TeamResponse>.fromJson(data);
      final teamList = TeamResponse.fromJson(data);
      if (teamList.list != null) {
        await AppShared.instance.saveTeamsHTDCT(teamList.list);
      }
      response.setData(teamList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<WorkCurrentUserResponse>> getListUnit(
      {bool isBackground = true}) async {
    try {
      final data = await _provider.get('/report/units',
          isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<WorkCurrentUserResponse>.fromJson(data);
      final works = WorkCurrentUserResponse.fromJson(data);
      if (works.list != null) {
        await AppShared.instance.saveUnits(works.list);
      }
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<UnitResponse>> getListUnitX6(
      {bool isBackground = true}) async {
    try {
      final data = await _provider.get('/unit',
          isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<UnitResponse>.fromJson(data);
      final works = UnitResponse.fromJson(data);
      if (works.list != null) {
        await AppShared.instance.saveUnitsX6(works.list);
      }
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<WorkCurrentUserResponse>> getListUser(
      {bool isBackground = true}) async {
    try {
      final data = await _provider.get('/user/getuserlist',
          isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<WorkCurrentUserResponse>.fromJson(data);
      final works = WorkCurrentUserResponse.fromJson(data);
      if (works.list != null) {
        await AppShared.instance.saveListUser(works.list);
      }
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }


    void getDataDummy() {
    getLineOrSubstation(testType: TestType.subStation, isBackground: true);
    getLineOrSubstation(testType: TestType.line, isBackground: true);
    getListGroup(isBackground: true);
    getListTBA(testType: TestType.subStation, isBackground: true);
    getListTBA(testType: TestType.line, isBackground: true);
    getListUnit(isBackground: true);
    getListUser(isBackground: true);
    getListUnitX6(isBackground: true);

    //final futures = <Future>[];
    // futures.add(getListGroup(isBackground: true));
    // futures.add(getListTBA(testType: TestType.subStation, isBackground: true));
    // futures.add(getListTBA(testType: TestType.line, isBackground: true));
    // futures.add(getListUnit(isBackground: true));
    // futures.add(getListUser(isBackground: true));
    //
    // futures.add(getLineOrSubstation(testType: TestType.subStation, isBackground: true));
    // futures.add(getLineOrSubstation(testType: TestType.line, isBackground: true));
    // await Future.wait(futures);
  }

  Future<void> clearDataDummy() async {
    await AppShared.instance.clearListAllSubstationHTDCT();
    await AppShared.instance.clearListAllLineHTDCT();
    await AppShared.instance.clearGroupsHTDCT();
    await AppShared.instance.clearListSubstationHTDCT();
    await AppShared.instance.clearListLineHTDCT();
    await AppShared.instance.clearUnits();
    await AppShared.instance.clearListUser();
    await AppShared.instance.clearUnitsX6();
  }
}

