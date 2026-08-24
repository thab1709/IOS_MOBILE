// @dart=2.9
import 'package:g_json/g_json.dart';

import 'confirm_mass_scene_schedules.dart';

class DetailWorkloadModel {
  DetailWorkloadModel({
    this.id,
    this.code,
    this.requestType,
    this.requestTypeName,
    this.status,
    this.unitId,
    this.unitName,
    this.date,
    this.location,
    this.username,
    this.userPosition,
    this.userRepresent,
    this.performer,
    this.performerPosition,
    this.performerRepresent,
    this.consultants,
    this.consultantsPosition,
    this.consultantsRepresent,
    this.consultantsImage,
    this.confirmMassSceneSchedules,});

  DetailWorkloadModel.fromJson(JSON json) {
    id = json['id'].string;
    code = json['code'].string;
    requestTypeName = json['code'].string;
    isAllowConfirm = json['isAllowConfirm'].boolean;
    requestType = json['requestType'].integer;
    status = json['status'].integer;
    unitId = json['unitId'].string;
    unitName = json['unitName'].string;
    date = json['date'].string;
    location = json['location'].string;
    username = json['username'].string;
    userPosition = json['userPosition'].string;
    userRepresent = json['userRepresent'].string;
    performer = json['performer'].string;
    performerPosition = json['performerPosition'].string;
    performerRepresent = json['performerRepresent'].string;
    consultants = json['consultants'].string;
    consultantsPosition = json['consultantsPosition'].string;
    consultantsRepresent = json['consultantsRepresent'].string;
    consultantsImage = json['ConsultantsImage'].string;
    isAllowSend = json['isAllowSend'].boolean;
    note = json['note'].string;
    if (json['confirmMassSceneSchedules'] != null) {
      confirmMassSceneSchedules = [];
      json['confirmMassSceneSchedules'].list.forEach((v) {
        confirmMassSceneSchedules.add(ConfirmMassSceneSchedules.fromJson(v));
      });
    } else {
      confirmMassSceneSchedules = [];
    }
  }
  String id;
  String code;
  bool isAllowConfirm;
  bool isAllowSend;
  int requestType;
  String requestTypeName;
  int status;
  String unitId;
  String unitName;
  String date;
  String location;
  String username;
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
  List<ConfirmMassSceneSchedules> confirmMassSceneSchedules;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['isAllowConfirm'] = isAllowConfirm;
    map['requestType'] = requestType;
    map['status'] = status;
    map['unitId'] = unitId;
    map['unitName'] = unitName;
    map['date'] = date;
    map['location'] = location;
    map['username'] = username;
    map['requestTypeName'] = requestTypeName;
    map['userPosition'] = userPosition;
    map['userRepresent'] = userRepresent;
    map['performer'] = performer;
    map['performerPosition'] = performerPosition;
    map['performerRepresent'] = performerRepresent;
    map['consultants'] = consultants;
    map['consultantsPosition'] = consultantsPosition;
    map['consultantsRepresent'] = consultantsRepresent;
    map['ConsultantsImage'] = consultantsImage;
    map['isAllowSend'] = isAllowSend;
    map['note'] = note;
    if (confirmMassSceneSchedules != null) {
      map['confirmMassSceneSchedules'] = confirmMassSceneSchedules.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Map<String, dynamic> toJsonUpdateSignature() {
    final map = <String, dynamic>{};
    map['requestType'] = requestType?.toString();
    map['unitName'] = unitName;
    map['date'] = date;
    map['location'] = location;
    map['username'] = username;
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
    if (confirmMassSceneSchedules != null) {
      map['schedules'] = confirmMassSceneSchedules.map((v) {
        return {
          'scheduleId': v.id,
          'reason': v.reason,
          'note': v.note,
          'isChecked': v.isChecked,
        };
      }).toList();
    }
    return map;
  }

}

