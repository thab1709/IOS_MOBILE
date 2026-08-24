// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../models/dashboard/abnormal_dashboard_model.dart';


class AbnormalDashboardResponse {
  AbnormalDashboardResponse.fromJson(JSON json){
    if (json != null) {
      model = AbnormalDashboardModel.fromJson(json['data'].mapObject);
    }
  }
  AbnormalDashboardModel model;
}
