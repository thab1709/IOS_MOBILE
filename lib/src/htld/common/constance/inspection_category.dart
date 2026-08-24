// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';

import '../../models/option_model.dart';

class InspectionCategory {
  static const distributionSubstationRoom = 1;
  static const distributionTransformer = 2;
  static const distributionCuttingMachine = 3;
  static const distributionRMU = 4;
  static const distributionBreaker = 5;
  static const distributionFalloffFuse = 6;
  static const distributionLightningConductor = 7;
  static const distributionLowPressureCabinet = 8;
  static const distributionTI = 9;
  static const distributionTU = 10;
  static const distributionInsulation = 11;
  static const distributionCapacitor = 12;
  static const distributionPowerCable = 13;
  static const distributionGroundingSystem = 14;
  static const distributionConstructionStructure = 15;
  static const immediaryTransformer = 16;
  static const immediarySubstationRoom = 17;
  static const immediaryCuttingMachine = 18;
  static const immediaryRecloser = 19;
  static const immediaryDisconnectorsSwitches = 20;
  static const immediaryCutterLbs = 21;
  static const immediaryFalloffFuse = 22;
  static const immediaryVariableVoltage = 23;
  static const immediaryCurrentTransformer = 24;
  static const immediaryLightningConductor = 25;
  static const immediaryCableHead = 26;
  static const immediaryInsulation = 27;
  static const immediaryHighPressureCable = 28;
  static const immediaryPressureCable = 29;
  static const immediaryJoint = 30;
  static const immediaryOneWaySystem = 31;
  static const immediaryAlternatingCurrentSystem = 32;
  static const immediaryBattery = 33;
  static const immediaryFillingCabinet = 34;
  static const immediaryGroundingSystem = 35;
  static const immediaryMeasuringSystem = 36;
  static const immediaryElectricCabinet = 37;
  static const immediaryClampRow = 38;
  static const immediaryRTD = 39;
  static const immediaryConstructionStructure = 40;
  static const immediaryStationCleaning = 41;
  static const linePole = 42;
  static const lineBeam = 43;
  static const lineFundament = 44;
  static const lineWire = 45;
  static const lineInsulation = 46;
  static const lineRodGap = 47;
  static const lineLightningArrester = 48;
  static const lineEarthing = 49;
  static const lineDisconnectorsSwitch = 50;
  static const lineRecloser = 51;
  static const lineCuttingMachine = 52;
  static const lineRMU = 53;
  static const lineFuseCutOut = 54;
  static const lineCapacitor = 55;
  static const lineMeasureTheBoundary = 56;
  static const ineUndergroundCables = 57;
  static const lineTU = 58;
  static const lineTI = 59;
  static const lineBreaker = 60;
  static const jointNightTime = 200;
  static const lightingSystemNightTime = 201;
  static const substationNightTime = 202;

  static const lineRightsOfWay = 203;
  static const lineNightInsulation = 204;
  static const lineNightJoint = 205;
  static const lineNightWire = 206;

  static String getKeyLine(int category) {
    switch (category) {
      case linePole:
        return 'pole';
        break;
      case lineBeam:
        return 'beam';
        break;
      case lineFundament:
        return 'fundament';
        break;
      case lineWire:
        return 'wire';
        break;
      case lineInsulation:
        return 'insulation';
        break;
      case lineRodGap:
        return 'rod-gap';
        break;
      case lineLightningArrester:
        return 'lightning-arrester';
        break;
      case lineEarthing:
        return 'earthing';
        break;
      case lineDisconnectorsSwitch:
        return 'disconnectors-switch';
        break;
      case lineRecloser:
        return 'recloser';
        break;
      case lineCuttingMachine:
        return 'cutting-machine';
        break;
      case lineRMU:
        return 'rmu';
        break;
      case lineFuseCutOut:
        return 'fuse-cut-out';
        break;
      case lineCapacitor:
        return 'capacitor';
        break;
      case lineMeasureTheBoundary:
        return 'measure-boundary';
        break;
      case ineUndergroundCables:
        return 'underground-cables';
        break;
      case lineTU:
        return 'tu';
        break;
      case lineTI:
        return 'ti';
        break;
      case lineBreaker:
        return 'breaker';
        break;
      default:
        return '';
    }
  }

  static bool isLinePopup(int inspectionCategory) {
    return [
      linePole,
      lineBeam,
      lineFundament,
      lineWire,
      lineInsulation,
      lineRodGap,
      lineLightningArrester,
      lineEarthing,
      lineDisconnectorsSwitch,
      lineRecloser,
      lineCuttingMachine,
      lineRMU,
      lineFuseCutOut,
      lineCapacitor,
      lineMeasureTheBoundary,
      ineUndergroundCables,
      lineTU,
      lineTI,
      lineBreaker,
    ].contains(inspectionCategory);
  }

  static String getUpdateKeyLine(int category) {
    switch (category) {
      case linePole:
        return 'linePole';
        break;
      case lineBeam:
        return 'lineBeam';
        break;
      case lineFundament:
        return 'lineFundament';
        break;
      case lineWire:
        return 'lineWire';
        break;
      case lineInsulation:
        return 'lineInsulation';
        break;
      case lineRodGap:
        return 'lineRodGap';
        break;
      case lineLightningArrester:
        return 'lineLightningArrester';
        break;
      case lineEarthing:
        return 'lineEarthing';
        break;
      case lineDisconnectorsSwitch:
        return 'lineDisconnectorsSwitch';
        break;
      case lineRecloser:
        return 'lineRecloser';
        break;
      case lineCuttingMachine:
        return 'lineCuttingMachine';
        break;
      case lineRMU:
        return 'lineRmu';
        break;
      case lineFuseCutOut:
        return 'lineFuseCutOut';
        break;
      case lineCapacitor:
        return 'lineCapacitor';
        break;
      case lineMeasureTheBoundary:
        return 'lineMeasureBoundary';
        break;
      case ineUndergroundCables:
        return 'lineUndergroundCable';
        break;
      case lineTU:
        return 'lineTu';
        break;
      case lineTI:
        return 'lineTi';
        break;
      case lineBreaker:
        return 'lineBreaker';
        break;
      default:
        return '';
    }
  }

  static String getKeyDistributionDayModel(int category) {
    switch (category) {
      case distributionBreaker:
        return 'breaker';
        break;
      case distributionConstructionStructure:
        return 'buildingStructure';
        break;
      case distributionCuttingMachine:
        return 'cuttingMachine';
        break;
      case distributionGroundingSystem:
        return 'groundingSystem';
        break;
      case distributionPowerCable:
        return 'powerCable';
        break;
      case distributionFalloffFuse:
        return 'fallOffFuses';
        break;
      case distributionInsulation:
        return 'insulation';
        break;
      case distributionLightningConductor:
        return 'lightningConductor';
        break;
      case distributionLowPressureCabinet:
        return 'lowPressureCabinet';
        break;
      case distributionCapacitor:
        return 'lowVoltageCapacito';
        break;
      case distributionRMU:
        return 'rmu';
        break;
      case distributionTransformer:
        return 'substation';
        break;
      case distributionSubstationRoom:
        return 'substationRoom';
        break;
      case distributionTI:
        return 'ti';
        break;
      case distributionTU:
        return 'tu';
        break;

      default:
        return '';
    }
  }

  static List<OptionModel> getDisTechOrDay() {
    return [
      OptionModel('Tất cả', 0),
      OptionModel(getPopupName(distributionBreaker), distributionBreaker),
      OptionModel(getPopupName(distributionConstructionStructure),
          distributionConstructionStructure),
      OptionModel(
          getPopupName(distributionCuttingMachine), distributionCuttingMachine),
      OptionModel(getPopupName(distributionGroundingSystem),
          distributionGroundingSystem),
      OptionModel(getPopupName(distributionPowerCable), distributionPowerCable),
      OptionModel(
          getPopupName(distributionFalloffFuse), distributionFalloffFuse),
      OptionModel(getPopupName(distributionInsulation), distributionInsulation),
      OptionModel(getPopupName(distributionLightningConductor),
          distributionLightningConductor),
      OptionModel(getPopupName(distributionLowPressureCabinet),
          distributionLowPressureCabinet),
      OptionModel(getPopupName(distributionCapacitor), distributionCapacitor),
      OptionModel(getPopupName(distributionRMU), distributionRMU),
      OptionModel(
          getPopupName(distributionTransformer), distributionTransformer),
      OptionModel(
          getPopupName(distributionSubstationRoom), distributionSubstationRoom),
      OptionModel(getPopupName(distributionTU), distributionTU),
      OptionModel(getPopupName(distributionTI), distributionTI),
    ];
  }

  static String getPopupName(int category) {
    switch (category) {
      case InspectionCategory.lineBeam:
        return AppStrings.lineBeam;
        break;
      case InspectionCategory.lineCapacitor:
        return AppStrings.lineCapacitor;
        break;
      case InspectionCategory.lineCuttingMachine:
        return AppStrings.lineCuttingMachine;
        break;
      case InspectionCategory.lineDisconnectorsSwitch:
        return AppStrings.lineDisconnectorSwitch;
        break;
      case InspectionCategory.lineEarthing:
        return AppStrings.lineEarthing;
        break;
      case InspectionCategory.lineFundament:
        return AppStrings.lineFundament;
        break;
      case InspectionCategory.lineFuseCutOut:
        return AppStrings.lineFuseCutOut;
        break;
      case InspectionCategory.lineInsulation:
        return AppStrings.lineInsulation;
        break;
      case InspectionCategory.lineLightningArrester:
        return AppStrings.lineLightningArrester;
        break;
      case InspectionCategory.lineMeasureTheBoundary:
        return AppStrings.lineMeasureBoundaries;
        break;
      case InspectionCategory.ineUndergroundCables:
        return AppStrings.lineUndergroundCable;
        break;
      case InspectionCategory.linePole:
        return AppStrings.linePole;
        break;
      case InspectionCategory.lineRecloser:
        return AppStrings.lineRecloser;
        break;
      case InspectionCategory.lineRodGap:
        return AppStrings.lineRodRap;
        break;
      case InspectionCategory.lineWire:
        return AppStrings.lineWire;
        break;
      case InspectionCategory.lineRMU:
        return AppStrings.lineRMU;
        break;
      case InspectionCategory.lineTU:
        return AppStrings.lineTU;
        break;
      case InspectionCategory.lineTI:
        return AppStrings.lineTI;
        break;
      case InspectionCategory.lineBreaker:
        return AppStrings.lineBreaker;
        break;
      case distributionBreaker:
        return 'Cầu dao';
      case distributionConstructionStructure:
        return 'Kết cấu xây dựng';
      case distributionCuttingMachine:
        return 'Máy cắt';
      case distributionGroundingSystem:
        return 'Hệ thống nối đất';
      case distributionPowerCable:
        return 'Cáp lực, thanh dẫn';
      case distributionFalloffFuse:
        return 'Cầu chì tự rơi';
      case distributionInsulation:
        return 'Cách điện';
      case distributionLightningConductor:
        return 'Chống sét';
      case distributionLowPressureCabinet:
        return 'Tủ hạ áp';
      case distributionCapacitor:
        return 'Tụ bù';
      case distributionRMU:
        return 'RMU';
      case distributionTransformer:
        return 'Máy biến áp';
      case distributionSubstationRoom:
        return 'Buồng máy biến áp';
      case distributionTI:
        return 'TI';
      case distributionTU:
        return 'TU';
      case immediaryAlternatingCurrentSystem:
        return 'Hệ thống xoay chiều';
        break;
      case immediaryBattery:
        return 'Ắc quy';
        break;
      case immediaryCuttingMachine:
        return 'Máy cắt';
        break;
      case immediaryFillingCabinet:
        return 'Tủ nạp';
        break;
      case immediaryHighPressureCable:
        return 'Cáp lực cao áp';
        break;
      case immediaryCableHead:
        return 'Đầu cáp';
        break;
      case immediaryCutterLbs:
        return 'Dao cắt có tải LB';
        break;
      case immediaryDisconnectorsSwitches:
        return 'Dao cách ly';
        break;
      case immediaryElectricCabinet:
        return 'Tủ điện';
        break;
      case immediaryFalloffFuse:
        return 'Cầu chì tự rơi (FCO, LBFCO)';
        break;
      case immediaryStationCleaning:
        return 'Tình hình vệ sinh trạm Trung gian';
        break;
      case immediaryInsulation:
        return 'Cách điện';
        break;
      case immediaryLightningConductor:
        return 'Chống sét';
        break;
      case immediaryMeasuringSystem:
        return 'Hệ thống đo';
        break;
      case immediaryRTD:
        return 'Hệ thống RTĐ, tự dùng, chiếu sáng trạm Trung gian';
        break;
      case immediaryVariableVoltage:
        return 'Biến điện áp';
        break;
      case immediaryPressureCable:
        return 'Cáp lực hạ áp';
        break;
      case immediaryOneWaySystem:
        return 'Hệ thống 1 chiều';
        break;
      case immediaryRecloser:
        return 'Recloser';
        break;
      case immediaryCurrentTransformer:
        return 'Biến dòng điện';
        break;
      case immediaryTransformer:
        return 'Buồng trạm biến áp';
        break;
      case immediarySubstationRoom:
        return 'Hệ thống nối đất';
        break;
      case immediaryGroundingSystem:
        return 'Kết cấu xây dựng';
        break;
      case immediaryConstructionStructure:
        return 'Hàng kẹp và các đầu nối nhị thứ';
        break;
      case immediaryClampRow:
        return 'Mối nối';
        break;

      case jointNightTime:
        return 'Mối nối, tiếp xúc';
        break;

      case lightingSystemNightTime:
        return 'Hệ thống chiếu sáng';
        break;

      case substationNightTime:
        return 'Trạm biến áp';
        break;
      case lineRightsOfWay:
        return 'Hành lang tuyến';
        break;

      case lineNightInsulation:
        return 'Cách điện';
        break;

      case lineNightJoint:
        return 'Mối nối, mối lèo';
        break;
      case lineNightWire:
        return 'Dây dẫn';
        break;

      default:
        return '';
    }
  }

  static List<OptionModel> getLineTechOrDay() {
    return [
      OptionModel('Tất cả', 0),
      OptionModel(getPopupName(linePole), linePole),
      OptionModel(getPopupName(lineBeam), lineBeam),
      OptionModel(getPopupName(lineFundament), lineFundament),
      OptionModel(getPopupName(lineWire), lineWire),
      OptionModel(getPopupName(lineInsulation), lineInsulation),
      OptionModel(getPopupName(lineRodGap), lineRodGap),
      OptionModel(getPopupName(lineLightningArrester), lineLightningArrester),
      OptionModel(getPopupName(lineEarthing), lineEarthing),
      OptionModel(
          getPopupName(lineDisconnectorsSwitch), lineDisconnectorsSwitch),
      OptionModel(getPopupName(lineRecloser), lineRecloser),
      OptionModel(getPopupName(lineCuttingMachine), lineCuttingMachine),
      OptionModel(getPopupName(lineRMU), lineRMU),
      OptionModel(getPopupName(lineFuseCutOut), lineFuseCutOut),
      OptionModel(getPopupName(lineCapacitor), lineCapacitor),
      OptionModel(getPopupName(lineMeasureTheBoundary), lineMeasureTheBoundary),
      OptionModel(getPopupName(ineUndergroundCables), ineUndergroundCables),
      OptionModel(getPopupName(lineTU), lineTU),
      OptionModel(getPopupName(lineTI), lineTI),
      OptionModel(getPopupName(lineBreaker), lineBreaker),
      OptionModel(getPopupName(lineRightsOfWay), lineRightsOfWay),
    ];
  }

  static String getKeyDistributionNightModel(int category) {
    switch (category) {
      case jointNightTime:
        return 'jointNightTime';
        break;
      case lightingSystemNightTime:
        return 'lightingSystemNightTime';
        break;
      case substationNightTime:
        return 'substationNightTime';
        break;

      default:
        return '';
    }
  }

  static List<OptionModel> getDistributionNight() {
    return [
      OptionModel('Tất cả', 0),
      OptionModel(getPopupName(jointNightTime), jointNightTime),
      OptionModel(getPopupName(lightingSystemNightTime), lightingSystemNightTime),
      OptionModel(getPopupName(substationNightTime), substationNightTime),
    ];
  }

  static List<OptionModel> getIntermediateNight() {
    return [
      OptionModel('Tất cả', 0),
      OptionModel(getPopupName(jointNightTime), jointNightTime),
      OptionModel(getPopupName(lightingSystemNightTime), lightingSystemNightTime),
      OptionModel(getPopupName(substationNightTime), substationNightTime),
    ];
  }

  static List<OptionModel> getLineNight() {
    return [
      OptionModel('Tất cả', 0),
      OptionModel(getPopupName(lineNightWire), lineNightWire),
      OptionModel(getPopupName(lineNightJoint), lineNightJoint),
      OptionModel(getPopupName(lineNightInsulation), lineNightInsulation),
    ];
  }


  static List<OptionModel> getIntermediateDay() {
    return [
      OptionModel('Tất cả', 0),
      OptionModel(getPopupName(immediaryAlternatingCurrentSystem),
          immediaryAlternatingCurrentSystem),
      OptionModel(getPopupName(immediaryBattery), immediaryBattery),
      OptionModel(
          getPopupName(immediaryCuttingMachine), immediaryCuttingMachine),
      OptionModel(
          getPopupName(immediaryFillingCabinet), immediaryFillingCabinet),
      OptionModel(
          getPopupName(immediaryHighPressureCable), immediaryHighPressureCable),
      OptionModel(getPopupName(immediaryCableHead), immediaryCableHead),
      OptionModel(getPopupName(immediaryCutterLbs), immediaryCutterLbs),
      OptionModel(getPopupName(immediaryDisconnectorsSwitches),
          immediaryDisconnectorsSwitches),
      OptionModel(
          getPopupName(immediaryElectricCabinet), immediaryElectricCabinet),
      OptionModel(getPopupName(immediaryFalloffFuse), immediaryFalloffFuse),
      OptionModel(
          getPopupName(immediaryStationCleaning), immediaryStationCleaning),
      OptionModel(getPopupName(immediaryInsulation), immediaryInsulation),
      OptionModel(getPopupName(immediaryLightningConductor),
          immediaryLightningConductor),
      OptionModel(
          getPopupName(immediaryMeasuringSystem), immediaryMeasuringSystem),
      OptionModel(getPopupName(immediaryRTD), immediaryRTD),
      OptionModel(
          getPopupName(immediaryVariableVoltage), immediaryVariableVoltage),
      OptionModel(getPopupName(immediaryPressureCable), immediaryPressureCable),
      OptionModel(getPopupName(immediaryOneWaySystem), immediaryOneWaySystem),
      OptionModel(getPopupName(immediaryRecloser), immediaryRecloser),
      OptionModel(getPopupName(immediaryCurrentTransformer),
          immediaryCurrentTransformer),
      OptionModel(getPopupName(immediaryTransformer), immediaryTransformer),
      OptionModel('Buồng trạm biến áp', immediarySubstationRoom),
      OptionModel('Hệ thống nối đất', immediaryGroundingSystem),
      OptionModel('Kết cấu xây dựng', immediaryConstructionStructure),
      OptionModel('Hàng kẹp và các đầu nối nhị thứ', immediaryClampRow),
      OptionModel('Mối nối', immediaryJoint),
    ];
  }

  static String getKeyIntermediateDayModel(int category) {
    switch (category) {
      case immediaryAlternatingCurrentSystem:
        return 'alternatingCurrentSystem';
        break;
      case immediaryBattery:
        return 'battery';
        break;
      case immediaryConstructionStructure:
        return 'constructionStructure';
        break;
      case immediaryCuttingMachine:
        return 'cuttingMachine';
        break;
      case immediaryFillingCabinet:
        return 'fillingCabinet';
        break;
      case immediaryHighPressureCable:
        return 'highPressureCable';
        break;
      case immediaryCableHead:
        return 'cableHead';
        break;
      case immediaryClampRow:
        return 'clampRow';
        break;
      case immediaryCutterLbs:
        return 'cutterLbs';
        break;
      case immediaryDisconnectorsSwitches:
        return 'disconnectorsSwitches';
        break;
      case immediaryElectricCabinet:
        return 'electricCabinet';
        break;
      case immediaryFalloffFuse:
        return 'fallofFuse';
        break;
      case immediaryGroundingSystem:
        return 'groundingSystem';
        break;
      case immediaryStationCleaning:
        return 'stationCleaning';
        break;
      case immediaryInsulation:
        return 'insulation';
        break;
      case immediaryJoint:
        return 'joint';
        break;
      case immediaryLightningConductor:
        return 'lightningConductor';
        break;
      case immediaryMeasuringSystem:
        return 'measuringSystem';
        break;
      case immediaryRTD:
        return 'resistanceTemperatureDetector';
        break;
      case immediarySubstationRoom:
        return 'substationRoom';
        break;
      case immediaryVariableVoltage:
        return 'variableVoltage';
        break;
      case immediaryPressureCable:
        return 'lowPressureCable';
        break;
      case immediaryOneWaySystem:
        return 'oneWaySystem';
        break;
      case immediaryRecloser:
        return 'recloser';
        break;
      case immediaryCurrentTransformer:
        return 'currentTransformer';
        break;
      case immediaryTransformer:
        return 'substation';
        break;

      default:
        return '';
    }
  }

  static String getKeyIntermediateNightModel(int category) {
    switch (category) {
      case jointNightTime:
        return 'jointNightTime';
        break;
      case lightingSystemNightTime:
        return 'lightingSystemNightTime';
        break;
      case substationNightTime:
        return 'substationNightTime';
        break;

      default:
        return '';
    }
  }
}

