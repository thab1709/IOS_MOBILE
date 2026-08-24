// @dart=2.9
import 'package:g_json/g_json.dart';

class PopupResponse {
  String data;
  String message;
  int statusCode;

  PopupResponse({this.data, this.message, this.statusCode});

  PopupResponse.fromJson(JSON json) {
    if(json?.value == null) {
      return;
    }
    data = json['data']?.toString();
    message = json['message']?.toString();
    statusCode = int.parse(json['statusCode']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final maps = <String, dynamic>{};
    maps['data'] = data;
    maps['message'] = message;
    maps['statusCode'] = statusCode;
    return maps;
  }
}

