// @dart=2.9
import 'package:g_json/g_json.dart';

class TAbnormalHistoryModel {
  String id;
  String updatedDate;
  String updatedUser;
  String status;

  TAbnormalHistoryModel(
      {this.id, this.updatedDate, this.updatedUser, this.status});

  TAbnormalHistoryModel.fromJson(JSON json) {
    id = json['id'].string;
    updatedDate = json['updatedDate'].string;
    updatedUser = json['updatedUser'].string;
    status = json['status'].string;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['updatedDate'] = updatedDate;
    data['updatedUser'] = updatedUser;
    data['status'] = status;
    return data;
  }
}

