// @dart=2.9

import 'package:g_json/g_json.dart';

/// id : "745b0e70-50fa-48df-ba55-8cb664dffbe3"
/// type : 2
/// typeName : "Phiếu đêm"
/// substationName : "BỆNH VIỆN K (PD0100_TBA_0002047)"
/// code : "D60-2021/04/09"
/// inspectTime : "2021-04-09T14:47:26.000Z"
/// lastInspection : "0001-01-01T00:00:00.000Z"
/// inspectionRequest : "3 tháng/lần"
/// expireRemainingTime : "71:37:15"
/// immediaryInspectGeneralEquipmentModels : [{"equipmentId":"6e45fba1-9d4c-4271-8280-9dda79d96d4c","capatity":"220 kAV"},{"equipmentId":"c895652b-51f6-4097-8824-62ac75b86369","capatity":"440 kAV"},{"equipmentId":"33a56958-7e17-4e80-bfdc-ecce0841c13d","capatity":"440 kAV"},{"equipmentId":"28f9b318-5b6e-4388-84f5-cd46ad39e941","capatity":"110 kAV"}]

class GeneralDataModel {
  String id;
  int type;
  String typeName;
  String substationName;
  String code;
  String lineName;
  String inspectTime;
  String lastInspection;
  String inspectionRequest;
  String assetManagementUnit;
  String latestAbnormalPhenomenon;
  String substationKind;
  String temperature1;
  String weather1;
  String temperature2;
  String weather2;
  num expireRemainingTime;
  bool isGroupOne;
  List<ImmediaryInspectGeneralEquipmentModels> immediaryInspectGeneralEquipmentModels;

  GeneralDataModel(
      {this.id,
      this.type,
      this.typeName,
      this.substationName,
      this.code,
      this.lineName,
      this.inspectTime,
      this.lastInspection,
      this.inspectionRequest,
      this.assetManagementUnit,
      this.expireRemainingTime,
      this.immediaryInspectGeneralEquipmentModels,
      this.temperature1,
      this.temperature2,
      this.weather1,
      this.weather2
      });

  GeneralDataModel.fromJson(JSON data) {
      id = data['id']?.string;
      isGroupOne = data['isGroup1'].boolean ?? true;
      type = data['type']?.integer;
      temperature1 = data['temperature'].string;
      weather1 = data['weather'].string;
      weather2 = data['weather2'].string;
      temperature2 = data['temperature2'].string;
      typeName = data['typeName']?.string;
      substationName = data['substationName']?.string;
      code = data['code']?.string;
      lineName = data['lineName']?.string;
      inspectTime = data['inspectTime']?.string;
      lastInspection = data['lastInspection']?.string;
      inspectionRequest = data['inspectionRequest']?.string;
      assetManagementUnit = data['assetManagementUnit']?.string;
      latestAbnormalPhenomenon = data['latestAbnormalPhenomenon']?.string;
      substationKind = data['substationKind']?.string;
      expireRemainingTime = data['expireRemainingTime']?.integer;
      if (data['equipments'] != null) {
        final datas = data['equipments']?.listObject;
        immediaryInspectGeneralEquipmentModels = datas?.map((e) => ImmediaryInspectGeneralEquipmentModels.fromJson(JSON(e)))?.toList();
      }

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['temperature'] = temperature1;
    map['weather'] = weather1;
    map['weather2'] = weather2;
    map['temperature2'] = temperature2;
    map['id'] = id;
    map['type'] = type;
    map['typeName'] = typeName;
    map['substationName'] = substationName;
    map['code'] = code;
    map['lineName'] = lineName;
    map['inspectTime'] = inspectTime;
    map['lastInspection'] = lastInspection;
    map['inspectionRequest'] = inspectionRequest;
    map['assetManagementUnit'] = assetManagementUnit;
    map['expireRemainingTime'] = expireRemainingTime;
    map['substationKind'] = substationKind;
    map['isGroup1'] = isGroupOne;
    if (immediaryInspectGeneralEquipmentModels != null) {
      map['equipments'] = immediaryInspectGeneralEquipmentModels.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// equipmentId : "6e45fba1-9d4c-4271-8280-9dda79d96d4c"
/// capatity : "220 kAV"

class ImmediaryInspectGeneralEquipmentModels {
  String equipmentId;
  String capatity;
  String equipmentName;
  String equipmentCode;

  ImmediaryInspectGeneralEquipmentModels({
       this.equipmentId,
       this.capatity,
       this.equipmentName,
       this.equipmentCode,
  });

  ImmediaryInspectGeneralEquipmentModels.fromJson(JSON json) {
    equipmentId = json['equipmentId'].string;
    capatity = json['capatity'].string;
    equipmentName = json['equipmentName'].string;
    equipmentCode = json['equipmentCode'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['equipmentId'] = equipmentId;
    map['capatity'] = capatity;
    map['equipmentName'] = equipmentName;
    map['equipmentCode'] = equipmentCode;
    return map;
  }

}
