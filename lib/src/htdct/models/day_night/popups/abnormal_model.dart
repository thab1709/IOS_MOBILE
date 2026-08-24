// @dart=2.9
import 'package:g_json/g_json.dart';

class Abnormals {
  String id; // id bất thường
  String abnormalId; // mã loại bất thường
  String description; // bất thường
  int categoryIndex; //loại mục
  String parentCategory; // tên mục cha
  String childCategory; // tên mục con
  int abnormalType; // phân loại bất thường

  Abnormals({
    this.id,
    this.abnormalId,
    this.description,
    this.categoryIndex,
    this.parentCategory,
    this.childCategory,
    this.abnormalType,
  });

  Abnormals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    abnormalId = json['abnormalId'];
    description = json['description'];
    categoryIndex = json['categoryIndex'];
    parentCategory = json['parentCategory'];
    childCategory = json['childCategory'];
    abnormalType = json['abnormalType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['abnormalId'] = this.abnormalId;
    data['description'] = this.description;
    data['categoryIndex'] = this.categoryIndex;
    data['parentCategory'] = this.parentCategory;
    data['childCategory'] = this.childCategory;
    data['abnormalType'] = this.abnormalType;

    return data;
  }

  Abnormals.fromJsonNotMap(JSON json) {
    id = json['id'].string;
    abnormalId = json['abnormalId'].string;
    description = json['description'].string;
    categoryIndex = json['categoryIndex'].integer;
    parentCategory = json['parentCategory'].string;
    childCategory = json['childCategory'].string;
    abnormalType = json['abnormalType'].integer;
  }
}

