// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/constance.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/inspection_model.dart';
import 'package:evnmobile/src/htld/services/responseModel/general_infomation_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/inspection_response.dart';
import 'package:flutter/material.dart';

import '../server_response.dart';

class InspectionRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<InspectionResponse>> getListTicket(
    SubStationType subStationType,
    String inspectionType,
    String status,
    String fromDate,
    String toDate,
    String unitId,
    String searchTerm, {
    bool requireAuth = true,
    num pageIndex = 1,
    String orderBy = 'ASC',
    String orderByDesc,
    num pageOffset,
  }) async {
    try {
      var url = 'distributioninspect';
      if (subStationType == SubStationType.mediumVoltage) {
        url = 'lineinspect';
      } else if (subStationType == SubStationType.lowVoltage) {
        url = 'lineinspect';
      } else if (subStationType == SubStationType.intermediate) {
        url = 'immediaryinspect';
      } else if (subStationType == SubStationType.distribution) {
        url = 'distributioninspect';
      }

      final data =
          await _provider.get('/$url', isRequireAuth: requireAuth, params: {
        'inspectionType': inspectionType,
        'inspectionStatus': status == '0' ? '' : status.toString(),
        'unitId': unitId == '0' ? '' : unitId,
        'fromDate': fromDate,
        'toDate': toDate,
        'searchTerm': searchTerm,
        'orderBy': orderBy,
        'pageIndex': pageIndex.toString(),
        'orderByDesc': orderByDesc,
        'pageSize': appPageSize.toString(),
        'pageOffset': pageOffset?.toString(),
      });
      debugPrint("API Params: check ${data.toString()}");
      final response = ServerResponse<InspectionResponse>.fromJson(data);
      response.setData(InspectionResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<GeneralInfoResponse> deleteInspection(
      String inspectionId, String endpoint) async {
    try {
      final data = await _provider.delete('/$endpoint/$inspectionId');
      return GeneralInfoResponse.fromJson(data);
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<ServerResponse<List<InspectionModel>>> getTicketsOfManager({
    @required String inspectType,
    String inspectionType,
    String inspectionStatus,
    String searchTerm,
    String fromDate,
    String toDate,
  }) async {
    final user = AppShared.instance.getUserProfile();
    final param = {
      'UnitId': user.unitId,
      'InspectType': '$inspectType',
      'InspectionType': '$inspectionType',
      'SearchTerm': searchTerm,
      'FromDate': fromDate,
      'ToDate': toDate
    };
    if (inspectionStatus != '0') {
      param['InspectionStatus'] = '$inspectionStatus';
    }
    try {
      final data =
          await _provider.get('/manager', params: param, isRequireAuth: true);
      final response = ServerResponse<List<InspectionModel>>.fromJson(data);
      response.setData(data['data']
          ?.list
          ?.map((e) => InspectionModel.fromJSON(e))
          ?.toList());
      return response;
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse();
    }
  }

  Future<String> getPdf({String id, SubStationType subStationType}) async {
    final param = {'InspectType': '${subStationType.code}'};
    try {
      final data = await _provider.get('/manager/$id',
          params: param, isRequireAuth: true);
      return data['data'].string;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }
}

