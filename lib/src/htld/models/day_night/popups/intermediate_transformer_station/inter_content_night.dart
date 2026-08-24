// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/temperature.dart';
import 'package:g_json/g_json.dart';

import '../../../intermediate_content.dart';
import '../../../popups_data_model.dart';

class IntermediateContentNightModel {
  List<InterEquipments> equipments;
  List<Temperature> temperatures;

  List<OutLines> outLines;
  String abnormalPhenomenon;
  String processed;
  List<PopupsDataModel> popupsModel;
  bool substation;
  bool joint;
  bool lightingSystem;

  IntermediateContentNightModel({this.equipments, this.outLines, this.abnormalPhenomenon, this.processed, this.popupsModel, this.temperatures});

  IntermediateContentNightModel.fromJson(JSON json) {
    if (json['equipments'] != null) {
      final data = json['equipments'].list;
      equipments = data?.map((e) => InterEquipments?.fromJson(JSON(e)))?.toList();
    }
    if (json['equipmentTemps'] != null) {
      final data = json['equipmentTemps'].list;
      temperatures = data?.map((e) => Temperature?.fromJson(JSON(e)))?.toList();
    }
    if (json['outlines'] != null) {
      final data = json['outlines'].list;
      outLines = data?.map((e) => OutLines.fromJson(JSON(e)))?.toList();
    }
    final equipmentsRaw = json['popups'].list;
    final popupList = equipmentsRaw?.map((e) => PopupsDataModel?.fromJson(e))?.toList() ?? <PopupsDataModel>[];
    abnormalPhenomenon = json['abnormalPhenomenon'].string;
    processed = json['processed'].string;
    substation = json['substation'].boolean;
    joint = json['joint'].boolean;
    lightingSystem = json['lightingSystem'].boolean;
    popupsModel = remap(popupList);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (equipments != null) {
      map['equipments'] = equipments.map((v) => v.toJson()).toList();
    }
    if (outLines != null) {
      map['outlines'] = outLines.map((v) => v.toJson()).toList();
    }
    if (temperatures != null) {
      map['equipmentTemps'] = temperatures.map((v) => v.toJson()).toList();
    }
    map['abnormalPhenomenon'] = abnormalPhenomenon;
    map['processed'] = processed;
    map['substation'] = substation;
    map['joint'] = joint;
    map['lightingSystem'] = lightingSystem;
    return map;
  }

  List<PopupsDataModel> remap(List<PopupsDataModel> popupsModel) {
    final substation = PopupsDataModel(equipmentName: 'Trạm biến áp',
        inspectionCategory: InspectionCategory.substationNightTime,
        isSaved: this.substation ?? false,
        equipmentId: InspectionCategory.substationNightTime.toString());
    final joint = PopupsDataModel(equipmentName: 'Mối nối, tiếp xúc  (khi tắt hệ thống chiếu sáng)',
        inspectionCategory: InspectionCategory.jointNightTime,
        isSaved: this.joint ?? false,
        equipmentId: InspectionCategory.jointNightTime.toString());
    final lightingSystem = PopupsDataModel(equipmentName: 'Hệ thống chiếu sáng',
        inspectionCategory: InspectionCategory.lightingSystemNightTime,
        isSaved: this.lightingSystem ?? false,
        equipmentId: InspectionCategory.lightingSystemNightTime.toString());

    final fixedPopups = [substation, joint, lightingSystem];

    return popupsModel + fixedPopups;
  }

  bool validateData() {
    if (
    abnormalPhenomenon == null || abnormalPhenomenon.isEmpty || processed == null || processed.isEmpty) {
      return false;
    }

    return true;
  }

}

