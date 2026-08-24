// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/services/responseModel/equiqment_response.dart';
import 'package:evnmobile/src/htdct/services/responseModel/tba_content_check_response.dart';
import 'package:evnmobile/src/htdct/services/responseModel/tba_general_info_response.dart';
import 'package:evnmobile/src/htdct/services/responseModel/tba_group_check_response.dart';
import 'package:evnmobile/src/htdct/services/responseModel/tba_result_response.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../../app_common/utils/utils.dart';
import '../../../htld/common/utils/progress_h_u_d.dart';
import '../../common/utils/common.dart';
import '../../models/equipment_model.dart';
import '../request_model/post_result_request.dart';
import '../responseModel/abnormal_phenomenon_response.dart';
import '../responseModel/image_group_response.dart';

class TBARepository {
  final _provider = ApiProvider();

  Future<ServerResponse<TBAGeneralInfoResponse>> getGeneralInfo(
      {String idTicket,
      bool isBackground = false,
      TestType testType = TestType.subStation}) async {
    try {
      final data = await _provider.get(
          '/${testType == TestType.subStation ? 'substationinspect' : testType == TestType.line ? 'lineinspect' : 'nonpmisinspect'}/$idTicket',
          isRequireAuth: true,
          backgroundMode: isBackground);
      final response = ServerResponse<TBAGeneralInfoResponse>.fromJson(data);
      final info = TBAGeneralInfoResponse.fromJson(data);
      response.setData(info);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TBAResultResponse>> getResult({
    @required String idTicket,
    @required TestType testType,
    bool isBackground = false,
  }) async {
    try {
      var pathByType = '';
      if (testType == TestType.subStation) {
        pathByType = 'substationinspect';
      } else {
        pathByType = 'lineinspect';
      }

      final data = await _provider.get('/$pathByType/$idTicket/result',
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<TBAResultResponse>.fromJson(data);
      final rs = TBAResultResponse.fromJson(data);
      response.setData(rs);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> postResult({
    @required TestType testType,
    String ticketId,
    PostResultRequest request,
    bool isBackground = false,
  }) async {
    try {
      var pathByType = '';
      if (testType == TestType.subStation) {
        pathByType = 'substationinspect';
      } else {
        pathByType = 'lineinspect';
      }

      final data = await _provider.put(
          '/$pathByType/$ticketId/result', request.toJson(),
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> completeTicket({
    @required TestType testType,
    String ticketId,
    bool isBackground = false,
  }) async {
    try {
      var pathByType = '';
      if (testType == TestType.subStation) {
        pathByType = 'substationinspect';
      } else if (testType == TestType.line) {
        pathByType = 'lineinspect';
      } else {
        pathByType = 'nonpmisinspect';
      }
      final location = await getCurrentPosition();
      final longitude = location?.longitude;
      final latitude = location?.latitude;
      final address = await getNameByLocation(location?.latitude, location?.longitude);

      final params = <String, dynamic>{
        'id': ticketId,
        'longitude': longitude,
        'latitude': latitude,
        'address': address,
      };

      final data = await _provider.post('/$pathByType/complete', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TBAGroupCheckResponse>> getGroupCheck(
      {String idTicket, TestType testType, bool isBackground = false}) async {
    try {
      var url = '';
      if (testType == TestType.subStation) {
        url = 'substationinspect';
      } else if (testType == TestType.line) {
        url = 'lineinspect';
      } else {
        url = 'nonpmisinspect';
      }
      final data = await _provider.get('/$url/$idTicket/group',
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<TBAGroupCheckResponse>.fromJson(data);
      final group = TBAGroupCheckResponse.fromJson(data);
      response.setData(group);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TBAGroupCheckResponse>> putGroupImage(
      {String idTicket, TestType testType, bool isBackground = false}) async {
    try {
      var url = '';
      if (testType == TestType.subStation) {
        url = 'substationinspect';
      } else {
        url = 'lineinspect';
      }
      final data = await _provider.get('/$url/$idTicket/group',
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<TBAGroupCheckResponse>.fromJson(data);
      final group = TBAGroupCheckResponse.fromJson(data);
      response.setData(group);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ContentCheckResponse>> getContentCheck(
      {String idTicket, bool isBackground = false}) async {
    try {
      final data = await _provider.get(
          '/substationinspect/$idTicket/content/day-time',
          isRequireAuth: true,
          backgroundMode: isBackground);
      final response = ServerResponse<ContentCheckResponse>.fromJson(data);
      final content = ContentCheckResponse.fromJson(data);
      response.setData(content);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<NightContentCheckResponse>> getNightContentCheck(
      {String idTicket, bool isBackground = false}) async {
    try {
      final data = await _provider.get(
          '/substationinspect/$idTicket/content/night-time',
          isRequireAuth: true,
          backgroundMode: isBackground);
      final response = ServerResponse<NightContentCheckResponse>.fromJson(data);
      final content = NightContentCheckResponse.fromJson(data);
      response.setData(content);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> saveContentCheck(
      {String idTicket,
      String abnormalPhenomenon,
      bool isSuggestAbnormal = false,
      bool isBackground = false,
      TestType testType = TestType.subStation}) async {
    try {
      final location = await getCurrentPosition();
      final longitude = location.longitude;
      final latitude = location.latitude;
      final address = await getNameByLocation(location.latitude, location.longitude);

      var url = '';
      if (testType == TestType.subStation) {
        url = 'substationinspect';
      } else {
        url = 'lineinspect';
      }
      final param = {
        'abnormalPhenomenon': abnormalPhenomenon ?? '',
        'isSuggestAbnormal': isSuggestAbnormal.toString(),
        'address': address,
      };
      final data = await _provider.put(
          '/$url/$idTicket/content/day-time', param,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> updateNightContentCheck(
      {@required String idTicket,
      @required Map<String, dynamic> params}) async {
    try {
      final data = await _provider.put(
          '/substationinspect/$idTicket/content/night-time', params,
          isRequireAuth: true);
      final response = ServerResponse.fromJson(data);
      final idTicketRes = data['data'].stringValue;
      response.setData(idTicketRes);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ContentCheckResponse>> getLineContentCheck(
      {String idTicket, bool isBackground = false}) async {
    try {
      final data = await _provider.get(
          '/lineinspect/$idTicket/content/day-time',
          isRequireAuth: true,
          backgroundMode: isBackground);
      final response = ServerResponse<ContentCheckResponse>.fromJson(data);
      final content = ContentCheckResponse.fromJson(data);
      response.setData(content);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<AbnormalPhenomenonResponse>> getAbnormalPhenomenon(
      {String idTicket, TestType testType, bool isBackground = false}) async {
    try {
      var url = '';
      if (testType == TestType.subStation) {
        url = 'substationinspect';
      } else {
        url = 'lineinspect';
      }
      final data = await _provider.get(
          '/$url/$idTicket/content/abnormal-phenomenon',
          isRequireAuth: true,
          backgroundMode: isBackground);
      final response =
          ServerResponse<AbnormalPhenomenonResponse>.fromJson(data);
      final abnormalPhenomenon = AbnormalPhenomenonResponse.fromJson(data);
      response.setData(abnormalPhenomenon);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<EquipmentResponse>> getEquipment(
      {@required String idTicket,
      @required String categoryId,
      @required TestType testType,
      bool isBackground = false}) async {
    try {

      Future<ServerResponse<EquipmentResponse>> fetch(int pageIndex,
          {bool isBackgroundMode}) async {
        ProgressHUD.show();
            var url = '';
            if (testType == TestType.subStation) {
              url = 'substationinspect';
            } else {
              url = 'lineinspect';
            }
            final param = {
              'Id': idTicket,
              'categoryId': categoryId,
              'PageSize': '30',
              'PageIndex': pageIndex.toString(),
            };
        final data = await _provider.get(
            '/$url/content/equipment', params: param,
            isRequireAuth: true, backgroundMode: isBackgroundMode);
        final response = ServerResponse<EquipmentResponse>.fromJson(data);
        response.setData(EquipmentResponse.fromJson(data));
        return response;
      }

      final listResponse = <EquipmentModel>[];
      final result = await fetch(1, isBackgroundMode: true);
      if (result.isLoadSuccess == true) {
        listResponse.addAll(result.data.list);
        final listPage = <int>[];
        if (result.data.paging.totalPages > 1) {
          for (var i = 2; i <= result.data.paging.totalPages; i++) {
            listPage.add(i);
          }

          await Future.forEach<int>(listPage, (element) async {
            final result = await fetch(element, isBackgroundMode: true);
            if (result.isLoadSuccess == true) {
              listResponse.addAll(result.data.list);
            }
          });
        }
      } else {
        ProgressHUD.dismiss();
        return result;
      }

      final response = ServerResponse<EquipmentResponse>(statusCode: 200);
      response.setData(EquipmentResponse()..list = listResponse);
      ProgressHUD.dismiss();
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
    }
  //     var url = '';
  //     if (testType == TestType.subStation) {
  //       url = 'substationinspect';
  //     } else {
  //       url = 'lineinspect';
  //     }
  //     final param = {
  //       'Id': idTicket,
  //       'categoryId': categoryId,
  //       'PageSize': '30',
  //       'PageIndex': pageIndex.toString(),
  //     };
  //     final data = await _provider.get('/$url/content/equipment',
  //         isRequireAuth: true, params: param, backgroundMode: isBackground);
  //     final response = ServerResponse<EquipmentResponse>.fromJson(data);
  //     final equipmentList = EquipmentResponse.fromJson(data);
  //     response.setData(equipmentList);
  //     return response;
  //   } catch (error) {
  //     debugPrint(error.toString());
  //     return ServerResponse();
  //   }
  // }

  Future<ServerResponse<String>> updateUser(
      {@required String idTicket,
      @required String imageStorageId,
      @required String idUserImage,
      @required TestType testType,
      bool isBackground = false}) async {
    try {
      var pathByType = '';
      var paramByType = '';
      if (testType == TestType.subStation) {
        pathByType = 'substationinspect';
        paramByType = 'substationInspectGroupUserId';
      } else if (testType == TestType.line) {
        pathByType = 'lineinspect';
        paramByType = 'lineInspectorId';
      } else {
        pathByType = 'nonpmisinspect';
        paramByType = 'nonPmisInspectorId';
      }
      final param = {
        'id': idTicket,
        paramByType: idUserImage,
        'imageIds': [imageStorageId]
      };
      final data = await _provider.put('/$pathByType/group/images', param,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ImagesGroupResponse>> getImages(
      {@required String idImages,
      @required TestType testType,
      bool isBackground = false}) async {
    try {
      var pathByType = '';
      if (testType == TestType.subStation) {
        pathByType = 'substationinspect';
      } else if (testType == TestType.line) {
        pathByType = 'lineinspect';
      } else {
        pathByType = 'nonpmisinspect';
      }
      final data = await _provider.get('/$pathByType/group/images/$idImages',
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<ImagesGroupResponse>.fromJson(data);
      final equipmentList = ImagesGroupResponse.fromJson(data);
      response.setData(equipmentList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> deleteImages(
      {@required String imageStorageId, bool isBackground = false}) async {
    try {
      final data = await _provider.delete('/common/image/$imageStorageId',
          isRequireAuth: true);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> updateGeneralInfo({
    Map<String, dynamic> params,
    bool isBackground = false,
  }) async {
    try {
      final data = await _provider.post('/substationinspect/general-info', params,
          isRequireAuth: true, backgroundMode: isBackground);
      final response = ServerResponse<String>.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

