// @dart=2.9
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:g_json/g_json.dart';

class GeneralInfoResponse extends ServerResponse {
  GeneralInfoResponse.fromJson(JSON json) : super.fromJson(json) {
    if (json != null) {
      ticketId = json['data'].stringValue;
    }
  }
  String ticketId;
}
