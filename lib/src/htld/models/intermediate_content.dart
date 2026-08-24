// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:g_json/g_json.dart';

/// equipments : [{"equipmentId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","uc":"string","uh":"string","ic":"string","pc":"string","ih":"string","ph":"string"}]
/// outLines : [{"outLineName":"string","ia":"string","ib":"string","ic":"string","p":"string"}]
/// abnormalPhenomenon : "string"
/// processed : "string"

class IntermediateContentModel  {
  List<InterEquipments> equipments;
  List<OutLines> outLines;
  String abnormalPhenomenon;
  String processed;
  List<PopupsDataModel> popupsModel;
  bool substationRoom;
  bool joint;
  bool groundSystem;
  bool clampRow;
  bool constructionStructure;
  // ignore: avoid_setters_without_getters
  set setEquipments(List<InterEquipments> value) {
    equipments = value;
  }
  // ignore: avoid_setters_without_getters
  set setOutLines(List<OutLines> value) {
    outLines = value;
  }
  IntermediateContentModel({this.equipments, this.outLines, this.abnormalPhenomenon, this.processed, this.popupsModel});

  IntermediateContentModel.fromJson(JSON json) {
    if (json['equipments'] != null) {
      final data = json['equipments'].list;
      equipments = data?.map((e) => InterEquipments?.fromJson(JSON(e)))?.toList();
    }
    if (json['outlines'] != null) {
      final data = json['outlines'].list;
      outLines = data?.map((e) => OutLines.fromJson(JSON(e)))?.toList();
    }

    final equipmentsRaw = json['popups'].list;
    final popupList = equipmentsRaw?.map((e) => PopupsDataModel?.fromJson(e))?.toList() ?? <PopupsDataModel>[];
    abnormalPhenomenon = json['abnormalPhenomenon'].string;
    processed = json['processed'].string;
    substationRoom = json['substationRoom'].boolean;
    joint = json['joint'].boolean;
    groundSystem = json['groundSystem'].boolean;
    clampRow = json['clampRow'].boolean;
    constructionStructure = json['constructionStructure'].boolean;
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

    map['abnormalPhenomenon'] = abnormalPhenomenon;
    map['processed'] = processed;
    map['substationRoom'] = substationRoom;
    map['joint'] = joint;
    map['groundSystem'] = groundSystem;
    map['clampRow'] = clampRow;
    map['constructionStructure'] = constructionStructure;
    return map;
  }

  List<PopupsDataModel> remap(List<PopupsDataModel> popupsModel) {
    final substationRoom = PopupsDataModel(equipmentName: 'Buồng trạm biến áp', inspectionCategory: InspectionCategory.immediarySubstationRoom, isSaved: this.substationRoom ?? false, equipmentId: InspectionCategory.immediarySubstationRoom.toString());
    final groundingSysten = PopupsDataModel(equipmentName: 'Hệ thống nối đất', inspectionCategory: InspectionCategory.immediaryGroundingSystem, isSaved: groundSystem ?? false, equipmentId: InspectionCategory.immediaryGroundingSystem.toString());
    final buildingStructure = PopupsDataModel(equipmentName: 'Kết cấu xây dựng', inspectionCategory: InspectionCategory.immediaryConstructionStructure, isSaved: constructionStructure ?? false, equipmentId: InspectionCategory.immediaryConstructionStructure.toString());
    final clampRow = PopupsDataModel(equipmentName: 'Hàng kẹp và các đầu nối nhị thứ', inspectionCategory: InspectionCategory.immediaryClampRow, isSaved: this.clampRow ?? false, equipmentId: InspectionCategory.immediaryClampRow.toString());
    final joint = PopupsDataModel(equipmentName: 'Mối nối', inspectionCategory: InspectionCategory.immediaryJoint, isSaved: this.joint ?? false, equipmentId: InspectionCategory.immediaryJoint.toString());
    final fixedPopups = [substationRoom, groundingSysten, buildingStructure, clampRow, joint];

    return popupsModel + fixedPopups;
  }

  bool validateData() {
    if (abnormalPhenomenon == null ||
        abnormalPhenomenon.isEmpty ||
        processed == null ||
        processed.isEmpty) {
      return false;
    }

    if (equipments.firstWhere((element) => element.validateData() == false, orElse:() => null) != null) {
      return false;
    }

    return true;
  }
}

/// outLineName : "string"
/// ia : "string"
/// ib : "string"
/// ic : "string"
/// p : "string"

class OutLines {
  String outLineName;
  String ia;
  String ib;
  String ic;
  String p;

  OutLines({this.outLineName, this.ia, this.ib, this.ic, this.p});

  OutLines.fromJson(JSON json) {
    outLineName = json['outlineName'].string;
    ia = json['ia'].string;
    ib = json['ib'].string;
    ic = json['ic'].string;
    p = json['p'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['outlineName'] = outLineName;
    map['ia'] = ia;
    map['ib'] = ib;
    map['ic'] = ic;
    map['p'] = p;
    return map;
  }

}

/// equipmentId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// uc : "string"
/// uh : "string"
/// ic : "string"
/// pc : "string"
/// ih : "string"
/// ph : "string"

class InterEquipments {
  String equipmentId;
  String equipmentName;
  String uc;
  String uh;
  String ic;
  String pc;
  String ih;
  String ph;

  InterEquipments(
      {this.equipmentId, this.equipmentName, this.uc, this.uh, this.ic, this.pc, this.ih, this.ph});

  InterEquipments.fromJson(JSON json) {
    equipmentId = json['equipmentId'].string;
    equipmentName = json['equipmentName'].string;
    uc = json['uc'].string;
    uh = json['uh'].string;
    ic = json['ic'].string;
    pc = json['pc'].string;
    ih = json['ih'].string;
    ph = json['ph'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['equipmentId'] = equipmentId;
    map['equipmentName'] = equipmentName;
    map['uc'] = uc;
    map['uh'] = uh;
    map['ic'] = ic;
    map['pc'] = pc;
    map['ih'] = ih;
    map['ph'] = ph;
    return map;
  }

  bool validateData() {
    if (equipmentId == null ||
        equipmentId.isEmpty ||

        uc == null ||
        uc.isEmpty ||

        uh == null ||
        uh.isEmpty ||

        ic == null ||
        ic.isEmpty ||

        pc == null ||
        pc.isEmpty ||

        ih == null ||
        ih.isEmpty ||

        ph == null ||
        ph.isEmpty ||

        equipmentName == null ||
        equipmentName.isEmpty) {
      return false;
    }

    return true;
  }

}
