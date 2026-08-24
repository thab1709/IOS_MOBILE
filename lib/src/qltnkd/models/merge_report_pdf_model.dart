// @dart=2.9
import 'package:g_json/g_json.dart';

class MergeReportPDFModel {
  String reportNumber;
  String url;

  MergeReportPDFModel.fromJson(JSON json){
    reportNumber = json['reportNumber'].string;
    url = json['url'].string;
  }

  Map<String, dynamic> toJson() {
    final maps = <String, dynamic>{};

    maps['reportNumber'] = reportNumber;
    maps['url'] = url;

    return maps;
  }
}
