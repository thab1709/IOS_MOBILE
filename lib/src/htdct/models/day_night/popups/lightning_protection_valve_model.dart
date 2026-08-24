// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class LightningProtectionValveModel extends BaseHighElectricPopupModel {
  int checkBonded; // Kết luận
  String checkBondedAbnormal;
  int csvLocation; // Vị trí CSV
  int groundingStatus; // 1.1.Tình trạng nối đất
  String groundingStatusAbnormal;
  int conditionContactsTerminalsInsulators; // 1.2.Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
  String conditionContactsTerminalsInsulatorsAbnormal;
  int insulationClassification; // Phân loại cách điện
  double p; // P
  int gasPressurSF6; // Kết luận
  String gasPressurSF6Abnormal;
  int checkCSVPoles; // 2. Kiểm tra các cực CSV
  String checkCSVPolesAbnormal;
  double ir; // Ir
  int leakageCurrentValue; // Kết luận
  String leakageCurrentValueAbnormal;
  double s; // S
  int lightningCounterIndicator; // Chỉ số bộ đếm sét
  String lightningCounterIndicatorAbnormal;

  LightningProtectionValveModel({
    this.checkBonded,
    this.checkBondedAbnormal,
    this.csvLocation,
    this.groundingStatus,
    this.groundingStatusAbnormal,
    this.conditionContactsTerminalsInsulators,
    this.conditionContactsTerminalsInsulatorsAbnormal,
    this.insulationClassification,
    this.p,
    this.gasPressurSF6,
    this.gasPressurSF6Abnormal,
    this.checkCSVPoles,
    this.checkCSVPolesAbnormal,
    this.ir,
    this.leakageCurrentValue,
    this.leakageCurrentValueAbnormal,
    this.s,
    this.lightningCounterIndicator,
    this.lightningCounterIndicatorAbnormal,
  }) : super(images: [], abnormals: []);

  LightningProtectionValveModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    csvLocation = json['csvLocation'];
    groundingStatus = json['groundingStatus'];
    groundingStatusAbnormal = json['groundingStatusAbnormal'];
    conditionContactsTerminalsInsulators =
        json['conditionContactsTerminalsInsulators'];
    conditionContactsTerminalsInsulatorsAbnormal =
        json['conditionContactsTerminalsInsulatorsAbnormal'];
    insulationClassification = json['insulationClassification'];
    p = json['p'];
    gasPressurSF6 = json['gasPressurSF6'];
    gasPressurSF6Abnormal = json['gasPressurSF6Abnormal'];
    checkCSVPoles = json['checkCSVPoles'];
    checkCSVPolesAbnormal = json['checkCSVPolesAbnormal'];
    ir = json['ir'];
    leakageCurrentValue = json['leakageCurrentValue'];
    leakageCurrentValueAbnormal = json['leakageCurrentValueAbnormal'];
    s = json['s'];
    lightningCounterIndicator = json['lightningCounterIndicator'];
    lightningCounterIndicatorAbnormal =
        json['lightningCounterIndicatorAbnormal'];
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
    final data = <String, dynamic>{};
    data['checkBonded'] = checkBonded;
    data['checkBondedAbnormal'] = checkBondedAbnormal;
    data['csvLocation'] = csvLocation;
    data['groundingStatus'] = groundingStatus;
    data['groundingStatusAbnormal'] = groundingStatusAbnormal;
    data['conditionContactsTerminalsInsulators'] =
        conditionContactsTerminalsInsulators;
    data['conditionContactsTerminalsInsulatorsAbnormal'] =
        conditionContactsTerminalsInsulatorsAbnormal;
    data['insulationClassification'] = insulationClassification;
    data['p'] = p;
    data['gasPressurSF6'] = gasPressurSF6;
    data['gasPressurSF6Abnormal'] = gasPressurSF6Abnormal;
    data['checkCSVPoles'] = checkCSVPoles;
    data['checkCSVPolesAbnormal'] = checkCSVPolesAbnormal;
    data['ir'] = ir;
    data['leakageCurrentValue'] = leakageCurrentValue;
    data['leakageCurrentValueAbnormal'] = leakageCurrentValueAbnormal;
    data['s'] = s;
    data['lightningCounterIndicator'] = lightningCounterIndicator;
    data['lightningCounterIndicatorAbnormal'] =
        lightningCounterIndicatorAbnormal;
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
        csvLocation == null ||
        groundingStatus == null ||
        (csvLocation == ContentOptions.outSite.value &&
            (checkCSVPoles == null ||
                conditionContactsTerminalsInsulators == null ||
                leakageCurrentValue == null ||
                lightningCounterIndicator == null));
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
        case ImageProblems.muc2_1:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc2_2:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
      }
    });
  }
}

