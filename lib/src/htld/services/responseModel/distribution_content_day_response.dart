// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:g_json/g_json.dart';

class DistributionContentDayResponse {
  List<PopupsDataModel> popupsModel;
  String abnormalPhenomenon;
  String processed;
  bool substationRoom;
  bool groundingSystem;
  bool buildingStructure;


  DistributionContentDayResponse();

  DistributionContentDayResponse.fromJson(JSON json) {
    abnormalPhenomenon = json['abnormalPhenomenon']?.string;
    processed = json['processed']?.string;
    substationRoom = json['substationRoom']?.boolean;
    groundingSystem = json['groundingSystem']?.boolean;
    buildingStructure = json['buildingStructure']?.boolean;
    final equipmentsRaw = json['popups']?.list;
    final popupList = equipmentsRaw?.map((e) => PopupsDataModel.fromJson(e))?.toList() ?? <PopupsDataModel>[];
    popupsModel = remap(popupList);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['abnormalPhenomenon'] = abnormalPhenomenon ?? '';
    map['processed'] = processed ?? '';
    return map;
  }

  List<PopupsDataModel> remap(List<PopupsDataModel> popupsModel) {
    final substationRoom = PopupsDataModel(equipmentName: 'Buồng trạm biến áp', inspectionCategory: InspectionCategory.distributionSubstationRoom, isSaved: this.substationRoom ?? false, equipmentId: InspectionCategory.distributionSubstationRoom.toString());
    final groundingSysten = PopupsDataModel(equipmentName: 'Hệ thống nối đất', inspectionCategory: InspectionCategory.distributionGroundingSystem, isSaved: groundingSystem ?? false, equipmentId: InspectionCategory.distributionGroundingSystem.toString());
    final buildingStructure = PopupsDataModel(equipmentName: 'Kết cấu xây dựng', inspectionCategory: InspectionCategory.distributionConstructionStructure, isSaved: this.buildingStructure ?? false, equipmentId: InspectionCategory.distributionConstructionStructure.toString());
    final fixedPopups = [substationRoom, groundingSysten, buildingStructure];

    return popupsModel + fixedPopups;
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
