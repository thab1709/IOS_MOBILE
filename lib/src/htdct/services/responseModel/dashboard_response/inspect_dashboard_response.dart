// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../models/dashboard/inspect_dashboard_model.dart';


class InspectDashboardResponse {
  InspectDashboardResponse.fromJson(JSON json){
    if (json != null) {
      model = InspectDashboardModel.fromJson(json['data'].mapObject);
    }
  }
  InspectDashboardModel model;
}
