// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class TIModel extends BaseHighElectricPopupModel {
  // Thông số vận hành
  int operatingParameters;

  //1.1.Dòng vận hành
  String operatingParametersAbnormal;
  double irole; // Irole
  double iMeter; // I Công tơ
  int operatingCurrent; // Kết luận
  String operatingCurrentAbnormal;
  double degreeDifference; // 1.2.Mức độ chênh lệch
  int checkBonded; //Kiểm tra ngoại quan
  String checkBondedAbnormal;
  int tiLocation; // Vị trí TI
  int insulationOilLevelStatus; // 2.1.Tình trạng mức dầu cách điện
  int insulationClassificationGISCompartment; //phân loại cách điện
  String insulationOilLevelStatusAbnormal;
  int conditionContactsTerminalsInsulators; // 2.2.Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
  String conditionContactsTerminalsInsulatorsAbnormal;
  int groundingStatus; // 2.3.Tình trạng nối đất
  String groundingStatusAbnormal;
  int unusualClassification;

  TIModel({
    this.operatingParameters,
    this.operatingParametersAbnormal,
    this.irole,
    this.iMeter,
    this.operatingCurrent,
    this.operatingCurrentAbnormal,
    this.degreeDifference,
    this.checkBonded,
    this.checkBondedAbnormal,
    this.tiLocation,
    this.insulationOilLevelStatus,
    this.insulationOilLevelStatusAbnormal,
    this.conditionContactsTerminalsInsulators,
    this.conditionContactsTerminalsInsulatorsAbnormal,
    this.groundingStatus,
    this.groundingStatusAbnormal,
    this.insulationClassificationGISCompartment,
    this.unusualClassification,
  }) : super(images: [], abnormals: []);

  TIModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    operatingParameters = json['operatingParameters'];
    operatingParametersAbnormal = json['operatingParametersAbnormal'];
    irole = json['irole'];
    iMeter = json['iMeter'];
    operatingCurrent = json['operatingCurrent'];
    operatingCurrentAbnormal = json['operatingCurrentAbnormal'];
    degreeDifference = json['degreeDifference'];
    checkBonded = json['checkBonded'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    tiLocation = json['tiLocation'];
    insulationOilLevelStatus = json['insulationOilLevelStatus'];
    insulationOilLevelStatusAbnormal = json['insulationOilLevelStatusAbnormal'];
    insulationClassificationGISCompartment =
        json['insulationClassificationGISCompartment'];
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
    data['operatingParameters'] = operatingParameters;
    data['operatingParametersAbnormal'] = operatingParametersAbnormal;
    data['irole'] = irole;
    data['iMeter'] = iMeter;
    data['operatingCurrent'] = operatingCurrent;
    data['operatingCurrentAbnormal'] = operatingCurrentAbnormal;
    data['degreeDifference'] = degreeDifference;
    data['checkBonded'] = checkBonded;
    data['checkBondedAbnormal'] = checkBondedAbnormal;
    data['tiLocation'] = tiLocation;
    data['insulationOilLevelStatus'] = insulationOilLevelStatus;
    data['insulationOilLevelStatusAbnormal'] = insulationOilLevelStatusAbnormal;
    data['conditionContactsTerminalsInsulators'] =
        conditionContactsTerminalsInsulators;
    data['insulationClassificationGISCompartment'] =
        insulationClassificationGISCompartment;
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
    return operatingParameters == null ||
        // irole == null ||
        operatingCurrent == null ||
        checkBonded == null ||
        tiLocation == null ||
        insulationClassificationGISCompartment == null ||
        (insulationClassificationGISCompartment == ContentOptions.oil.value &&
            insulationOilLevelStatus == null) ||
        (tiLocation == ContentOptions.outSite.value &&
            conditionContactsTerminalsInsulators == null) ||
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
      }
    });
  }
}

