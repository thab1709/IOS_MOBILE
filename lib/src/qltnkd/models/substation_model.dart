// @dart=2.9
import 'package:g_json/g_json.dart';

class SubstationModel {
  String code;
  Object descriptions;
  Object from;
  String id;
  int inspectType;
  bool isDeleted;
  bool isSystem;
  String name;
  String nameUnsigned;
  Object parentLineName;
  String unitName;
  List<Object> userGroup;
  List<Object> userManagements;

  SubstationModel(
      {this.code,
      this.descriptions,
      this.from,
      this.id,
      this.inspectType,
      this.isDeleted,
      this.isSystem,
      this.name,
      this.nameUnsigned,
      this.parentLineName,
      this.unitName,
      this.userGroup,
      this.userManagements});

  SubstationModel.fromJson(JSON json) {
    code = json['code'].string;
    descriptions = json['descriptions'].string;
    from = json['from'].string;
    id = json['id'].string;
    inspectType = json['inspectType'].integer;
    isDeleted = json['isDeleted'].boolean;
    isSystem = json['isSystem'].boolean;
    name = json['name'].string;
    nameUnsigned = json['nameUnsigned'].string;
    parentLineName = json['parentLineName'].string;
    unitName = json['unitName'].string;
    userGroup = json['userGroup'].listObject;
    userManagements = json['userManagements'].listObject;
  }
}

