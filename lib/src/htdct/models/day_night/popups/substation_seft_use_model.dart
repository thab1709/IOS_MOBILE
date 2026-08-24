// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class SubstationSeftUseModel extends BaseHighElectricPopupModel {
  int chirpMBA; //Tiếng kêu của MBA
  String chirpMBAAbnormal; // Tiếng kêu của MBA bất thường
  int conditionOilLevel; // Tình trạng mức dầu, mầu sắc của hạt hút ẩm MBA
  String
      conditionOilLevelAbnormal; // Tình trạng mức dầu, mầu sắc của hạt hút ẩm MBA bất thường
  int conditionBodyMBAContent; // Kết luận
  String conditionBodyMBAContentAbnormal; // Bất thường
  int statusGroundingSystemMBA; // Tình trạng hệ thống nối đất MBA
  String
      statusGroundingSystemMBAAbnormal; // Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
  int conditionContacts; // Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
  String
      conditionContactsAbnormal; // Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện bất thường
  int checkBonded; // Kiểm tra ngoại quan bất thường

  SubstationSeftUseModel({
    this.chirpMBA,
    this.chirpMBAAbnormal,
    this.conditionOilLevel,
    this.conditionOilLevelAbnormal,
    this.conditionBodyMBAContent,
    this.conditionBodyMBAContentAbnormal,
    this.statusGroundingSystemMBA,
    this.statusGroundingSystemMBAAbnormal,
    this.conditionContacts,
    this.conditionContactsAbnormal,
    this.checkBonded,
  }) : super(images: [], abnormals: []);

  SubstationSeftUseModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    chirpMBA = json['chirpMBA'];
    chirpMBAAbnormal = json['chirpMBAAbnormal'];
    conditionOilLevel = json['conditionOilLevel'];
    conditionOilLevelAbnormal = json['conditionOilLevelAbnormal'];
    conditionBodyMBAContent = json['conditionBodyMBAContent'];
    conditionBodyMBAContentAbnormal = json['conditionBodyMBAContentAbnormal'];
    statusGroundingSystemMBA = json['statusGroundingSystemMBA'];
    statusGroundingSystemMBAAbnormal = json['statusGroundingSystemMBAAbnormal'];
    conditionContacts = json['conditionContacts'];
    conditionContactsAbnormal = json['conditionContactsAbnormal'];
    checkBonded = json['checkBonded'];
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
    data['chirpMBA'] = chirpMBA;
    data['chirpMBAAbnormal'] = chirpMBAAbnormal;
    data['conditionOilLevel'] = conditionOilLevel;
    data['conditionOilLevelAbnormal'] = conditionOilLevelAbnormal;
    data['conditionBodyMBAContent'] = conditionBodyMBAContent;
    data['conditionBodyMBAContentAbnormal'] = conditionBodyMBAContentAbnormal;
    data['statusGroundingSystemMBA'] = statusGroundingSystemMBA;
    data['statusGroundingSystemMBAAbnormal'] = statusGroundingSystemMBAAbnormal;
    data['conditionContacts'] = conditionContacts;
    data['conditionContactsAbnormal'] = conditionContactsAbnormal;
    data['checkBonded'] = checkBonded;
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
    return chirpMBA == null ||
        conditionOilLevel == null ||
        conditionBodyMBAContent == null ||
        statusGroundingSystemMBA == null ||
        conditionContacts == null;
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
      }
    });
  }
}

