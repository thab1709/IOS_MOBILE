// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../abnormal_model.dart';
import '../images_model.dart';

class TransformerNightModel extends BaseHighElectricPopupModel {
  TransformerNightModel({
    this.checkBonded,
    this.chirp,
    this.chirpAbnormal,
    this.outdoorLightingCondition,
    this.outdoorLightingConditionAbnormal,
    this.operatingStatus,
    this.operationSeparationDate,
    this.operatingStatusResult,
    this.operatingStatusAbnormal,
  }) : super(images: [], abnormals: []);

  TransformerNightModel.fromJson(json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    chirp = json['chirp'];
    chirpAbnormal = json['chirpAbnormal'];
    outdoorLightingCondition = json['outdoorLightingCondition'];
    checkDischarge = json['checkDischarge'];
    checkDischargeAbnormal = json['checkDischargeAbnormal'];
    outdoorLightingConditionAbnormal = json['outdoorLightingConditionAbnormal'];
    operatingStatus = json['operatingStatus'];
    operationSeparationDate = json['operationSeparationDate'];
    operatingStatusResult = json['operatingStatusResult'];
    operatingStatusAbnormal = json['operatingStatusAbnormal'];
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

  int checkBonded;
  int chirp;
  String chirpAbnormal;
  int outdoorLightingCondition;
  String outdoorLightingConditionAbnormal;
  int checkDischarge;
  String checkDischargeAbnormal;
  int operatingStatus;
  String operationSeparationDate;
  int operatingStatusResult;
  String operatingStatusAbnormal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['checkBonded'] = checkBonded;
    map['chirp'] = chirp;
    map['chirpAbnormal'] = chirpAbnormal;
    map['outdoorLightingCondition'] = outdoorLightingCondition;
    map['checkDischarge'] = checkDischarge;
    map['checkDischargeAbnormal'] = checkDischargeAbnormal;
    map['outdoorLightingConditionAbnormal'] = outdoorLightingConditionAbnormal;
    map['operatingStatus'] = operatingStatus;
    map['operationSeparationDate'] = operationSeparationDate;
    map['operatingStatusResult'] = operatingStatusResult;
    map['operatingStatusAbnormal'] = operatingStatusAbnormal;
    map['description'] = getDescription();
    if (images != null) {
      map['images'] = images.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      map['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  bool validateData() {
    return ![
      checkBonded,
      chirp,
      checkDischarge,
      outdoorLightingCondition,
      operatingStatus,
      operatingStatusResult
    ].contains(null);
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
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_4:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
      }
    });
  }
}

