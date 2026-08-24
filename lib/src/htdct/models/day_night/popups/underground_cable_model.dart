// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class UndergroundCableModel extends BaseHighElectricPopupModel {
  int checkBonded;
  String checkBondedAbnormal;
  int cableConditionCable; // 1.1.Tình trạng cáp (nứt, tổn thương cáp …)
  String cableConditionCableAbnormal;
  int conditionCableAndCableCanopyCable; // 1.2.Tình trạng đầu cáp và tán cáp
  String conditionCableAndCableCanopyCableAbnormal;
  int conditionCableSheathGroundingSystem; // 1.3.Tình trạng hệ thống tiếp đất vỏ cáp
  String conditionCableSheathGroundingSystemAbnormal;
  int bracketCondition; // 1.4.Tình trạng giá đỡ (nứt, gỉ, cầu cáp, …)
  String bracketConditionAbnormal;
  int cableTunnelStatus; // 1.5.Tình trạng mương cáp, hầm cáp
  String cableTunnelStatusAbnormal;

  UndergroundCableModel({
    this.checkBonded,
    this.checkBondedAbnormal,
    this.cableConditionCable,
    this.cableConditionCableAbnormal,
    this.conditionCableAndCableCanopyCable,
    this.conditionCableAndCableCanopyCableAbnormal,
    this.conditionCableSheathGroundingSystem,
    this.conditionCableSheathGroundingSystemAbnormal,
    this.bracketCondition,
    this.bracketConditionAbnormal,
    this.cableTunnelStatus,
    this.cableTunnelStatusAbnormal,
  }) : super(images: [], abnormals: []);

  UndergroundCableModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    cableConditionCable = json['cableConditionCable'];
    cableConditionCableAbnormal = json['cableConditionCableAbnormal'];
    conditionCableAndCableCanopyCable =
        json['conditionCableAndCableCanopyCable'];
    conditionCableAndCableCanopyCableAbnormal =
        json['conditionCableAndCableCanopyCableAbnormal'];
    conditionCableSheathGroundingSystem =
        json['conditionCableSheathGroundingSystem'];
    conditionCableSheathGroundingSystemAbnormal =
        json['conditionCableSheathGroundingSystemAbnormal'];
    bracketCondition = json['bracketCondition'];
    bracketConditionAbnormal = json['bracketConditionAbnormal'];
    cableTunnelStatus = json['cableTunnelStatus'];
    cableTunnelStatusAbnormal = json['cableTunnelStatusAbnormal'];
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
    data['cableConditionCable'] = cableConditionCable;
    data['cableConditionCableAbnormal'] = cableConditionCableAbnormal;
    data['conditionCableAndCableCanopyCable'] =
        conditionCableAndCableCanopyCable;
    data['conditionCableAndCableCanopyCableAbnormal'] =
        conditionCableAndCableCanopyCableAbnormal;
    data['conditionCableSheathGroundingSystem'] =
        conditionCableSheathGroundingSystem;
    data['conditionCableSheathGroundingSystemAbnormal'] =
        conditionCableSheathGroundingSystemAbnormal;
    data['bracketCondition'] = bracketCondition;
    data['bracketConditionAbnormal'] = bracketConditionAbnormal;
    data['cableTunnelStatus'] = cableTunnelStatus;
    data['cableTunnelStatusAbnormal'] = cableTunnelStatusAbnormal;
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
        cableConditionCable == null ||
        conditionCableAndCableCanopyCable == null ||
        conditionCableSheathGroundingSystem == null ||
        bracketCondition == null ||
        cableTunnelStatus == null;
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
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_5:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
      }
    });
  }
}

