// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:g_json/g_json.dart';

/// equipmentId : "db1641ae-cdd5-4b2f-b812-84889eaeb957"
/// equipmentName : "Ngọa Long"
/// isSaved : false
/// inspectionCategory : 1

class PopupsDataModel {
  String equipmentId;
  String equipmentName;
  String equipmentCode;
  bool isSaved;
  bool isAllowEdit;
  int inspectionCategory;

  PopupsDataModel(
      {this.equipmentId,
      this.equipmentName,
      this.isSaved,
      this.inspectionCategory});

  PopupsDataModel.fromJson(JSON json) {
    isAllowEdit = json['isAllowEdit'].boolean;
    equipmentId = json['equipmentId'].string;
    equipmentName = json['equipmentName'].string;
    equipmentCode = json['equipmentCode'].string;
    isSaved = json['isSaved']?.boolean ?? false;
    inspectionCategory = json['inspectionCategory'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['equipmentId'] = equipmentId;
    map['equipmentName'] = equipmentName;
    map['equipmentCode'] = equipmentCode;
    map['isSaved'] = isSaved;
    map['isAllowEdit'] = isAllowEdit ?? true;
    map['inspectionCategory'] = inspectionCategory;
    return map;
  }

  String getPopupName() {
    if (equipmentCode == null) {
      return equipmentName;
    }
    return '$equipmentName ($equipmentCode)';
  }

}
