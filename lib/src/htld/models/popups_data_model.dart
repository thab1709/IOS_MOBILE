// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
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
  int abnormalCount;

  PopupsDataModel(
      {this.equipmentId,
      this.equipmentName,
      this.isSaved,
      this.inspectionCategory,
      this.abnormalCount});

  PopupsDataModel.fromJson(JSON json) {
    isAllowEdit = json['isAllowEdit'].boolean;
    equipmentId = json['equipmentId'].string;
    equipmentName = json['equipmentName'].string;
    equipmentCode = json['equipmentCode'].string;
    isSaved = json['isSaved']?.boolean ?? false;
    inspectionCategory = json['inspectionCategory'].integer;
    abnormalCount = json['abnormalCount']?.integer ?? 0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['equipmentId'] = equipmentId;
    map['equipmentName'] = equipmentName;
    map['equipmentCode'] = equipmentCode;
    map['isSaved'] = isSaved;
    map['isAllowEdit'] = isAllowEdit ?? true;
    map['inspectionCategory'] = inspectionCategory;
    map['abnormalCount'] = abnormalCount;
    return map;
  }

  String getPopupName() {
    if (equipmentCode == null) {
      return equipmentName;
    }
    return '$equipmentName ($equipmentCode)';
  }

  String getEndPoint() {
    switch (inspectionCategory) {
      case InspectionCategory.distributionTransformer:
        return 'substation';
        break;
      case InspectionCategory.distributionBreaker:
        return 'breaker';
        break;
      case InspectionCategory.distributionCapacitor:
        return 'low-voltage-capacito';
        break;
      case InspectionCategory.distributionConstructionStructure:
        return 'building-structure';
        break;
      case InspectionCategory.distributionCuttingMachine:
        return 'cutting-machine';
        break;
      case InspectionCategory.distributionFalloffFuse:
        return 'fall-off-fuses';
        break;
      case InspectionCategory.distributionGroundingSystem:
        return 'grounding-system';
        break;
      case InspectionCategory.distributionInsulation:
        return 'insulation';
        break;
      case InspectionCategory.distributionLightningConductor:
        return 'lightning-conductor';
        break;
      case InspectionCategory.distributionLowPressureCabinet:
        return 'low-pressure-cabinet';
        break;
      case InspectionCategory.distributionPowerCable:
        return 'power-cable';
        break;
      case InspectionCategory.distributionRMU:
        return 'rmu';
        break;
      case InspectionCategory.distributionSubstationRoom:
        return 'substation-room';
        break;
      case InspectionCategory.distributionTI:
        return 'ti';
        break;
      case InspectionCategory.distributionTU:
        return 'tu';
        break;
      case InspectionCategory.immediaryTransformer:
        return 'substation';
        break;
      case InspectionCategory.immediarySubstationRoom:
        return 'substation-room';
        break;
      case InspectionCategory.immediaryCuttingMachine:
        return 'cutting-machine';
        break;
      case InspectionCategory.immediaryRecloser:
        return 'recloser';
        break;
      case InspectionCategory.immediaryDisconnectorsSwitches:
        return 'disconnector-switches';
        break;
      case InspectionCategory.immediaryCutterLbs:
        return 'cutter-lbs';
        break;
      case InspectionCategory.immediaryFalloffFuse:
        return 'fall-of-fuse';
        break;
      case InspectionCategory.immediaryVariableVoltage:
        return 'variable-voltage';
        break;
      case InspectionCategory.immediaryCurrentTransformer:
        return 'current-transformer';
        break;
      case InspectionCategory.immediaryLightningConductor:
        return 'lightning-conductor';
        break;
      case InspectionCategory.immediaryCableHead:
        return 'cable-head';
        break;
      case InspectionCategory.immediaryInsulation:
        return 'insulation';
        break;
      case InspectionCategory.immediaryHighPressureCable:
        return 'high-pressure-cable';
        break;
      case InspectionCategory.immediaryPressureCable:
        return 'low-pressure-cable';
        break;
      case InspectionCategory.immediaryJoint:
        return 'joint';
        break;
      case InspectionCategory.immediaryOneWaySystem:
        return 'one-way-system';
        break;
      case InspectionCategory.immediaryAlternatingCurrentSystem:
        return 'alternating-current-system';
        break;
      case InspectionCategory.immediaryBattery:
        return 'battery';
        break;
      case InspectionCategory.immediaryFillingCabinet:
        return 'filling-cabinet';
        break;
      case InspectionCategory.immediaryGroundingSystem:
        return 'grounding-system';
        break;
      case InspectionCategory.immediaryMeasuringSystem:
        return 'measuring-system';
        break;
      case InspectionCategory.immediaryElectricCabinet:
        return 'electric-cabinet';
        break;
      case InspectionCategory.immediaryClampRow:
        return 'clamp-row';
        break;
      case InspectionCategory.immediaryRTD:
        return 'resistance-temperature-detector';
        break;
      case InspectionCategory.immediaryConstructionStructure:
        return 'construction-structure';
        break;
      case InspectionCategory.immediaryStationCleaning:
        return 'station-cleaning';
        break;
      case InspectionCategory.jointNightTime:
        return 'joint';
        break;
      case InspectionCategory.lightingSystemNightTime:
        return 'lighting-system';
        break;
      case InspectionCategory.substationNightTime:
        return 'substation';
        break;

      default:
        return 'substation';
    }
  }
}

