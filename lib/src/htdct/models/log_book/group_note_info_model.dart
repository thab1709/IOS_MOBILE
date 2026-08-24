// @dart=2.9
import 'package:g_json/g_json.dart';

class GroupCheckNoteInfoModel {
  String id;
  String dateCheck;
  String nameTeamCheck;
  String contentCheck;
  String componentTeamCheck;
  String commponentTeamChecked;
  String commentTeamCheck;
  String userGroupId;
  String userGroup;
  String substationId;
  String substation;
  String nameCheckTeam;
  List<UserCheck> userCheck;
  List<UserCheck> users;

  GroupCheckNoteInfoModel(
      {this.id,
        this.dateCheck,
        this.nameTeamCheck,
        this.contentCheck,
        this.componentTeamCheck,
        this.commponentTeamChecked,
        this.commentTeamCheck,
        this.userGroupId,
        this.userGroup,
        this.substationId,
        this.substation,
        this.nameCheckTeam,
        this.userCheck,
        this.users});

  GroupCheckNoteInfoModel.fromJson(JSON json) {
    id = json['id'].string;
    dateCheck = json['dateCheck'].string;
    nameTeamCheck = json['nameTeamCheck'].string;
    contentCheck = json['contentCheck'].string;
    componentTeamCheck = json['componentTeamCheck'].string;
    commponentTeamChecked = json['commponentTeamChecked'].string;
    commentTeamCheck = json['commentTeamCheck'].string;
    userGroupId = json['userGroupId'].string;
    userGroup = json['userGroup'].string;
    substationId = json['substationId'].string;
    substation = json['substation'].string;
    nameCheckTeam = json['nameCheckTeam'].string;

    if (json['userCheck'] != null) {
      final data = json['userCheck'].listObject;
      userCheck = data?.map((e) => UserCheck.fromJson(JSON(e)))?.toList();
    }else {
      userCheck = [];
    }

    if (json['users'] != null) {
      final data = json['users'].listObject;
      users = data?.map((e) => UserCheck.fromJson(JSON(e)))?.toList();
    }else {
      users = [];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateCheck'] = this.dateCheck;
    data['nameTeamCheck'] = this.nameTeamCheck;
    data['contentCheck'] = this.contentCheck;
    data['componentTeamCheck'] = this.componentTeamCheck;
    data['commponentTeamChecked'] = this.commponentTeamChecked;
    data['commentTeamCheck'] = this.commentTeamCheck;
    data['userGroupId'] = this.userGroupId;
    data['userGroup'] = this.userGroup;
    data['substationId'] = this.substationId;
    data['substation'] = this.substation;
    data['nameCheckTeam'] = this.nameCheckTeam;

    if (this.userCheck != null) {
      data['userCheck'] = userCheck.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['users'] = users.map((v) => v.toJson()).toList();

    }
    return data;
  }
}

class UserCheck {
  String name;
  String role;

  UserCheck({this.name, this.role});

  UserCheck.fromJson(JSON json) {
    name = json['name'].string;
    role = json['role'].string;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['name'] = this.name;
    data['role'] = this.role;
    return data;
  }
}

