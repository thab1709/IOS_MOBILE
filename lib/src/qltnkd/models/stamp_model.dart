// @dart=2.9
import 'package:g_json/g_json.dart';

class StampModel {
  StampModel({this.stampCode, this.formReportCode});

  StampModel.fromJson(JSON json) {
    stampCode = json['stampCode'].string;
    formReportCode = json['formReportCode'].string;
    formReportId = json['formReportId'].string;
  }

  Map<String, dynamic> toJson() {
    final maps = <String, dynamic>{};
    maps['stampCode'] = stampCode;
    maps['formReportCode'] = formReportCode;
    maps['formReportId'] = formReportId;
    return maps;
  }

  String stampCode;
  String formReportCode;
  String formReportId;
}

