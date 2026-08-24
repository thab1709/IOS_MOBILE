// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/models/transformer_model.dart';
import 'package:g_json/g_json.dart';


class DistributionContentNightResponse {
  List<TransformerModel> equipments;
  String abnormalPhenomenon;
  String processed;
  bool jointNightTime;
  bool lightingSystemNightTime;
  bool substationNightTime;
  List<PopupsDataModel> popupsModel = <PopupsDataModel>[];

  DistributionContentNightResponse(
      {this.equipments,
      this.abnormalPhenomenon,
      this.processed});

  DistributionContentNightResponse.fromJSON(JSON json) {
    abnormalPhenomenon = json['abnormalPhenomenon'].string;
    processed = json['processed'].string;
    jointNightTime = json['jointNightTime'].boolean;
    lightingSystemNightTime = json['lightingSystemNightTime'].boolean;
    substationNightTime = json['substationNightTime'].boolean;

    equipments = json['equipments']?.list?.map((e) => TransformerModel.fromJson(e))?.toList();
    popupsModel = createListPopup();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['abnormalPhenomenon'] = abnormalPhenomenon ?? '';
    map['processed'] = processed ?? '';
    return map;
  }

  Map<String, dynamic> toOfflineJson() {
    final map = <String, dynamic>{};
    map['abnormalPhenomenon'] = abnormalPhenomenon ?? '';
    map['processed'] = processed ?? '';
    map['equipments'] = equipments.map((e) => e.toJson()).toList();
    return map;
  }

  List<PopupsDataModel> createListPopup() {
    final substationRoom = PopupsDataModel(equipmentName: 'Trạm biến áp', inspectionCategory: InspectionCategory.substationNightTime, isSaved: substationNightTime ?? false, equipmentId: InspectionCategory.substationNightTime.toString());
    final groundingSystem = PopupsDataModel(equipmentName: 'Mối nối, tiếp xúc (khi tắt hệ thống chiếu sáng)', inspectionCategory: InspectionCategory.jointNightTime, isSaved: jointNightTime ?? false, equipmentId: InspectionCategory.jointNightTime.toString());
    final buildingStructure = PopupsDataModel(equipmentName: 'Hệ thống chiếu sáng', inspectionCategory: InspectionCategory.lightingSystemNightTime, isSaved: lightingSystemNightTime ?? false, equipmentId: InspectionCategory.lightingSystemNightTime.toString());
    final fixedPopups = [substationRoom, groundingSystem, buildingStructure];
    popupsModel.addAll(fixedPopups);
   return popupsModel;
  }

  bool validateData() {
    if (processed == null ||
        processed.isEmpty ||
        abnormalPhenomenon == null ||
        abnormalPhenomenon.isEmpty) {
      return false;
    }

    return true;
  }
}
