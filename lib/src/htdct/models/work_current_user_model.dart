// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

class WorkCurrentUserModel {
  String id;
  String name;


  WorkCurrentUserModel(
      {this.id,
      this.name,
      });

  WorkCurrentUserModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
class WorkCurrentUserIntModel {
  String id;
  String name;


  WorkCurrentUserIntModel(
      {this.id,
        this.name,
      });

  WorkCurrentUserIntModel.fromJson(JSON json) {
    id = json['id'].toString();
    name = json['name'].string;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
