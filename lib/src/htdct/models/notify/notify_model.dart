// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

import '../../common/constance/strings.dart';

class NotifyModel {
  static const type_sent = 1;
  static const type_inbox = 2;
  static const status_delivery = 0;
  static const status_seen = 1;
  static const report_type_operation_log = 13; // Sổ nhật ký vận hành

  String id;
  bool isRead;
  String createdDate;
  bool isSend;
  String description;
  String entityName;
  String date;
  String createTime;
  String workName;
  String lineInspectId;
  String substationInspectId;
  int workType;
  int totalRows;
  bool isPMIS;
  String nonInspectId;
  String workId;

  int categoryId;
  String ticketId;
  String equipmentId;
  bool isAbnormal;
  String equipmentName;
  String substationName;
  bool isDefault;
  int reportType;
  String checkOperationNoteId;

  NotifyModel({
    this.id,
    this.isRead,
    this.createdDate,
    this.isSend,
    this.description,
    this.date,
    this.createTime,
    this.workName,
    this.totalRows,
    this.lineInspectId,
    this.substationInspectId,
    this.workType,
    this.nonInspectId,
    this.isPMIS,
    this.workId,
    this.categoryId,
    this.ticketId,
    this.equipmentId,
    this.isAbnormal,
    this.equipmentName,
    this.substationName,
    this.isDefault,
    this.reportType,
    this.checkOperationNoteId,
  });

  NotifyModel.fromJson(JSON json) {
    id = json['id'].string;
    isRead = json['isRead'].boolean ?? false;
    createdDate = json['createdDate'].string;
    isSend = json['isSend'].boolean;
    description = json['description'].string;
    date = json['date'].string;
    createTime = json['createTime'].string;
    workName = json['workName'].string;
    lineInspectId = json['lineInspectId'].string;
    substationInspectId = json['substationInspectId'].string;
    workType = json['workType'].integer;
    totalRows = json['totalRows'].integer;
    nonInspectId = json['nonInspectId'].string;
    workId = json['workId'].string;
    isAbnormal = json['isAbnormal'].boolean;
    isPMIS = json['isPMIS'].boolean;
    categoryId = json['categoryId'].integer;
    ticketId = json['ticketId'].string;
    entityName = json['entityName'].string;
    equipmentId = json['equipmentId'].string;
    equipmentName = json['equipmentName'].string;
    substationName = json['substationName'].string;
    isDefault = json['isDefault'].boolean;
    reportType = json['reportType'].integer;
    checkOperationNoteId = json['checkOperationNoteId'].string;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isRead'] = this.isRead;
    data['createdDate'] = this.createdDate;
    data['isSend'] = this.isSend;
    data['description'] = this.description;
    data['date'] = this.date;
    data['createTime'] = this.createTime;
    data['workName'] = this.workName;
    data['totalRows'] = this.totalRows;
    data['reportType'] = this.reportType;
    data['entityName'] = this.entityName;
    data['checkOperationNoteId'] = this.checkOperationNoteId;
    return data;
  }

  String getCreateDate() => createdDate
      .fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmmss);
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

