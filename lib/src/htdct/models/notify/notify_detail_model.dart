// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

import '../../common/constance/strings.dart';

class NotifyDetailModel {
  static const type_sent  = 1;
  static const type_inbox  = 2;
  static const status_delivery  = 0;
  static const status_seen   = 1;


  String id;
  String userSendId;
  String userSendName;
  List<UserGroups> userGroups;
  List<UserTeams> userTeams;
  List<Users> users;
  String createTime;
  String content;
  bool isSendGroup;
  String nameInboxStr;
  int status;
  int type;

  NotifyDetailModel(
      {this.id,
        this.userSendId,
        this.userSendName,
        this.userGroups,
        this.userTeams,
        this.users,
        this.createTime,
        this.content,
        this.isSendGroup,
        this.nameInboxStr,
        this.status,
        this.type});

  NotifyDetailModel.fromJson(JSON json) {

    id = json['id'].string;
    userSendId = json['userSendId'].string;
    userSendName = json['userSendName'].string;
    userGroups = [];
    json['userGroups'].list.forEach((element) {
      userGroups.add(UserGroups.fromJson(element));
    });
    userTeams = [];
    json['userTeams'].list.forEach((element) {
      userTeams.add(UserTeams.fromJson(element));
    });
    users = [];
    json['users'].list.forEach((element) {
      users.add(Users.fromJson(element));
    });
    createTime = json['createTime'].string;
    content = json['content'].string;
    isSendGroup = json['isSendGroup'].boolean;
    nameInboxStr = json['nameInboxStr'].string;
    status = json['status'].integer;
    type = json['type'].integer;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userSendId'] = this.userSendId;
    data['userSendName'] = this.userSendName;
    if (this.userGroups != null) {
      data['userGroups'] = this.userGroups.map((v) => v.toJson()).toList();
    }
    if (this.userTeams != null) {
      data['userTeams'] = this.userTeams.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    data['createTime'] = this.createTime;
    data['content'] = this.content;
    data['isSendGroup'] = this.isSendGroup;
    data['nameInboxStr'] = this.nameInboxStr;
    data['status'] = this.status;
    return data;
  }

  String getCreateDate() => createTime.fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmmss);

}

class UserTeams {
  String id;
  String name;

  UserTeams({this.id, this.name});

  UserTeams.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id']=id;
    data['name']=name;
  }
}
class Users {
  String id;
  String name;

  Users({this.id, this.name});

  Users.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id']=id;
    data['name']=name;
  }
}

class UserGroups {
  String id;
  String name;

  UserGroups({this.id, this.name});

  UserGroups.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id']=id;
    data['name']=name;
  }

}

