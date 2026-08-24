// @dart=2.9
import 'package:evnmobile/src/htld/models/abnormal/attach_image_model.dart';
import 'package:g_json/g_json.dart';

class TAbnormalDetailModel {
  String abnormalId;
  String equipmentName;
  String equipmentCode;
  String equipmentId;
  String inspectId;
  String inspectCode;
  String lineId;
  String substationId;
  String lineBranchId;
  int status;
  String parentCategory;
  String childCategory;
  int categoryIndex;
  String description;
  String contentHandle;
  String dateHandle;
  String userHandleId;
  String userHandleName;
  List<TImages> images;
  String id;
  String name;
  String nodeNames;


  TAbnormalDetailModel(
      {this.abnormalId,
        this.equipmentName,
        this.equipmentCode,
        this.equipmentId,
        this.inspectId,
        this.inspectCode,
        this.lineId,
        this.substationId,
        this.lineBranchId,
        this.status,
        this.nodeNames,
        this.parentCategory,
        this.childCategory,
        this.categoryIndex,
        this.description,
        this.contentHandle,
        this.dateHandle,
        this.userHandleId,
        this.userHandleName,
        this.images,
        this.id,
        this.name});

  TAbnormalDetailModel.fromJson(Map<String, dynamic> json) {
    abnormalId = json['abnormalId'];
    equipmentName = json['equipmentName'];
    equipmentCode = json['equipmentCode'];
    equipmentId = json['equipmentId'];
    inspectId = json['inspectId'];
    nodeNames = JSON(json['nodeDetail'])?.list?.map((e) => e['name'].string)?.join(', ');

    inspectCode = json['inspectCode'];
    lineId = json['lineId'];
    substationId = json['substationId'];
    lineBranchId = json['lineBranchId'];
    status = json['status'];
    parentCategory = json['parentCategory'];
    childCategory = json['childCategory'];
    categoryIndex = json['categoryIndex'];
    description = json['description'];
    contentHandle = json['contentHandle'];
    dateHandle = json['dateHandle'];
    userHandleId = json['userHandleId'];
    userHandleName = json['userHandleName'];
    if (json['images'] != null) {
      images = <TImages>[];
      json['images'].forEach((v) {
        images.add(TImages.fromJsonNotMap(JSON(v)));
      });
    }
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['abnormalId'] = abnormalId;
    data['equipmentName'] = equipmentName;
    data['equipmentCode'] = equipmentCode;
    data['equipmentId'] = equipmentId;
    data['inspectId'] = inspectId;
    data['inspectCode'] = inspectCode;
    data['lineId'] = lineId;
    data['substationId'] = substationId;
    data['lineBranchId'] = lineBranchId;
    data['status'] = status;
    data['parentCategory'] = parentCategory;
    data['childCategory'] = childCategory;
    data['categoryIndex'] = categoryIndex;
    data['description'] = description;
    data['contentHandle'] = contentHandle;
    data['dateHandle'] = dateHandle;
    data['userHandleId'] = userHandleId;
    data['userHandleName'] = userHandleName;
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
