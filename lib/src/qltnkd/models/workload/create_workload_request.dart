// @dart=2.9

import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:g_json/g_json.dart';

class WorkloadRequestModel {
  WorkloadRequestModel({
    this.requestId,
    this.date,
    this.username,
    this.userPosition,
    this.userRepresent,
    this.performer,
    this.performerPosition,
    this.performerRepresent,
    this.consultants,
    this.consultantsPosition,
    this.consultantsRepresent,
    this.schedules,
  });

  List<Schedules> schedules = [];
  String requestId;
  String date;
  String username;
  String location;
  String userPosition;
  String userRepresent;
  String performer;
  String performerPosition;
  String performerRepresent;
  String consultants;
  String consultantsPosition;
  String consultantsRepresent;
  String consultantsImage;
  String note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (schedules != null) {
      map['schedules'] = schedules.map((v) => v.toJson()).toList();
    }
    map['requestId'] = requestId;
    map['date'] = date;
    map['username'] = username;
    map['location'] = location;
    map['userPosition'] = userPosition;
    map['userRepresent'] = userRepresent;
    map['performer'] = performer;
    map['performerPosition'] = performerPosition;
    map['performerRepresent'] = performerRepresent;
    map['consultants'] = consultants;
    map['consultantsPosition'] = consultantsPosition;
    map['consultantsRepresent'] = consultantsRepresent;
    map['ConsultantsImage'] = consultantsImage;
    map['consultantsImage'] = consultantsImage;
    map['note'] = note;
    return map;
  }

  Map<String, dynamic> toJsonUpdate() {
    final map = <String, dynamic>{};
    if (schedules != null) {
      map['schedules'] = schedules.map((v) => v.toJson()).toList();
    }
    map['username'] = username;
    map['location'] = location;
    map['date'] = date;
    map['userPosition'] = userPosition;
    map['userRepresent'] = userRepresent;
    map['performer'] = performer;
    map['performerPosition'] = performerPosition;
    map['performerRepresent'] = performerRepresent;
    map['consultants'] = consultants;
    map['consultantsPosition'] = consultantsPosition;
    map['consultantsRepresent'] = consultantsRepresent;
    map['ConsultantsImage'] = consultantsImage;
    map['consultantsImage'] = consultantsImage;
    map['note'] = note;
    return map;
  }

  String validate() {
    // if(location.isNullOrEmpty()) {
    //   return 'Vui lòng nhập địa điểm';
    // }
    if(username.isNullOrEmpty()) {
      return 'Vui lòng nhập tên người đại diện bên đơn vị quản lý';
    }

    if(userPosition.isNullOrEmpty()) {
      return 'Vui lòng nhập chức vụ người đại diện bên đơn vị quản lý';
    }
    if(date.isNullOrEmpty()) {
      return 'Vui lòng nhập ngày thực hiện';
    }

    if(userRepresent.isNullOrEmpty()) {
      return 'Vui lòng nhập đại diện bên đơn vị quản lý';
    }

    if(performer.isNullOrEmpty()) {
      return 'Vui lòng nhập tên người đại diện bên thực hiện';
    }

    if(performerPosition.isNullOrEmpty()) {
      return 'Vui lòng nhập chức vụ người đại diện bên thực hiện';
    }

    // if(consultants.isNullOrEmpty()) {
    //   return 'Vui lòng nhập tên người đại diện bên tư vấn';
    // }
    //
    // if(consultantsPosition.isNullOrEmpty()) {
    //   return 'Vui lòng nhập chức vụ người đại diện bên tư vấn';
    // }
    //
    // if(consultantsRepresent.isNullOrEmpty()) {
    //   return 'Vui lòng nhập đại diện bên tư vấn';
    // }

    return null;
  }
}

class Schedules {
  Schedules({
    this.scheduleId,
    this.reason,
    this.note,
  });

  Schedules.fromJson(JSON json) {
    scheduleId = json['scheduleId'].string;
    reason = json['reason'].string;
    note = json['note'].string;
  }

  String scheduleId;
  String reason;
  String note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['scheduleId'] = scheduleId;
    if(reason?.isEmpty == true) {
      reason = null;
    }
    map['reason'] = reason;
    map['note'] = note;
    return map;
  }
}


