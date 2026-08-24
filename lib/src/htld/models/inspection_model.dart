// @dart=2.9
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

class InspectionModel {
  String id;
  String lastInspectTime;
  String code;
  String substationName;
  num statusCode;
  num totalAbnormal;
  String statusName;
  num inspectionTypeCode;
  String inspectionTypeName;
  String substationId;
  bool canEdit;
  bool canDelete;
  int color;
  num expireRemainingTime;

  InspectionModel(
      {this.id,
        this.lastInspectTime,
        this.code,
        this.substationName,
        this.statusCode,
        this.statusName,
        this.inspectionTypeCode,
        this.inspectionTypeName,
        this.substationId,
        this.canEdit,
        this.totalAbnormal,
        this.canDelete,
        this.color,
        this.expireRemainingTime});

  factory InspectionModel.fromJSON(JSON json) {
    return InspectionModel(id: json['id'].string,
        lastInspectTime: json['inspectTime']?.string,
        code: json['code']?.string,
        substationName: json['substationName']?.string,
        statusCode: json['statusCode']?.integer,
        totalAbnormal: json['totalAbnormal']?.integer,
        statusName: json['statusName']?.string,
        inspectionTypeCode: json['inspectionTypeCode']?.integer,
        inspectionTypeName: json['inspectionTypeName']?.string,
        substationId: json['substationId']?.string,
        canEdit: json['isAllowEdit']?.boolean,
        canDelete: json['isAllowDelete']?.boolean,
        expireRemainingTime: json['expireRemainingTime']?.integer,
        color: json['color'].integer
    );
  }

  Color getStatusColor() {
    switch (color) {
      case 1:
        return const Color(0xffffffff);
      case 2:
        return const Color(0xffffde7d);
      case 3:
        return const Color(0xfff5837a);

      default: return const Color(0xffffffff);
    }
  }
}


