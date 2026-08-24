// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/location_line_detail.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/substation_detail_location.dart';
import 'package:evnmobile/src/htld/services/responseModel/location_response.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';

class LocationRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<SubstationAddressResponse>> getSubstationAddress(
      {String searchTerm,
      String unitId,
      String groupId,
      bool isLine,
      int page,
      bool backgroundMode}) async {
    final params = {
      'searchTerm': searchTerm,
      'unitId': "9eda1055-ab76-46bf-972e-60ee3d9e4ab3",
      'userGroup': groupId == '0' ? '' : groupId,
      'pageSize': '20',
      'pageIndex': '${page ?? 1}'
    };
    final data = await _provider.get(isLine ? '/location/line' : '/location',
        params: params,
        isRequireAuth: true,
        backgroundMode: backgroundMode ?? false);
    final response = ServerResponse<SubstationAddressResponse>.fromJson(data);
    final substations = SubstationAddressResponse.fromJson(data);
    response.setData(substations);
    return response;
  }

  void updateLocation(double lat, double long, String id) {
    if (id == null) {
      return;
    }
    final params = {'latitude': lat, 'longitude': long, 'entityId': id};
    _provider.post('/location/send', params,
        isRequireAuth: true, backgroundMode: true);
  }

  Future<ServerResponse<SubstationDetailLocation>> getSubstationDetail(
      String id) async {
    final data = await _provider.get('/location/$id',
        isRequireAuth: true, backgroundMode: true);
    final response = ServerResponse<SubstationDetailLocation>.fromJson(data);
    final substations = SubstationDetailLocation.fromJson(data['data']);
    response.setData(substations);
    return response;
  }

  Future<ServerResponse<LocationLineDetail>> getLocationLineDetail(
      String id) async {
    final data = await _provider.get('/location/line/$id',
        isRequireAuth: true, backgroundMode: true);
    final response = ServerResponse<LocationLineDetail>.fromJson(data);
    final substations = LocationLineDetail.fromJson(data['data']);
    response.setData(substations);
    return response;
  }
}

