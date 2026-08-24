// @dart=2.9
import 'package:g_json/g_json.dart';

class FormReportCopyModel {
  String id;
  String reportNumber;
  String location;
  String content;
  String formType;
  bool isMonitor;
  bool isChecked;

  FormReportCopyModel.fromJson(JSON json) {
    id = json['id'].string;
    reportNumber = json['reportNumber'].string;
    location = json['location'].string;
    content = json['content'].string;
    formType = json['formType'].string ?? json['formType'].integer?.toString() ?? json['reportType'].string ?? json['reportType'].integer?.toString() ?? json['workType'].string ?? json['workType'].integer?.toString();
    isMonitor = json['isMonitor'].boolean;
  }
}

