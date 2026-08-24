// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../models/dashboard/guarantee_electricity_model.dart';

class GuaranteeElectricityResponse {
  GuaranteeElectricityResponse.fromJson(JSON json){
    if (json != null) {
      model = GuaranteeElectricityModel.fromJson(json['data'].mapObject);
    }
  }
  GuaranteeElectricityModel model;
}
