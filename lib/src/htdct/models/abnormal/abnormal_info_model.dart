// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

import '../../common/constance/app_color.dart';

class AbnormalInfoModel {
  String id;
  String equipmentName;
  String abnormalDate;
  String category;
  String name;
  String description;
  String status;
  String date;

  String violate;
  String typeViolation;
  String timeViolate;
  String endViolate;
  String nameViolate;
  String statusViolate;
  bool isHandle;
  bool isAllowEdit;

  int violationType;

  AbnormalInfoModel(
      {this.id,
        this.equipmentName,
        this.abnormalDate,
        this.category,
        this.name,
        this.description,
        this.status,
        this.date,
        this.violate,
        this.typeViolation,
        this.timeViolate,
        this.endViolate,
        this.nameViolate,
        this.statusViolate,
        this.isHandle,
        this.violationType,
        this.isAllowEdit,
      });

  AbnormalInfoModel.fromJson(JSON json) {
    id = json['id'].string;
    equipmentName = json['equipmentName'].string;
    abnormalDate = json['abnormalDate'].string;
    category = json['category'].string;
    name = json['name'].string;
    description = json['description'].string;
    status = json['status'].string;
    date = json['date'].string;
    violate = json['violate'].string;
    typeViolation = json['typeViolation'].string;
    timeViolate = json['timeViolate'].string;
    endViolate = json['endViolate'].string;
    nameViolate = json['nameViolate'].string;
    statusViolate = json['statusViolate'].string;
    isHandle = json['isHandle'].boolean;
    isAllowEdit = json['isAllowEdit'].boolean;
    violationType = json['violationType'].integer;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['equipmentName'] = equipmentName;
    data['abnormalDate'] = abnormalDate;
    data['category'] = category;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['date'] = date;
    data['violate'] = violate;
    data['typeViolation'] = typeViolation;
    data['timeViolate'] = timeViolate;
    data['endViolate'] = endViolate;
    data['nameViolate'] = nameViolate;
    data['statusViolate'] = statusViolate;
    data['isAllowEdit'] = isAllowEdit;
    data['isHandle'] = isHandle;
    return data;
  }

  Color getColor() {
    if(status==null) {
      return HighElectricAppColor.redStatus;
    }
    return status.contains('Đã')?HighElectricAppColor.greenColor:HighElectricAppColor.redStatus;
  }

  bool isComplete()
  {
    return status!=null && status.contains('Đã');
  }

  String getStatusNameViolate() {
    return isHandle==true?'Đã xử lý':'Chưa xử lý';
  }


  Color getColorViolate() {
    return isHandle==true?HighElectricAppColor.greenColor:HighElectricAppColor.redStatus;
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

