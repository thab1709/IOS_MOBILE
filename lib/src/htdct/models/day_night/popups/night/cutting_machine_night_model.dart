// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../abnormal_model.dart';
import '../images_model.dart';

class CuttingMachineNightModel extends BaseHighElectricPopupModel {
  CuttingMachineNightModel() : super(images: [], abnormals: []);

  int checkBonded;
  int mcLocation;
  int mc;
  int tdl;
  int synchronizing;
  int frequency;
  int f87;
  int statusLocks;
  String statusLocksAbnormal;

  int operatingStatus;
  String operationSeparationDate;
  int operatingStatusResult;
  String operatingStatusResultAbnormal;

  int disclosureType;

  double apDelivered;
  double apReceive;
  double aqDelivered;
  double aqReceive;

  double apDeliveredOld = 10;
  double apReceiveOld = 10;
  double aqDeliveredOld = 10;
  double aqReceiveOld = 10;

  int powerIndicator;
  String powerIndicatorAbnormal;

  int checkAbnormalDischarge;
  String checkAbnormalDischargeAbnormal;
  double n;
  int cutCounterIndex;
  String cutCounterIndexAbnormal;

  int indoorDistributionRoom;
  int distributionRoomStatus;
  String distributionRoomStatusAbnormal;
  int otherAbnormal;
  String otherAbnormalText;
  int unusualClassification;

  CuttingMachineNightModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    mcLocation = json['mcLocation'];
    mc = json['mc'];
    tdl = json['tdl'];
    synchronizing = json['synchronizing'];
    frequency = json['frequency'];
    f87 = json['f87'];
    statusLocks = json['statusLocks'];
    statusLocksAbnormal = json['statusLocksAbnormal'];
    operatingStatus = json['operatingStatus'];
    operationSeparationDate = json['operationSeparationDate'];
    operatingStatusResult = json['operatingStatusResult'];
    operatingStatusResultAbnormal = json['operatingStatusResultAbnormal'];
    disclosureType = json['disclosureType'];
    apDelivered = json['apDelivered'];
    apReceive = json['apReceive'];
    aqDelivered = json['aqDelivered'];
    aqReceive = json['aqReceive'];
    powerIndicator = json['powerIndicator'];
    powerIndicatorAbnormal = json['powerIndicatorAbnormal'];
    checkAbnormalDischarge = json['checkAbnormalDischarge'];
    checkAbnormalDischargeAbnormal = json['checkAbnormalDischargeAbnormal'];
    n = json['n'];
    cutCounterIndex = json['cutCounterIndex'];
    cutCounterIndexAbnormal = json['cutCounterIndexAbnormal'];
    indoorDistributionRoom = json['indoorDistributionRoom'];
    distributionRoomStatus = json['distributionRoomStatus'];
    distributionRoomStatusAbnormal = json['distributionRoomStatusAbnormal'];
    otherAbnormal = json['otherAbnormal'];
    otherAbnormalText = json['otherAbnormalText'];
    unusualClassification = json['unusualClassification'];

    description = json['description'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
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

  Map toJson() {
    final maps = {};
    maps['checkBonded'] = checkBonded;
    maps['mcLocation'] = mcLocation;
    maps['mc'] = mc;
    maps['tdl'] = tdl;
    maps['synchronizing'] = synchronizing;
    maps['frequency'] = frequency;
    maps['f87'] = f87;
    maps['statusLocks'] = statusLocks;
    maps['statusLocksAbnormal'] = statusLocksAbnormal;
    maps['operatingStatus'] = operatingStatus;
    maps['operationSeparationDate'] = operationSeparationDate;
    maps['operatingStatusResult'] = operatingStatusResult;
    maps['operatingStatusResultAbnormal'] = operatingStatusResultAbnormal;
    maps['disclosureType'] = disclosureType;
    maps['apDelivered'] = apDelivered;
    maps['apReceive'] = apReceive;
    maps['aqDelivered'] = aqDelivered;
    maps['aqReceive'] = aqReceive;
    maps['powerIndicator'] = powerIndicator;
    maps['powerIndicatorAbnormal'] = powerIndicatorAbnormal;
    maps['checkAbnormalDischarge'] = checkAbnormalDischarge;
    maps['checkAbnormalDischargeAbnormal'] = checkAbnormalDischargeAbnormal;
    maps['n'] = n;
    maps['cutCounterIndex'] = cutCounterIndex;
    maps['cutCounterIndexAbnormal'] = cutCounterIndexAbnormal;
    maps['indoorDistributionRoom'] = indoorDistributionRoom;
    maps['distributionRoomStatus'] = distributionRoomStatus;
    maps['distributionRoomStatusAbnormal'] = distributionRoomStatusAbnormal;
    maps['otherAbnormal'] = otherAbnormal;
    maps['otherAbnormalText'] = otherAbnormalText;
    maps['unusualClassification'] = unusualClassification;

    maps['description'] = getDescription();
    if (images != null) {
      maps['images'] = images.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      maps['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return maps;
  }

  @override
  bool validateData() {
    return ![
      checkBonded,
      mcLocation,
      mc,
      tdl,
      synchronizing,
      frequency,
      f87,
      statusLocks,
      operatingStatus,
      operatingStatusResult,
      disclosureType,
      powerIndicator,
      checkAbnormalDischarge,
      n,
      cutCounterIndex,
      indoorDistributionRoom,
      distributionRoomStatus,
      otherAbnormal,
      // apDelivered,
      // apReceive,
      // aqDelivered,
      // aqReceive,
    ].contains(null);
  }

  bool validateDataCopy() {
    return ![
      checkBonded,
      mcLocation,
      mc,
      tdl,
      synchronizing,
      frequency,
      f87,
      statusLocks,
      operatingStatus,
      operatingStatusResult,
      disclosureType,
      powerIndicator,
      checkAbnormalDischarge,
      cutCounterIndex,
      indoorDistributionRoom,
      distributionRoomStatus,
      otherAbnormal,
      // apDelivered,
      // apReceive,
      // aqDelivered,
      // aqReceive,
    ].contains(null);
  }

  double getSpDelivered() {
    if (apDeliveredOld == null) {
      return apDelivered;
    } else {
      return apDelivered - apDeliveredOld;
    }
  }

  double getSpReceive() {
    if (apReceiveOld == null) {
      return apReceive;
    } else {
      return apReceive - apReceiveOld;
    }
  }

  double getSqDelivered() {
    if (aqDeliveredOld == null) {
      return aqDelivered;
    } else {
      return aqDelivered - aqDeliveredOld;
    }
  }

  double getSqReceive() {
    if (aqReceiveOld == null) {
      return aqReceive;
    } else {
      return aqReceive - aqReceiveOld;
    }
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      switch (abnormal.categoryIndex) {
        case ImageProblems.muc1_1:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_2:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_5:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_6:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc2_1:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc2_2:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
      }
    });
  }
}

