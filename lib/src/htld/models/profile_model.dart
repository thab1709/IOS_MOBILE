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
  String teamName;
  String teamId;
  String unitCode;

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
      this.teamName,
      this.teamId,
      this.appType,
      this.createdDate,
      this.userGroupId});

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
        json['permissions']?.listObject?.map((e) => JSON(e).string)?.toList() ?? [];
    roleNames =
        json['roleNames']?.listObject?.map((e) => JSON(e).string)?.toList() ?? [];
    dob = json['dob'].string;
    isAdministrator = json['isAdministrator'].boolean;
    isActived = json['isActived'].boolean;
    createdDate = json['createdDate'].string;
    appVersion = json['appVersion'].string;
    userGroup = json['userGroup'].string;
    userGroupId = json['userGroupId'].string;
    atLevel = json['atLevel'].string;
    teamName = json['teamName'].string;
    teamId = json['teamId'].string;
    unitCode = json['unitCode'].string;
    appType = json['appType'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
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
    map['teamName'] = teamName;
    map['teamId'] = teamId;
    map['appType'] = appType;
    map['unitCode'] = unitCode;

    return map;
  }

  bool isHasPermissionApproveConfirmSheet() {
    return permissions.contains('confirmSheetOfWorkLoad.confirm') ||
        permissions.contains('confirmSheetOfWorkLoad.reject');
  }

  bool isHasPermissionViewConfirmSheet() {
    return permissions.contains('confirmSheetOfWorkLoad.view');
  }

  bool isHasPermissionCreateConfirmSheet() {
    return permissions.contains('confirmSheetOfWorkLoad.update');
  }

  bool isHasPermissionDeleteConfirmSheet() {
    return permissions.contains('confirmSheetOfWorkLoad.delete');
  }

  bool isHasPermissionSendConfirmSheet() {
    return permissions.contains('confirmSheetOfWorkLoad.send_confirm');
  }

  bool isFormReportReject() {
    return permissions.contains('formReport.reject');
  }

  bool isFormReportApprove() {
    return permissions.contains('formReport.approve');
  }

  bool isFormReportRecall() {
    return permissions.contains('formReport.recall');
  }

  bool isFormReportDelete() {
    return permissions.contains('formReport.delete');
  }

  bool isFormReportSend() {
    return permissions.contains('formReport.send');
  }

  bool isFormReportCancel() {
    return permissions.contains('formReport.cancel');
  }

  bool isCaptionX5() {
    return unitCode == 'X05';
  }

  bool isHasCreateFormReport() {
    return permissions.contains('formReport.create');
  }

  bool isHasCreateCertificate() {
    return permissions.contains('certificate.create');
  }

  List<String> getAppVersion() {
    return appVersion.split(',').map((e) => e.trim()).toList();
  }
}

