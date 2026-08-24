// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

import '../../../htdct/common/constance/app_color.dart';

class TAbnormalInfoModel {
  String id;
  String equipmentName;
  int inspectionCategory;
  String abnormalDate;
  String category;
  String name;
  String description;
  String nodeNames;
  String status;
  String date;

  bool isHandle;

  TAbnormalInfoModel({
    this.id,
    this.equipmentName,
    this.abnormalDate,
    this.category,
    this.name,
    this.description,
    this.inspectionCategory,
    this.status,
    this.date,
    this.isHandle,
  });

  TAbnormalInfoModel.fromJson(JSON json) {
    id = json['id'].string;
    equipmentName = json['equipmentName'].string;
    abnormalDate = json['abnormalDate'].string;
    category = json['category'].string;
    name = json['name'].string;
    nodeNames = JSON(json['nodeDetail'])?.listObject?.map((e) => JSON(e['name']).string)?.join(', ');
    description = json['description'].string;
    inspectionCategory = json['inspectionCategory'].integer;
    status = json['status'].string;
    date = json['dateHandle'].string;
    isHandle = json['isHandle'].boolean;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['equipmentName'] = equipmentName;
    data['abnormalDate'] = abnormalDate;
    data['category'] = category;
    data['name'] = name;
    data['description'] = description;
    data['inspectionCategory'] = inspectionCategory;
    data['status'] = status;
    data['dateHandle'] = date;
    data['isHandle'] = isHandle;
    return data;
  }

  Color getColor() {
    if (status == null) {
      return HighElectricAppColor.redStatus;
    }
    return status.contains('Đã')
        ? HighElectricAppColor.greenColor
        : HighElectricAppColor.redStatus;
  }

  bool isComplete() {
    return status != null && status.contains('Đã');
  }

  String getStatusNameViolate() {
    return isHandle == true ? 'Đã xử lý' : 'Chưa xử lý';
  }

  Color getColorViolate() {
    return isHandle == true
        ? HighElectricAppColor.greenColor
        : HighElectricAppColor.redStatus;
  }
}

class Paging {
  Paging(
      {this.totalCount,
      this.pageIndex,
      this.pageSize,
      this.totalPages,
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

