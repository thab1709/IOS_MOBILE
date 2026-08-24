// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/line_content_day.dart';
import 'package:evnmobile/src/htld/models/line/line_general.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htld/services/responseModel/line_note_response.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

class LineTicketRepository {
  final provider = ApiProvider();

  Future<ServerResponse<String>> createTicket(
      {TicketType inspectionType,
      String lineId,
      String branchId,
      String workId,
      List<EquipmentModel> kinks,
      bool isBackgroundMode = false,
      List<EquipmentModel> equipments,
      bool isNight}) async {
    final params = {
      'workId': workId,
      'Night': isNight ? 1 : 0,
      'InspectTime': DateTime.now().toUTC(),
      'inspectionType': inspectionType.code,
      'lineId': lineId,
      'lineBranchId': branchId,
      'nodes': kinks.mapIndexed(
        (e, i) {
          final json = <String, dynamic>{
            'substationId': e.id,
          };
          if (i == 0 || i == kinks.length - 1) {
            json['position'] = i == 0 ? 1 : 2;
          }
          return json;
        },
      ).toList(),
      'lineInspectEquipments':
          equipments.map((e) => {'equipmentId': e.id}).toList(),
    };
    final data = await provider.post('/lineinspect', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    LocationServiceBackground.shared.updateLocationToServer(lineId);
    final response = ServerResponse<String>.fromJson(data);
    response.setData(data['data']['lineInspectId'].string);
    return response;
  }

  Future<ServerResponse<String>> createTicketAllNode(
      {TicketType inspectionType,
      String lineId,
      bool isBackgroundMode = false,
      String branchId,
      String workId}) async {
    final params = {
      'workId': workId,
      'InspectTime': DateTime.now().toUTC(),
      'inspectionType': inspectionType.code,
      'lineId': lineId,
      'lineBranchId': branchId,
    };
    final data = await provider.post('/lineinspect/all', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    LocationServiceBackground.shared.updateLocationToServer(lineId);
    final response = ServerResponse<String>.fromJson(data);
    response.setData(data['data'].string);
    return response;
  }

  Future<ServerResponse<String>> addOneBranch(String ticketId,
      {String lineBranchId,
      List<EquipmentModel> kinks,
      bool isBackgroundMode = false,
      List<EquipmentModel> equipments}) async {
    final params = {
      'lineBranchId': lineBranchId,
      'nodes': kinks.mapIndexed(
        (e, i) {
          final json = <String, dynamic>{
            'substationId': e.id,
          };
          if (i == 0 || i == kinks.length - 1) {
            json['position'] = i == 0 ? 1 : 2;
          }
          return json;
        },
      ).toList(),
      'lineInspectEquipments':
          equipments.map((e) => {'equipmentId': e.id}).toList()
    };
    final data = await provider.put(
        '/lineinspect/$ticketId/add-line-branch', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    response.setData(data['data']['lineInspectId'].string);
    return response;
  }

  Future<ServerResponse<String>> updateBranch(String ticketId,
      {String lineBranchId,
      List<EquipmentModel> kinks,
      List<EquipmentModel> equipments}) async {
    final params = {
      'nodes': kinks.mapIndexed(
        (e, i) {
          final json = <String, dynamic>{
            'substationId': e.id,
          };
          if (i == 0 || i == kinks.length - 1) {
            json['position'] = i == 0 ? 1 : 2;
          }
          return json;
        },
      ).toList(),
      'lineInspectEquipments':
          equipments.map((e) => {'equipmentId': e.id}).toList()
    };
    final data = await provider.put(
        '/lineinspect/$ticketId/$lineBranchId/update-line-branch', params,
        isRequireAuth: true);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> updateInfo(
    String id,
    LineGeneral model, {
    bool isBackgroundMode = false,
  }) async {
    final param = {
      'structure': model.structure,
      'inspectTime': DateTime.now().toStringFormat(AppStrings.utcFormatNotZ),
      'inspectionRequest': model.inspectionRequest,
      'weather': model.weather,
      'weather2': model?.weather2,
      'temperature': model.temperature,
      'temperature2': model?.temperature2
    };

    final data = await provider.put('/lineinspect/$id/info', param,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    LocationServiceBackground.shared.updateLocationToServer(model.id);
    response.setData(data['data'].string);
    return response;
  }

  Future<ServerResponse<LineGeneral>> getGeneral(String id,
      {bool isBackgroundMode = false}) async {
    final data = await provider.get('/lineinspect/$id/info',
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<LineGeneral>.fromJson(data);
    response.setData(LineGeneral.fromJson(data));
    return response;
  }

  Future<ServerResponse<String>> deleteLineBranch(
      String id, String lineBranchInspect) async {
    final data = await provider.delete('/lineinspect/$id/$lineBranchInspect',
        isRequireAuth: true);
    final response = ServerResponse<String>.fromJson(data);
    return response;
  }

  Future<ServerResponse<String>> updateBranchContent({
    @required String ticketId,
    @required String lineBranchInspectId,
    Map<String, dynamic> params,
    bool isBackgroundMode = false,
  }) async {
    final data = await provider.put(
        '/lineinspect/$ticketId/$lineBranchInspectId/content', params,
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<String>.fromJson(data);
    response.setData(data['data'].string);
    return response;
  }

  Future<ServerResponse<List<LineBranchInfo>>> getContent(
    String id, {
    bool isBackgroundMode = false,
  }) async {
    final data = await provider.get('/lineinspect/$id/content',
        isRequireAuth: true, backgroundMode: isBackgroundMode);
    final response = ServerResponse<List<LineBranchInfo>>.fromJson(data);
    final listLineBranchInfo = data['data']['lineBranchInspects']
        ?.list
        ?.map((e) => LineBranchInfo.fromJson(e))
        ?.toList();
    response.setData(listLineBranchInfo);
    return response;
  }

  Future<ServerResponse<LineContentModel>> getBranchContent(
    String id,
    String lineBranchInspectId, {
    bool isBackgroundMode = false,
  }) async {
    final data = await provider.get(
        '/lineinspect/$id/$lineBranchInspectId/content',
        isRequireAuth: true,
        backgroundMode: isBackgroundMode);
    final response = ServerResponse<LineContentModel>.fromJson(data);
    response.setData(LineContentModel.fromJson(data['data']['content']));
    return response;
  }

  Future<ServerResponse<List<String>>> getAbnormalPhenomenon(
      String ticketId, String lineBranchInfo) async {
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/abnormal-phenomenon',
          isRequireAuth: true);
      final response = ServerResponse<List<String>>.fromJson(data);
      response.setData(data['data'].list.map((e) => JSON(e).string).toList());
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineNodesResponse>> getBranchNodes(
      String ticketId, String lineBranchInspectId, int pageIndex,
      {bool isBackgroundMode = false}) async {
    final param = {
      'pageSize': '50',
      'pageIndex': pageIndex?.toString() ?? '',
      'orderBy': 'ASC',
      'OrderByDesc': 'ASC',
      'pageOffset': '1',
    };

    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInspectId/nodes',
          params: param,
          backgroundMode: isBackgroundMode,
          isRequireAuth: true);
      final response = ServerResponse<LineNodesResponse>.fromJson(data)
        ..setData(LineNodesResponse.fromJson(data));

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

