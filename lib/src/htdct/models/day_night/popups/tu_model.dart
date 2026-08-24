// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class TUModel extends BaseHighElectricPopupModel {
  int voltageEachPhase; // 1. Điện áp từng pha
  String voltageEachPhaseAbnormal;
  double urole; // Urole
  double uMeter; // U Công tơ
  int operatingCurrent; // Kết luận
  String operatingCurrentAbnormal;
  double degreeDifference; // 1.2.Mức độ chênh lệch
  double p; // P
  int checkBonded; //Kiểm tra ngoại quan
  String checkBondedAbnormal;
  int tuLocation; // Vị trí TI
  int insulationOilLevelStatus; // 2.1.Tình trạng mức dầu cách điện
  int insulationClassificationGISCompartment; //phân loại cách điện
  String insulationOilLevelStatusAbnormal;
  int insulationClassification; //2.2 Phân loại cách điện
  int gasPressurSF6; // Kết luận
  String gasPressurSF6Abnormal;
  int conditionContactsTerminalsInsulators; // 2.3.Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
  String conditionContactsTerminalsInsulatorsAbnormal;
  int groundingStatus; // 2.4.Tình trạng nối đất
  String groundingStatusAbnormal;
  int unusualClassification;

  TUModel({
    this.voltageEachPhase,
    this.voltageEachPhaseAbnormal,
    this.urole,
    this.uMeter,
    this.operatingCurrent,
    this.operatingCurrentAbnormal,
    this.degreeDifference,
    this.p,
    this.checkBonded,
    this.checkBondedAbnormal,
    this.tuLocation,
    this.insulationOilLevelStatus,
    this.insulationOilLevelStatusAbnormal,
    this.insulationClassificationGISCompartment,
    this.insulationClassification,
    this.gasPressurSF6,
    this.gasPressurSF6Abnormal,
    this.conditionContactsTerminalsInsulators,
    this.conditionContactsTerminalsInsulatorsAbnormal,
    this.groundingStatus,
    this.groundingStatusAbnormal,
    this.unusualClassification,
  }) : super(images: [], abnormals: []);

  TUModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    voltageEachPhase = json['voltageEachPhase'];
    voltageEachPhaseAbnormal = json['voltageEachPhaseAbnormal'];
    urole = json['urole'];
    uMeter = json['uMeter'];
    operatingCurrent = json['operatingCurrent'];
    operatingCurrentAbnormal = json['operatingCurrentAbnormal'];
    degreeDifference = json['degreeDifference'];
    p = json['p'];
    checkBonded = json['checkBonded'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    tuLocation = json['tuLocation'];
    insulationOilLevelStatus = json['insulationOilLevelStatus'];
    insulationOilLevelStatusAbnormal = json['insulationOilLevelStatusAbnormal'];
    insulationClassificationGISCompartment =
        json['insulationClassificationGISCompartment'];
    insulationClassification = json['insulationClassification'];
    gasPressurSF6 = json['gasPressurSF6'];
    gasPressurSF6Abnormal = json['gasPressurSF6Abnormal'];
    conditionContactsTerminalsInsulators =
        json['conditionContactsTerminalsInsulators'];
    conditionContactsTerminalsInsulatorsAbnormal =
        json['conditionContactsTerminalsInsulatorsAbnormal'];
    groundingStatus = json['groundingStatus'];
    groundingStatusAbnormal = json['groundingStatusAbnormal'];
    unusualClassification = json['unusualClassification'];
    description = json['description'];
    if (json['images'] != null) {
      images = <Images>[];
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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['voltageEachPhase'] = voltageEachPhase;
    data['voltageEachPhaseAbnormal'] = voltageEachPhaseAbnormal;
    data['urole'] = urole;
    data['uMeter'] = uMeter;
    data['operatingCurrent'] = operatingCurrent;
    data['operatingCurrentAbnormal'] = operatingCurrentAbnormal;
    data['degreeDifference'] = degreeDifference;
    data['p'] = p;
    data['checkBonded'] = checkBonded;
    data['checkBondedAbnormal'] = checkBondedAbnormal;
    data['tuLocation'] = tuLocation;
    data['insulationOilLevelStatus'] = insulationOilLevelStatus;
    data['insulationOilLevelStatusAbnormal'] = insulationOilLevelStatusAbnormal;
    data['insulationClassificationGISCompartment'] =
        insulationClassificationGISCompartment;
    data['insulationClassification'] = insulationClassification;
    data['gasPressurSF6'] = gasPressurSF6;
    data['gasPressurSF6Abnormal'] = gasPressurSF6Abnormal;
    data['conditionContactsTerminalsInsulators'] =
        conditionContactsTerminalsInsulators;
    data['conditionContactsTerminalsInsulatorsAbnormal'] =
        conditionContactsTerminalsInsulatorsAbnormal;
    data['groundingStatus'] = groundingStatus;
    data['groundingStatusAbnormal'] = groundingStatusAbnormal;
    data['unusualClassification'] = unusualClassification;
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
    return voltageEachPhase == null ||
        // urole == null ||
        // uMeter == null ||
        operatingCurrent == null ||
        checkBonded == null ||
        tuLocation == null ||
        (tuLocation == ContentOptions.outSite.value &&
            (gasPressurSF6 == null ||
                conditionContactsTerminalsInsulators == null)) ||
        (insulationClassificationGISCompartment == ContentOptions.sf6.value &&
            p == null) ||
        insulationClassificationGISCompartment == null ||
        gasPressurSF6 == null ||
        groundingStatus == null;
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      switch (abnormal.categoryIndex) {
        case ImageProblems.muc1_2:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc2_1:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc2_2:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc2_3:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc2_4:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
      }
    });
  }
}

