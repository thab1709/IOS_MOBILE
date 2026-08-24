// @dart=2.9
import 'package:g_json/g_json.dart';

class PDFModel{
  String reportNumber;
  String link;

  PDFModel({this.reportNumber, this.link});

  PDFModel.fromJson(JSON json) {
    reportNumber = json['reportNumber'].string;
    link = json['link'].string;
  }
}
