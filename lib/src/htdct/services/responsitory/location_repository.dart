// @dart=2.9
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app_common/networking/api_provider.dart';
import '../../../app_common/utils/utils.dart';
import '../../common/utils/common.dart';
import '../../screens/worker_location/models/location_line_detail.dart';
import '../../screens/worker_location/models/substation_detail_location.dart';
import '../responseModel/location_response.dart';
import '../server_response.dart';

class LocationRepository {
  final _provider = ApiProvider();

  Future sendLocation({
    String lineInspectId,
    String substationInspectId,
    String entityId,
    bool requireAuth = true,
    bool isCheckIn = false,
  }) async {
    try {
      final location = await getCurrentPosition();

      final address = await getNameByLocation(location?.latitude, location?.longitude);
      final map = {
        'lineInspectId': lineInspectId,
        'substationInspectId': substationInspectId,
        'entityId': entityId ?? '',
        'longitude': location.longitude,
        'latitude': location.latitude,
        'address':address,
        'IsCheckIn':isCheckIn
      };

      await _provider.post('/location/send', map, isRequireAuth: requireAuth, backgroundMode: true);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<ServerResponse<SubstationAddressResponse>> getSubstationAddress(
      {String searchTerm,
        String userTeamId,
        String userGroupId,
        String entityId,
        int type,
        int page,
        bool backgroundMode}) async {
    final params = <String, dynamic>{
      'searchTerm' : searchTerm,
      'UserTeamId': userTeamId,
      'UserGroupId': userGroupId,
      'EntityId': entityId,
      'Type': type.toString(),
      'pageSize': '20',
      'pageIndex': '${page ?? 1}'
    };
    final data = await _provider.get('/location', params: params, isRequireAuth: true, backgroundMode: backgroundMode ?? false);
    final response = ServerResponse<SubstationAddressResponse>.fromJson(data);
    final substations = SubstationAddressResponse.fromJson(data);
    response.setData(substations);
    return response;
  }

  Future<ServerResponse<SubstationDetailLocation>> getSubstationDetail(String id) async {
    final data = await _provider.get('/location/$id', isRequireAuth: true, backgroundMode: false);
    final response = ServerResponse<SubstationDetailLocation>.fromJson(data);
    final substations = SubstationDetailLocation.fromJson(data['data']);
    response.setData(substations);
    return response;
  }

  Future<ServerResponse<LocationLineDetail>> getLocationLineDetail(String id) async {
    final data = await _provider.get('/location/line/$id', isRequireAuth: true, backgroundMode: false);
    final response = ServerResponse<LocationLineDetail>.fromJson(data);
    final substations = LocationLineDetail.fromJson(data['data']);
    response.setData(substations);
    return response;
  }
}

