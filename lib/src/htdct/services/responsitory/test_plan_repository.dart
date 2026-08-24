// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app_common/shared/app_shared.dart';
import '../../../app_common/utils/utils.dart';
import '../../common/utils/common.dart';
import '../responseModel/log_book_response.dart';
import '../responseModel/work_response.dart';

class TestPlanRepository {
  final _provider = ApiProvider();
  final userProfile = AppShared.instance.getUserProfile();

  Future<ServerResponse<WorkResponse>> getWorkList(
      {TestType testType,
      String workType,
      String workStatus,
      String searchTerm,
      String id,
      num pageIndex = 1,
      String orderBy = 'ASC',
      String orderByDesc,
      String fromDate,
      String toDate,
      String userTeamID,
      String groupID,
      num pageOffset,
      num pageSize = 10,
      bool isBackground = false,
      bool isPMIS = true,
      String scheduleTypeId,
      String createdUserIds,
      String inspectId,
      String workId,
      bool hasAbnormal = false}) async {
    final param = isPMIS
        ? (inspectId.isNullOrEmpty() && workId.isNullOrEmpty())
            ? {
                'UserTeamIds': userTeamID ?? '',
                'WorkType': workType ?? '',
                'UserGroupIds': groupID ?? '',
                'WorkStatus': workStatus ?? '',
                'SearchTerm': searchTerm ?? '',
                'OrderBy': orderBy,
                'FromDate': fromDate,
                'LineOrSubstationIds': id,
                'ToDate': toDate,
                'PageIndex': pageIndex.toString(),
                'OrderByDesc': orderByDesc,
                'PageSize': pageSize.toString(),
                'PageOffset': pageOffset?.toString(),
                'isPMIS': 'true',
                'HasAbnormal': hasAbnormal.toString()
              }
            : workId.isNullOrEmpty()
                ? {
                    'WorkType': workType ?? '',
                    'InspectId': inspectId ?? '',
                  }
                : {
                    'WorkType': workType ?? '',
                    'WorkId': workId ?? '',
                  }
        : (inspectId.isNullOrEmpty() && workId.isNullOrEmpty())
            ? {
                'UserTeamIds': userTeamID ?? '',
                'UserGroupIds': groupID ?? '',
                'WorkStatus': workStatus ?? '',
                'SearchTerm': searchTerm ?? '',
                'OrderBy': orderBy,
                'FromDate': fromDate,
                'LineOrSubstationIds': id,
                'ToDate': toDate,
                'PageIndex': pageIndex.toString(),
                'OrderByDesc': orderByDesc,
                'PageSize': pageSize.toString(),
                'PageOffset': pageOffset?.toString(),
                'isPMIS': 'false',
                'CreatedUserIds': createdUserIds ?? '',
                'ScheduleTypeId': scheduleTypeId,
                'HasAbnormal': hasAbnormal.toString()
              }
            : workId.isNullOrEmpty()
                ? {
                    'WorkType': workType ?? '',
                    'InspectId': inspectId ?? '',
                    'isPMIS': 'false',
                  }
                : {
                    'WorkType': workType ?? '',
                    'isPMIS': 'false',
                    'WorkId': workId ?? '',
                  };
    try {
      final data = await _provider.get('/work',
          params: param, isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<WorkResponse>.fromJson(data);
      final works = WorkResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<WorkCurrentUserResponse>> getWorkCurrentUserList(
      {TestType testType,
      String workType = '2',
      bool isBackground = false}) async {
    final param = {
      'WorkType': workType,
    };
    try {
      final data = await _provider.get(
          testType == TestType.line
              ? '/line/line-assign-current-user'
              : '/substation/substation-assign-current-user',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackground);

      final response = ServerResponse<WorkCurrentUserResponse>.fromJson(data);
      final works = WorkCurrentUserResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LogBookResponse>> getEquipmentByCategory(
      {String substationId,
      String categoryId,
      bool isBackground = true}) async {
    final param = {
      'SubstationId': substationId,
      'Category': categoryId,
    };
    try {
      final data = await _provider.get('/report/equipmentbycategory',
          params: param, isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<LogBookResponse>.fromJson(data);
      final works = LogBookResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  // Future<ServerResponse<WorkCurrentUserResponse>> getListUnit(
  //     {bool isBackground = true}) async {
  //
  //   try {
  //     final data = await _provider.get('/report/units',
  //         isRequireAuth: true, backgroundMode: isBackground);
  //
  //     final response = ServerResponse<WorkCurrentUserResponse>.fromJson(data);
  //     final works = WorkCurrentUserResponse.fromJson(data);
  //     response.setData(works);
  //     return response;
  //   } catch (error) {
  //     debugPrint(error.toString());
  //     return ServerResponse();
  //   }
  // }

  Future<ServerResponse<WorkCurrentUserIntResponse>>
      getListCategoryBySubstation(
          {String lineOrSubstationID,
          bool isBackground = true,
          bool isNightTime = false,
          bool isLine = false}) async {
    final param = {
      'substationId': lineOrSubstationID,
      'isNightTime': isNightTime.toString(),
      'isline': isLine.toString()
    };
    try {
      final data = await _provider.get('/work/listcategorybysubstation',
          params: param, isRequireAuth: true, backgroundMode: isBackground);

      final response =
          ServerResponse<WorkCurrentUserIntResponse>.fromJson(data);
      final works = WorkCurrentUserIntResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<WorkCurrentUserIntResponse>> getListCategoryByNode(
      {String ids, bool isBackground = true}) async {
    final param = {'Ids': ids};
    try {
      final data = await _provider.get('/abnormal/listcategorybynode',
          params: param, isRequireAuth: true, backgroundMode: isBackground);

      final response =
          ServerResponse<WorkCurrentUserIntResponse>.fromJson(data);
      final works = WorkCurrentUserIntResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<WorkCurrentUserResponse>> listEquipmentByCategory(
      {bool isSubStationInspect = true,
      String lineOrSubstationID,
      bool isBackground = true,
      String category}) async {
    final param = isSubStationInspect
        ? {
            'SubstationId': lineOrSubstationID ?? '',
            'LineId': '',
            'Categories': category ?? '4'
          }
        : {
            'SubstationId': '',
            'LineId': lineOrSubstationID ?? '',
            'Categories': category ?? '4'
          };
    try {
      final data = await _provider.get(
          '/checkoperationnote/listequipmentbycategory',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackground);

      final response = ServerResponse<WorkCurrentUserResponse>.fromJson(data);
      final works = WorkCurrentUserResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> createTicket(
      {@required Position location, String workId, String workType, bool isBackground = true}) async {
    try {
      final address = await getNameByLocation(location?.latitude, location?.longitude);
      final param = <String, dynamic>{
        'type': workType,
        'workId': workId,
        'longitude': location?.longitude,
        'latitude': location?.latitude,
        'address': address,
      };
      final data = await _provider.post('/substationinspect', param,
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

  Future<ServerResponse> createTicketUnknow(
      {String workId, bool isBackground = true}) async {
    try {
      final location = await getCurrentPosition();
      final longitude = location?.longitude;
      final latitude = location?.latitude;
      final address =
          await getNameByLocation(location?.latitude, location?.longitude);
      final param = <String, dynamic>{
        'workId': workId,
        'longitude': longitude,
        'latitude': latitude,
        'address': address,
      };
      final data = await _provider.post('/nonpmisinspect', param,
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
}

