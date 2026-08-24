// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/tba_general_info_model.dart';
import 'package:g_json/g_json.dart';


class TBAGeneralInfoResponse {
  TBAGeneralInfoResponse.fromJson(JSON json){
    if (json != null) {
      tbaGeneralInfoModel = TBAGeneralInfoModel.fromJson(json['data']);
    }
  }
  TBAGeneralInfoModel tbaGeneralInfoModel;
}
