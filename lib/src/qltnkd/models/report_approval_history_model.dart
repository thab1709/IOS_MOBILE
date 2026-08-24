// @dart=2.9
import 'package:g_json/g_json.dart';

class ApprovalHistoryModel {
  String formReportId;
  String workId;
  String id;
  int totalRows;
  String type;
  String userId;
  String createdDate;
  String username;
  String note;



  ApprovalHistoryModel({this.formReportId, this.id, this.totalRows, this.workId,
    this.type, this.userId, this.createdDate, this.username});

  ApprovalHistoryModel.fromJson(JSON json) {
    formReportId = json['formReportId'].string;
    id = json['id'].string;
    totalRows = json['totalRows'].integer;
    type = json['type'].string;
    userId = json['userId'].string;
    createdDate = json['createdDate'].string;
    username = json['username'].string;
    note = json['note'].string;
    workId = json['workId'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['formReportId'] = formReportId;
    map['id'] = id;
    map['totalRows'] = totalRows;
    map['type'] = type;
    map['userId'] = userId;
    map['createdDate'] = createdDate;
    map['username'] = username;
    map['note'] = note;
    map['workId'] = workId;
    return map;
  }
}

