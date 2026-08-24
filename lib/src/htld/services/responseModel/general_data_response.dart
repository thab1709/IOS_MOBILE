// @dart=2.9
import 'package:evnmobile/src/htld/models/general_data_model.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:g_json/g_json.dart';

class GeneralDataResponse extends ServerResponse {
  GeneralDataResponse.fromJson(JSON json) : super.fromJson(json) {
    generalDataModel = GeneralDataModel.fromJson(json['data']);
  }
  GeneralDataModel generalDataModel;
}
