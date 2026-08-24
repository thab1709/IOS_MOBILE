// @dart=2.9
import 'package:g_json/g_json.dart';

class NotificationModel {
  String id;
  String content;
  String createdDate;

  NotificationModel({this.id, this.content, this.createdDate});

  factory NotificationModel.fromJson(JSON json) {
    return NotificationModel(
      id: json['id'].string,
      content: json['noti_content'].string,
      createdDate: json['createdDate'].string,
    );
  }
}

