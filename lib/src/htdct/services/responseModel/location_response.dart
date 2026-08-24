// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../models/work_model.dart';
import '../../screens/worker_location/models/subtation_address.dart';

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
