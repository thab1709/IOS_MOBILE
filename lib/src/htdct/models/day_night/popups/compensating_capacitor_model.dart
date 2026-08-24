// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class CompensatingCapacitorModel extends BaseHighElectricPopupModel {
  int checkBonded;
  String checkBondedAbnormal;
  double u;
  double i;
  double q;
  int operatingParameters; //1.1 Thông số vận hành KL
  String operatingParametersAbnormal;
  int conditionPorcelainInsulator; // 1.2. Tình trạng sứ cách điện, các điểm tiếp xúc, đầu cốt
  String conditionPorcelainInsulatorAbnormal;
  int seepageCondition; // 1.3.Tình trạng thấm rỉ, dung môi cách điện
  String seepageConditionAbnormal;
  int condenserGroundingStatus; // 1.4.Tình trạng nối đất dàn tụ
  String condenserGroundingStatusAbnormal;

  CompensatingCapacitorModel({
    this.checkBonded,
    this.checkBondedAbnormal,
    this.u,
    this.i,
    this.q,
    this.operatingParameters,
    this.operatingParametersAbnormal,
    this.conditionPorcelainInsulator,
    this.conditionPorcelainInsulatorAbnormal,
    this.seepageCondition,
    this.seepageConditionAbnormal,
    this.condenserGroundingStatus,
    this.condenserGroundingStatusAbnormal,
  }) : super(images: [], abnormals: []);

  CompensatingCapacitorModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    u = json['u'];
    i = json['i'];
    q = json['q'];
    operatingParameters = json['operatingParameters'];
    operatingParametersAbnormal = json['operatingParametersAbnormal'];
    conditionPorcelainInsulator = json['conditionPorcelainInsulator'];
    conditionPorcelainInsulatorAbnormal =
        json['conditionPorcelainInsulatorAbnormal'];
    seepageCondition = json['seepageCondition'];
    seepageConditionAbnormal = json['seepageConditionAbnormal'];
    condenserGroundingStatus = json['condenserGroundingStatus'];
    condenserGroundingStatusAbnormal = json['condenserGroundingStatusAbnormal'];
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
    data['u'] = u;
    data['i'] = i;
    data['q'] = q;
    data['operatingParameters'] = operatingParameters;
    data['operatingParametersAbnormal'] = operatingParametersAbnormal;
    data['conditionPorcelainInsulator'] = conditionPorcelainInsulator;
    data['conditionPorcelainInsulatorAbnormal'] =
        conditionPorcelainInsulatorAbnormal;
    data['seepageCondition'] = seepageCondition;
    data['seepageConditionAbnormal'] = seepageConditionAbnormal;
    data['condenserGroundingStatus'] = condenserGroundingStatus;
    data['condenserGroundingStatusAbnormal'] = condenserGroundingStatusAbnormal;
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
        u == null ||
        i == null ||
        q == null ||
        operatingParameters == null ||
        conditionPorcelainInsulator == null ||
        seepageCondition == null ||
        condenserGroundingStatus == null;
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
        case ImageProblems.muc1_3:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_4:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
      }
    });
  }
}

