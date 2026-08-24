// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

class WorkModel {
  static const check_point_substation = 1;
  static const check_point_line = 2;
  static const check_point_unKnow = 3;

  String workId;
  String entityId;
  String pmisId;
  Entity entity;
  String line;
  String description;
  String planDate;
  String lastStartDate;
  String lastCompleteDate;
  int workStatus;
  String workStatusName;
  int workType;
  String workTypeName;
  List<UserGroups> userGroups;
  List<UserTeams> userTeams;
  bool isAllowEdit;
  bool isAllowDelete;
  bool isChecked;
  int checkPoint;
  String scheduleTypeName;
  List<Users> users;
  String name;
  int countFeedBack;
  bool hasAbnormal;
  int countAbnormal;

  WorkModel(
      {this.workId,
      this.entityId,
      this.pmisId,
      this.entity,
      this.line,
      this.description,
      this.planDate,
      this.lastStartDate,
      this.lastCompleteDate,
      this.workStatus,
      this.workStatusName,
      this.userGroups,
      this.userTeams,
      this.isAllowEdit,
      this.isAllowDelete,
      this.countFeedBack,
      this.hasAbnormal,
      this.countAbnormal});

  WorkModel.fromJson(JSON json) {
    workId = json['workId'].string;
    entityId = json['entityId'].string;
    pmisId = json['pmisId'].string;
    entity = json['entity'] != null ? Entity.fromJson(json['entity']) : null;
    line = json['line'].string;
    description = json['description'].string;
    planDate = json['planDate'].string;
    lastStartDate = json['lastStartDate'].string;
    lastCompleteDate = json['lastCompleteDate'].string;
    workStatus = json['workStatus'].integer;
    workStatusName = json['workStatusName'].string;
    workType = json['workType'].integer;
    workTypeName = json['workTypeName'].stringValue;
    userGroups = [];
    json['userGroups'].list.forEach((element) {
      userGroups.add(UserGroups.fromJson(element));
    });
    userTeams = [];
    json['userTeams'].list.forEach((element) {
      userTeams.add(UserTeams.fromJson(element));
    });
    isAllowEdit = json['isAllowEdit'].boolean;
    isAllowDelete = json['isAllowDelete'].boolean;
    isChecked = false;
    checkPoint =  json['checkPoint'].integer;
    scheduleTypeName = json['scheduleTypeName'].string;
    users = [];
    json['users'].list.forEach((element) {
      users.add(Users.fromJson(element));
    });
    name = json['name'].string;
    countFeedBack = json['countFeedBack'].integer??0;
    hasAbnormal = json['hasAbnormal'].boolean??false;
    countAbnormal = json['countAbnormal'].integer;
  }

  Color getColor() {
    switch (workStatus) {
      case 1:
        return HighElectricAppColor.redStatus;
      case 2:
        return HighElectricAppColor.orange2;
      case 3:
        return HighElectricAppColor.greenColor;
      default:
        return HighElectricAppColor.redStatus;
    }
  }
}

class Entity {
  String id;
  String code;
  String name;
  String substationKind;
  String nameUnsigned;
  String lineName;
  String latestInspectTime;
  String latestAbnormalPhenomenon;
  String assetManagementUnitName;
  double longitude;
  double latitude;
  double distance;



  Entity(
      {this.id,
      this.code,
      this.name,
      this.substationKind,
      this.nameUnsigned,
      this.lineName,
      this.latestInspectTime,
      this.latestAbnormalPhenomenon,
      this.assetManagementUnitName});

  String getName(TestType testType) {
    if (testType == TestType.subStation) {
      return 'TBA_$name';
    } else {
      return name;
    }
  }

  Entity.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    name = json['name'].string;
    substationKind = json['substationKind'].string;
    nameUnsigned = json['nameUnsigned'].string;
    lineName = json['lineName'].string;
    latestInspectTime = json['latestInspectTime'].string;
    latestAbnormalPhenomenon = json['latestAbnormalPhenomenon'].string;
    assetManagementUnitName = json['assetManagementUnitName'].string;
    final longitudeStr = json['longitude'].string;
    final latitudeStr = json['latitude'].string;
    distance = json['distance']?.ddouble ?? 0;

    longitude = double.parse(
        longitudeStr == null || longitudeStr.isEmpty
            ? '0'
            : longitudeStr);

    latitude = double.parse(
        latitudeStr == null || latitudeStr.isEmpty
            ? '0'
            : latitudeStr);
  }

  @override
  String toString() {
    return 'code: $code, name: $name, lineName: ${lineName ?? ''}';
  }
}

class UserTeams {
  String id;
  String name;

  UserTeams({this.id, this.name});

  UserTeams.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
  }
}
class Users {
  String id;
  String name;
  int userPosition;

  Users({this.id, this.name, this.userPosition});

  Users.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    userPosition = json['userPosition'].integer;
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
}

class Paging {
  Paging(
      {@required this.totalCount,
      @required this.pageIndex,
      @required this.pageSize,
      @required this.totalPages,
      this.completeCount,
      this.processingCount});

  factory Paging.fromJson(JSON json) {
    return Paging(
        totalCount: json['totalCount'].integer,
        completeCount: json['completeCount'].integer,
        processingCount: json['processingCount'].integer,
        pageIndex: json['pageIndex'].integer,
        pageSize: json['pageSize'].integer,
        totalPages: json['totalPages'].integer);
  }

  num totalCount;
  num completeCount;
  num processingCount;
  num pageIndex;
  num pageSize;
  num totalPages;

  bool isHasLoadMore() {
    if (pageIndex != null && totalPages != null) {
      return pageIndex < totalPages;
    }

    return false;
  }
}

