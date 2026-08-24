// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

class EquipmentModel {
  String id;
  String code;
  String name;
  String nodeName;
  String lineName;
  String capacity;
  num inspectionCategory;
  String inspectionCategoryName;
  bool isChecked;
  bool isUsed;
  String groupId;
  //if is equipment
  String nodeId;

  EquipmentModel({
    @required this.id,
    this.code,
    this.name,
    this.nodeName,
    this.capacity,
    this.lineName,
    this.inspectionCategory,
    this.inspectionCategoryName,
    this.isUsed = false,
    this.isChecked = false,
    this.groupId,
    this.nodeId,
  });

  factory EquipmentModel.fromJson(JSON json) {
    return EquipmentModel(
      id: json['id'].string,
      code: json['code'].string,
      nodeName: json['nodeName'].string,
      name: json['name'].string,
      nodeId: json['nodeId'].string,
      lineName: json['lineName'].string,
      isUsed: json['isUsed'].boolean,
      isChecked:  json['isChecked']?.boolean ?? json['isUsed']?.boolean ?? false,
      capacity: json['capacity'].string,
      inspectionCategory: json['inspectionCategory'].integer,
      inspectionCategoryName: json['inspectionCategoryName'].string,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': id,
      'code': code,
      'name': name,
      'nodeName': nodeName,
      'capacity': capacity,
      'inspectionCategory': inspectionCategory,
      'inspectionCategoryName': inspectionCategoryName,
      'isChecked': isChecked,
      'isUsed': isUsed,
      'lineName': lineName,
      'groupId': groupId,
      'nodeId': nodeId,
    } as Map<String, dynamic>;
  }

  EquipmentModel copy() {
    return EquipmentModel(
        id: id,
        code: code,
        name: name,
        isChecked: isChecked,
        groupId: groupId,
        nodeName: nodeName,
        lineName: lineName,
        nodeId: nodeId);
  }

  String getNameNodeLine({@required bool isAllBranch}){
    if(isAllBranch){
      return '$lineName - $name';
    } else {
      return '$code - $name';
    }
  }

  String getTextSearch({@required bool isAllBranch}){
    if(isAllBranch){
      return lineName;
    } else {
      return code;
    }
  }
}

