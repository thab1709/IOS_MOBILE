// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/services/responseModel/work_response.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:flutter/material.dart';

class WorkRepository {
  final _provider = ApiProvider();
  Future<ServerResponse<WorkResponse>> getListWork({
    @required SubStationType subStationType,
    @required String workType,
    String workStatus,
    String searchTerm,
    num pageIndex = 1,
    String orderBy = 'ASC',
    String orderByDesc,
    String fromDate,
    String toDate,
    String unitId,
    String groupId,
    String pageSize,
    num pageOffset,
    bool isBackground = false,
    bool isAbnormal = false,
  }) async {
    final param = {
      'WorkType': '$workType' ?? '',
      'InspectType': '${subStationType.code}',
      'unitId': unitId == '0' ? '' : unitId,
      'userGroup': groupId == '0' ? '' : groupId,
      'workStatus': '$workStatus' ?? '',
      'SearchTerm': searchTerm ?? '',
      'orderBy': orderBy,
      'IsAbnormal': isAbnormal.toString(),
      'fromDate': fromDate,
      'toDate': toDate,
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'pageSize': pageSize ?? '99',
      'pageOffset': pageOffset?.toString(),
    };
    try {
      final data = await _provider.get(
          subStationType == SubStationType.mediumVoltage ||
                  subStationType == SubStationType.lowVoltage
              ? '/lineinspect/work'
              : '/work',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackground);
      debugPrint("API PARAMS " + param.toString());
      final response = ServerResponse<WorkResponse>.fromJson(data);
      final works = WorkResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

