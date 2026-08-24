// @dart=2.9
import 'package:g_json/g_json.dart';

class AbnormalHistoryModel {
  String id;
  String updatedDate;
  String updatedUser;
  String status;

  AbnormalHistoryModel(
      {this.id, this.updatedDate, this.updatedUser, this.status});

  AbnormalHistoryModel.fromJson(JSON json) {
    id = json['id'].string;
    updatedDate = json['updatedDate'].string;
    updatedUser = json['updatedUser'].string;
    status = json['status'].string;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['updatedDate'] = this.updatedDate;
    data['updatedUser'] = this.updatedUser;
    data['status'] = this.status;
    return data;
  }
}

