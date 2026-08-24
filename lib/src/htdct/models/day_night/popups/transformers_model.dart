// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class TransformersModel extends BaseHighElectricPopupModel {
  int checkBonded; //1.0 Kiểm tra ngoại Kết luận
  String checkBondedAbnormal;
  int chirp; // 1.1. Tiếng kêu của MBA
  String chirpAbnormal;
  int bodyCondition; // 1.2 Tình trạng thân vỏ
  String bodyConditionAbnormal;
  int statusTerminalsPorcelainSupportsMBA; // 1.3 Tình trạng các đầu cực, sứ đỡ các phía MBA
  String statusTerminalsPorcelainSupportsMBAAbnormal;
  String mbaOilLevel; // 1.4 MBA
  String oltcSetOilLevel; // 1.4 Bộ OLTC
  String oilLevelBreathingTank; // 1.4 Mức dầu ở cốc bình thở
  int mbaoltcOilLevel; // 1.4 Kết luận
  String mbaoltcOilLevelAbnormal;
  String desiccantParticleColorMBA; // 1.5 Màu sắc hạt hút ẩm kết luận(MBA)
  String desiccantParticleColorOLTC; // 1.5 Màu sắc hạt hút ẩm kết luận(Bộ QLTC)
  int desiccantParticleColor; // 1.5 Kết luận
  String desiccantParticleColorAbnormal;
  String stepCounterIndex; // 1.6 Chỉ số bộ đếm nấc
  String numberTimesSwitchSteps; // 1.6 Số lần chuyển nấc
  int conditionDriveCabinetOLTC; // 1.6 Kết luận
  String conditionDriveCabinetOLTCAbnormal;
  int statusControlCabinets; // 1.7.Tình trạng tủ điều khiển, tủ đấu dây tại MBA
  String statusControlCabinetsAbnormal;
  int statusGroundingSystemTransformer; // 1.8. Tình trạng hệ thống nối đất MBA
  String statusGroundingSystemTransformerAbnormal;
  int conditionCoolingFanSystem; //1.9
  String conditionCoolingFanSystemAbnormal;
  int conditionMBACirculatingOilSystem; // 1.10.Tình trạng Hệ thống bơm dầu tuần hoàn MBA (chỉ dành cho MBA AT1, AT2 E1.40)
  String conditionMBACirculatingOilSystemAbnormal;
  int checkFireProtectionSystem; // 1.11.Kiểm tra hệ thống PCCC
  String checkFireProtectionSystemAbnormal;
  int riskCausingOtherIncidents; // 1.12.Nguy cơ gây sự cố khác(vật liệu công trường, cây đổ, vật lạ bay vào trạm…)
  String riskCausingOtherIncidentsAbnormal;
  int mbaLoadTest; // 2. Kiểm tra tải MBA
  String mbaLoadTestAbnormal; // 2. Kiểm tra tải MBA
  double hiccup;
  double i;
  double u;
  double p;
  int operatingParameters; //2.1 Kết luận
  String operatingParametersAbnormal;
  int oilTemperature; // 3.0 Nhiệt độ dầu / cuộn dây (cao / trung / hạ) (ºC)
  String oilTemperatureAbnormal;
  double watchMBAFaceOil;
  double watchMBAFaceHigh;
  double watchMBAFaceMedium;
  double watchMBAFaceLow;
  int watchMBAFace; // 3.1 Kết luận
  String watchMBAFaceAbnormal;
  double mbaProtectionMeterOil;
  double mbaProtectionMeterHigh;
  double mbaProtectionMeterMedium;
  double mbaProtectionMeterLow;
  int mbaProtectionMeter; // 3.2 KL
  String mbaProtectionMeterAbnormal;
  double degreeDifferenceOil;
  double degreeDifferenceHigh;
  double degreeDifferenceMedium;
  double degreeDifferenceLow;
  int degreeDifference; // 3.3 Kết luận
  String degreeDifferenceAbnormal;

  TransformersModel({
    this.checkBonded,
    this.checkBondedAbnormal,
    this.chirp,
    this.chirpAbnormal,
    this.bodyCondition,
    this.bodyConditionAbnormal,
    this.statusTerminalsPorcelainSupportsMBA,
    this.statusTerminalsPorcelainSupportsMBAAbnormal,
    this.mbaOilLevel,
    this.oltcSetOilLevel,
    this.oilLevelBreathingTank,
    this.mbaoltcOilLevel,
    this.mbaoltcOilLevelAbnormal,
    this.desiccantParticleColorMBA,
    this.desiccantParticleColorOLTC,
    this.desiccantParticleColor,
    this.desiccantParticleColorAbnormal,
    this.stepCounterIndex,
    this.numberTimesSwitchSteps,
    this.conditionDriveCabinetOLTC,
    this.conditionDriveCabinetOLTCAbnormal,
    this.statusControlCabinets,
    this.statusControlCabinetsAbnormal,
    this.statusGroundingSystemTransformer,
    this.statusGroundingSystemTransformerAbnormal,
    this.conditionCoolingFanSystem,
    this.conditionCoolingFanSystemAbnormal,
    this.conditionMBACirculatingOilSystem,
    this.conditionMBACirculatingOilSystemAbnormal,
    this.checkFireProtectionSystem,
    this.checkFireProtectionSystemAbnormal,
    this.riskCausingOtherIncidents,
    this.riskCausingOtherIncidentsAbnormal,
    this.mbaLoadTest,
    this.mbaLoadTestAbnormal,
    this.hiccup,
    this.i,
    this.u,
    this.p,
    this.operatingParameters,
    this.operatingParametersAbnormal,
    this.oilTemperature,
    this.oilTemperatureAbnormal,
    this.watchMBAFaceOil,
    this.watchMBAFaceHigh,
    this.watchMBAFaceMedium,
    this.watchMBAFaceLow,
    this.watchMBAFace,
    this.watchMBAFaceAbnormal,
    this.mbaProtectionMeterOil,
    this.mbaProtectionMeterHigh,
    this.mbaProtectionMeterMedium,
    this.mbaProtectionMeterLow,
    this.mbaProtectionMeter,
    this.mbaProtectionMeterAbnormal,
    this.degreeDifferenceOil,
    this.degreeDifferenceHigh,
    this.degreeDifferenceMedium,
    this.degreeDifferenceLow,
    this.degreeDifference,
    this.degreeDifferenceAbnormal,
  }) : super(images: [], abnormals: []);

  TransformersModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    chirp = json['chirp'];
    chirpAbnormal = json['chirpAbnormal'];
    bodyCondition = json['bodyCondition'];
    bodyConditionAbnormal = json['bodyConditionAbnormal'];
    statusTerminalsPorcelainSupportsMBA =
        json['statusTerminalsPorcelainSupportsMBA'];
    statusTerminalsPorcelainSupportsMBAAbnormal =
        json['statusTerminalsPorcelainSupportsMBAAbnormal'];
    mbaOilLevel = json['mbaOilLevel'];
    oltcSetOilLevel = json['oltcSetOilLevel'];
    oilLevelBreathingTank = json['oilLevelBreathingTank'];
    mbaoltcOilLevel = json['mbaoltcOilLevel'];
    mbaoltcOilLevelAbnormal = json['mbaoltcOilLevelAbnormal'];
    desiccantParticleColorMBA = json['desiccantParticleColorMBA'];
    desiccantParticleColorOLTC = json['desiccantParticleColorOLTC'];
    desiccantParticleColor = json['desiccantParticleColor'];
    desiccantParticleColorAbnormal = json['desiccantParticleColorAbnormal'];
    stepCounterIndex = json['stepCounterIndex'];
    numberTimesSwitchSteps = json['numberTimesSwitchSteps'];
    conditionDriveCabinetOLTC = json['conditionDriveCabinetOLTC'];
    conditionDriveCabinetOLTCAbnormal =
        json['conditionDriveCabinetOLTCAbnormal'];
    statusControlCabinets = json['statusControlCabinets'];
    statusControlCabinetsAbnormal = json['statusControlCabinetsAbnormal'];
    conditionCoolingFanSystem = json['conditionCoolingFanSystem'];
    conditionCoolingFanSystemAbnormal =
        json['conditionCoolingFanSystemAbnormal'];
    statusGroundingSystemTransformer = json['statusGroundingSystemTransformer'];
    statusGroundingSystemTransformerAbnormal =
        json['statusGroundingSystemTransformerAbnormal'];
    conditionMBACirculatingOilSystem = json['conditionMBACirculatingOilSystem'];
    conditionMBACirculatingOilSystemAbnormal =
        json['conditionMBACirculatingOilSystemAbnormal'];
    checkFireProtectionSystem = json['checkFireProtectionSystem'];
    checkFireProtectionSystemAbnormal =
        json['checkFireProtectionSystemAbnormal'];
    riskCausingOtherIncidents = json['riskCausingOtherIncidents'];
    riskCausingOtherIncidentsAbnormal =
        json['riskCausingOtherIncidentsAbnormal'];
    mbaLoadTest = json['mbaLoadTest'];
    mbaLoadTestAbnormal = json['mbaLoadTestAbnormal'];
    hiccup = json['hiccup'];
    i = json['i'];
    u = json['u'];
    p = json['p'];
    operatingParameters = json['operatingParameters'];
    operatingParametersAbnormal = json['operatingParametersAbnormal'];
    oilTemperature = json['oilTemperature'];
    oilTemperatureAbnormal = json['oilTemperatureAbnormal'];
    watchMBAFaceOil = json['watchMBAFaceOil'];
    watchMBAFaceHigh = json['watchMBAFaceHigh'];
    watchMBAFaceMedium = json['watchMBAFaceMedium'];
    watchMBAFaceLow = json['watchMBAFaceLow'];
    watchMBAFace = json['watchMBAFace'];
    watchMBAFaceAbnormal = json['watchMBAFaceAbnormal'];
    mbaProtectionMeterOil = json['mbaProtectionMeterOil'];
    mbaProtectionMeterHigh = json['mbaProtectionMeterHigh'];
    mbaProtectionMeterMedium = json['mbaProtectionMeterMedium'];
    mbaProtectionMeterLow = json['mbaProtectionMeterLow'];
    mbaProtectionMeter = json['mbaProtectionMeter'];
    mbaProtectionMeterAbnormal = json['mbaProtectionMeterAbnormal'];
    degreeDifferenceOil = json['degreeDifferenceOil'];
    degreeDifferenceHigh = json['degreeDifferenceHigh'];
    degreeDifferenceMedium = json['degreeDifferenceMedium'];
    degreeDifferenceLow = json['degreeDifferenceLow'];
    degreeDifference = json['degreeDifference'];
    degreeDifferenceAbnormal = json['degreeDifferenceAbnormal'];
    description = json['description'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    } else {
      images = [];
    }
    if (json['abnormals'] != null) {
      abnormals = <Abnormals>[];
      json['abnormals'].forEach((v) {
        abnormals.add(Abnormals.fromJson(v));
      });
    } else {
      abnormals = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['checkBonded'] = checkBonded;
    data['checkBondedAbnormal'] = checkBondedAbnormal;
    data['chirp'] = chirp;
    data['chirpAbnormal'] = chirpAbnormal;
    data['bodyCondition'] = bodyCondition;
    data['bodyConditionAbnormal'] = bodyConditionAbnormal;
    data['statusTerminalsPorcelainSupportsMBA'] =
        statusTerminalsPorcelainSupportsMBA;
    data['statusTerminalsPorcelainSupportsMBAAbnormal'] =
        statusTerminalsPorcelainSupportsMBAAbnormal;
    data['mbaOilLevel'] = mbaOilLevel;
    data['oltcSetOilLevel'] = oltcSetOilLevel;
    data['oilLevelBreathingTank'] = oilLevelBreathingTank;
    data['mbaoltcOilLevel'] = mbaoltcOilLevel;
    data['mbaoltcOilLevelAbnormal'] = mbaoltcOilLevelAbnormal;
    data['desiccantParticleColorMBA'] = desiccantParticleColorMBA;
    data['desiccantParticleColorOLTC'] = desiccantParticleColorOLTC;
    data['desiccantParticleColor'] = desiccantParticleColor;
    data['desiccantParticleColorAbnormal'] = desiccantParticleColorAbnormal;
    data['stepCounterIndex'] = stepCounterIndex;
    data['numberTimesSwitchSteps'] = numberTimesSwitchSteps;
    data['conditionDriveCabinetOLTC'] = conditionDriveCabinetOLTC;
    data['conditionDriveCabinetOLTCAbnormal'] =
        conditionDriveCabinetOLTCAbnormal;
    data['statusControlCabinets'] = statusControlCabinets;
    data['statusControlCabinetsAbnormal'] = statusControlCabinetsAbnormal;
    data['statusGroundingSystemTransformer'] = statusGroundingSystemTransformer;
    data['statusGroundingSystemTransformerAbnormal'] =
        statusGroundingSystemTransformerAbnormal;
    data['conditionCoolingFanSystem'] = conditionCoolingFanSystem;
    data['conditionCoolingFanSystemAbnormal'] =
        conditionCoolingFanSystemAbnormal;
    data['conditionMBACirculatingOilSystem'] = conditionMBACirculatingOilSystem;
    data['conditionMBACirculatingOilSystemAbnormal'] =
        conditionMBACirculatingOilSystemAbnormal;
    data['checkFireProtectionSystem'] = checkFireProtectionSystem;
    data['checkFireProtectionSystemAbnormal'] =
        checkFireProtectionSystemAbnormal;
    data['riskCausingOtherIncidents'] = riskCausingOtherIncidents;
    data['riskCausingOtherIncidentsAbnormal'] =
        riskCausingOtherIncidentsAbnormal;
    data['mbaLoadTest'] = mbaLoadTest;
    data['mbaLoadTestAbnormal'] = mbaLoadTestAbnormal;
    data['hiccup'] = hiccup;
    data['i'] = i;
    data['u'] = u;
    data['p'] = p;
    data['operatingParameters'] = operatingParameters;
    data['operatingParametersAbnormal'] = operatingParametersAbnormal;
    data['oilTemperature'] = oilTemperature;
    data['oilTemperatureAbnormal'] = oilTemperatureAbnormal;
    data['watchMBAFaceOil'] = watchMBAFaceOil;
    data['watchMBAFaceHigh'] = watchMBAFaceHigh;
    data['watchMBAFaceMedium'] = watchMBAFaceMedium;
    data['watchMBAFaceLow'] = watchMBAFaceLow;
    data['watchMBAFace'] = watchMBAFace;
    data['watchMBAFaceAbnormal'] = watchMBAFaceAbnormal;
    data['mbaProtectionMeterOil'] = mbaProtectionMeterOil;
    data['mbaProtectionMeterHigh'] = mbaProtectionMeterHigh;
    data['mbaProtectionMeterMedium'] = mbaProtectionMeterMedium;
    data['mbaProtectionMeterLow'] = mbaProtectionMeterLow;
    data['mbaProtectionMeter'] = mbaProtectionMeter;
    data['mbaProtectionMeterAbnormal'] = mbaProtectionMeterAbnormal;
    data['degreeDifferenceOil'] = degreeDifferenceOil;
    data['degreeDifferenceHigh'] = degreeDifferenceHigh;
    data['degreeDifferenceMedium'] = degreeDifferenceMedium;
    data['degreeDifferenceLow'] = degreeDifferenceLow;
    data['degreeDifference'] = degreeDifference;
    data['degreeDifferenceAbnormal'] = degreeDifferenceAbnormal;
    data['description'] = getDescription();
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      data['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool validateData() {
    return checkBonded == null ||
        chirp == null ||
        bodyCondition == null ||
        statusTerminalsPorcelainSupportsMBA == null ||
        mbaOilLevel.isNullOrEmpty() ||
        oltcSetOilLevel.isNullOrEmpty() ||
        oilLevelBreathingTank.isNullOrEmpty() ||
        mbaoltcOilLevel == null ||
        desiccantParticleColorMBA.isNullOrEmpty() ||
        desiccantParticleColorOLTC.isNullOrEmpty() ||
        desiccantParticleColor == null ||
        stepCounterIndex.isNullOrEmpty() ||
        numberTimesSwitchSteps.isNullOrEmpty() ||
        conditionDriveCabinetOLTC == null ||
        statusControlCabinets == null ||
        statusGroundingSystemTransformer == null ||
        conditionCoolingFanSystem == null ||
        // conditionMBACirculatingOilSystem == null ||
        checkFireProtectionSystem == null ||
        riskCausingOtherIncidents == null ||
        mbaLoadTest == null ||
        hiccup == null ||
        i == null ||
        u == null ||
        p == null ||
        operatingParameters == null ||
        oilTemperature == null ||
        watchMBAFaceOil == null ||
        watchMBAFaceHigh == null ||
        watchMBAFaceMedium == null ||
        watchMBAFace == null ||
        mbaProtectionMeterOil == null ||
        mbaProtectionMeterHigh == null ||
        mbaProtectionMeterMedium == null ||
        mbaProtectionMeter == null ||
        degreeDifference == null;
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      switch (abnormal.categoryIndex) {
        case ImageProblems.muc1_1:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_2:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_3:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_4:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_5:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_6:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_7:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_8:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_9:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_10:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_11:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_12:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc2_1:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc3_1:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc3_2:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc3_3:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
      }
    });
  }
}

