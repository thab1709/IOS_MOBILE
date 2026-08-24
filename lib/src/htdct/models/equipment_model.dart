// @dart=2.9
import 'package:g_json/g_json.dart';


class EquipmentModel {
  String id;
  String name;
  String code;
  String substationName;
  int equipmentCategory;
  String equipmentCategoryEx;
  bool isChecked;
  bool isAllowEditOrCopy;
  bool isAllowLineCopy;
  bool isAllowSameLineCopy;
  bool isShowCheckBox;
  String sameLine;
  String prevent;
  List<String> listSameLine;

  EquipmentModel(
      {this.id = '',
      this.name = '',
      this.code = '',
      this.equipmentCategory,
      this.substationName,
      this.isAllowLineCopy,
      this.isAllowSameLineCopy,
      this.sameLine,
      this.listSameLine,
      this.isShowCheckBox,
      this.isAllowEditOrCopy = false,
      this.isChecked = false,
      this.prevent
      });

  EquipmentModel.fromJson(JSON json) {
    id = json['id'].stringValue;
    name = json['name'].stringValue;
    code = json['code'].stringValue;
    substationName = json['substationName'].stringValue;
    isAllowEditOrCopy = json['isAllowEditOrCopy'].boolean;
    isAllowLineCopy = json['isAllowLineCopy'].boolean;
    isAllowSameLineCopy = json['isAllowSameLineCopy'].boolean;
    sameLine = json['sameLine'].stringValue;
    prevent = json['prevent'].stringValue;
    if(sameLine!=null)
      {
        listSameLine = sameLine.split(';');
      }
    else
      {
        listSameLine = [];
      }
    isChecked = false;
    isShowCheckBox = isAllowSameLineCopy;
  }

  EquipmentModel copy() {
    return EquipmentModel(
      id: id,
      name: name,
      code: code,
      substationName: substationName,
      isAllowEditOrCopy: isAllowEditOrCopy,
      isAllowLineCopy: isAllowLineCopy,
      isAllowSameLineCopy: isAllowSameLineCopy,
      sameLine: sameLine,
      listSameLine: listSameLine,
      isChecked: false,
      isShowCheckBox: true,
    );
  }
}

