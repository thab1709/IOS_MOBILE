// @dart=2.9
import 'package:g_json/g_json.dart';

/// id : "69bd714f-9576-45ba-b5b7-f00649be00de"
/// name : "Administrator"
/// username : "admin@evn.com"
/// phoneNumber : "0374868675"
/// avatar : null
/// unitId : "244c2192-08ea-4879-a3d1-54435b3525ca"
/// unitName : "Công ty Thí nghiệm điện ĐL Hà Nội"
/// departmentId : "6ab51c92-0640-487b-9814-e9aba07a91fc"
/// departmentName : "Trung tâm Thí nghiệm"
/// permissions : ["all"]
/// roleNames : ["Administrator"]
/// dob : "2020-01-31T00:00:00.000Z"
/// isAdministrator : true
/// isActived : true
/// createdDate : null

class UserProfileModel {
  String id;
  String code;
  String name;
  String username;
  String phoneNumber;
  String avatar;
  String unitId;
  String unitName;
  String departmentId;
  String departmentName;
  int position;
  int positionId;
  int level;
  int appType;
  String positionName;
  List<String> permissions;
  List<String> roleNames;
  String dob;
  bool isAdministrator;
  bool isActived;
  String createdDate;
  String appVersion;
  String userGroup;
  String userGroupId;
  String atLevel;
  String userTeam;
  String teamId;
  String unitCode;
  bool isX6;

  UserProfileModel(
      {this.id,
      this.name,
      this.username,
      this.phoneNumber,
      this.avatar,
      this.unitId,
      this.unitName,
      this.departmentId,
      this.departmentName,
      this.permissions,
      this.roleNames,
      this.dob,
      this.isAdministrator,
      this.isActived,
      this.positionName,
      this.position,
      this.positionId,
      this.atLevel,
      this.level,
      this.userTeam,
      this.teamId,
      this.appType,
      this.userGroupId,
      this.createdDate,
      this.isX6});

  UserProfileModel.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    name = json['name'].string;
    username = json['username'].string;
    phoneNumber = json['phoneNumber'].string;
    avatar = json['avatar'].string;
    unitId = json['unitId'].string;
    position = json['position'].integer;
    positionId = json['positionId'].integer;
    level = json['level'].integer;
    unitName = json['unitName'].string;
    positionName = json['positionName'].string;
    departmentId = json['departmentId'].string;
    departmentName = json['departmentName'].string;
    permissions =
        json['permissions']?.listObject?.map((e) => JSON(e).string)?.toList();
    roleNames =
        json['roleNames']?.listObject?.map((e) => JSON(e).string)?.toList();
    dob = json['dob'].string;
    userGroupId = json['userGroupId'].string;
    isAdministrator = json['isAdministrator'].boolean;
    isActived = json['isActived'].boolean;
    createdDate = json['createdDate'].string;
    appVersion = json['appVersion'].string;
    userGroup = json['userGroup'].string;
    atLevel = json['atLevel'].string;
    userTeam = json['userTeam'].string;
    teamId = json['teamId'].string;
    unitCode = json['unitCode'].string;
    appType = json['appType'].integer;
    isX6 = json['isX6'].boolean;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['username'] = username;
    map['phoneNumber'] = phoneNumber;
    map['avatar'] = avatar;
    map['unitId'] = unitId;
    map['unitName'] = unitName;
    map['departmentId'] = departmentId;
    map['departmentName'] = departmentName;
    map['permissions'] = permissions;
    map['roleNames'] = roleNames;
    map['dob'] = dob;
    map['positionId'] = positionId;
    map['position'] = position;
    map['isAdministrator'] = isAdministrator;
    map['isActived'] = isActived;
    map['createdDate'] = createdDate;
    map['appVersion'] = appVersion;
    map['userGroup'] = userGroup;
    map['userGroupId'] = userGroupId;
    map['positionName'] = positionName;
    map['atLevel'] = atLevel;
    map['level'] = level;
    map['userTeam'] = userTeam;
    map['teamId'] = teamId;
    map['appType'] = appType;
    map['unitCode'] = unitCode;
    map['isX6'] = isX6;

    return map;
  }

  bool isStaff() {
    return roleNames.contains('X6 - Nhân viên') || position == 19;
  }

  bool isCaptain() {
    return roleNames.contains('Đội Trưởng');
  }

  bool isViewWork() {
    return permissions.contains('workX6.view') || permissions.contains('all');
  }

  bool isUpdateWork() {
    return permissions.contains('inspectionSheet.edit_mobile') ||
        permissions.contains('all');
    // return permissions.contains('workX6.update') || permissions.contains('all');
  }

  bool isCreateWork() {
    return permissions.contains('inspectionSheet.create_mobile') ||
        permissions.contains('all');
    // return permissions.contains('workX6.create') || permissions.contains('all');
  }

  bool isCreateOperationNote() {
    return permissions.contains('operationNote.create') ||
        permissions.contains('all') ||
        permissions.contains('inspectionNote.create');
  }

  bool isUpdateOperationNote() {
    return permissions.contains('operationNote.update') ||
        permissions.contains('all') ||
        permissions.contains('inspectionNote.update');
  }

  bool isDeleteOperationNote() {
    return permissions.contains('operationNote.delete') ||
        permissions.contains('all') ||
        permissions.contains('inspectionNote.delete');
  }

  List<String> getAppVersion() {
    return appVersion.split(',');
  }
}

