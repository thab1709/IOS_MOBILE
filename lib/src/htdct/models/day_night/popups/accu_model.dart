// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class ACCUModel extends BaseHighElectricPopupModel {
  int checkACCUSystem;
  String checkACCUSystemAbnormal;
  int conditionBottle; // 1.1.Tình trạng vỏ bình, cọc bình, thanh đấu nối.
  String conditionBottleAbnormal;
  int conditionCconnectingRod; // 1.2.Tình trạng thanh đấu nối, điểm tiếp xúc
  String conditionCconnectingRodAbnormal;
  int troubleLightingStatus; // 1.3.Tình trạng đèn chiếu sáng sự cố, quạt thông gió
  String troubleLightingStatusAbnormal;

  ACCUModel({
    this.checkACCUSystem,
    this.checkACCUSystemAbnormal,
    this.conditionBottle,
    this.conditionBottleAbnormal,
    this.conditionCconnectingRod,
    this.conditionCconnectingRodAbnormal,
    this.troubleLightingStatus,
    this.troubleLightingStatusAbnormal,
  }) : super(images: [], abnormals: []);

  ACCUModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    checkACCUSystem = json['checkACCUSystem'];
    checkACCUSystemAbnormal = json['checkACCUSystemAbnormal'];
    conditionBottle = json['conditionBottle'];
    conditionBottleAbnormal = json['conditionBottleAbnormal'];
    conditionCconnectingRod = json['conditionCconnectingRod'];
    conditionCconnectingRodAbnormal = json['conditionCconnectingRodAbnormal'];
    troubleLightingStatus = json['troubleLightingStatus'];
    troubleLightingStatusAbnormal = json['troubleLightingStatusAbnormal'];
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
    data['checkACCUSystem'] = checkACCUSystem;
    data['checkACCUSystemAbnormal'] = checkACCUSystemAbnormal;
    data['conditionBottle'] = conditionBottle;
    data['conditionBottleAbnormal'] = conditionBottleAbnormal;
    data['conditionCconnectingRod'] = conditionCconnectingRod;
    data['conditionCconnectingRodAbnormal'] = conditionCconnectingRodAbnormal;
    data['troubleLightingStatus'] = troubleLightingStatus;
    data['troubleLightingStatusAbnormal'] = troubleLightingStatusAbnormal;
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
    return conditionBottle == null ||
        conditionCconnectingRod == null ||
        troubleLightingStatus == null ||
        checkACCUSystem == null;
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      switch (abnormal.categoryIndex) {
        case ImageProblems.muc1_1:
          abnormal.abnormalType = ContentOptions.htOneDirection.value;
          break;
        case ImageProblems.muc1_2:
          abnormal.abnormalType = ContentOptions.htOneDirection.value;
          break;
        case ImageProblems.muc1_3:
          abnormal.abnormalType = ContentOptions.htOneDirection.value;
          break;
      }
    });
  }
}

