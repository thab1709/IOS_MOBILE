// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/subtation_address.dart';
import 'package:g_json/g_json.dart';

class SubstationAddressResponse {
  SubstationAddressResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      locations = data?.map((e) => SubstationAddress.fromJson(JSON(e)))?.toList();
    }
  }
  List<SubstationAddress> locations;
  Paging paging;
}
