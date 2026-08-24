// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class RoleModel extends BaseHighElectricPopupModel {
  int protectionRelays; // 1.Các rơle bảo vệ, điều khiển và hệ thống đo lường
  String protectionRelaysAbnormal;
  int activeSourceStatus; // 1.1.Tình trạng nguồn hoạt động
  String activeSourceStatusAbnormal;
  int statusOperatingLights; // 1.2.Tình trạng các đèn báo trạng thái vận hành
  String statusOperatingLightsAbnormal;
  int statusIndicatorStatus; // 1.3.Tình trạng chỉ thị trạng thái (đóng, cắt…), cảnh báo trên màn hình
  String statusIndicatorStatusAbnormal;
  int secondChamber; //2.Khoang nhị thứ
  String secondChamberAbnormal;
  int statusSignalLights; // 2.1.Tình trạng các đèn báo tín hiệu, bộ báo tín hiệu, cảnh báo trên mặt tủ
  String statusSignalLightsAbnormal;
  int statusIndicatorDevicesMIMIC; // 2.2.Tình trạng các đèn chỉ thị, MIMIC so với trạng thái nhất thứ
  String statusIndicatorDevicesMIMICAbnormal;
  int conditionDryingLightingCircuitSystem; // 2.3.Tình trạng hệ thống mạch sấy, chiếu sáng
  String conditionDryingLightingCircuitSystemAbnormal;
  int circuitStatus; // 2.4.Tình trạng mạch, hàng kẹp, ATM(phát nhiệt, lỏng,...)
  String circuitStatusAbnormal;
  int invasionForeignAnimals; // 2.5.Tình trạng chống nước; động vật lạ xâm nhập
  String invasionForeignAnimalsAbnormal;
  int checkStateIndustrialHygiene; // 2.6.Tình trạng vệ sinh công nghiệp
  String checkStateIndustrialHygieneAbnormal;

  RoleModel({
    this.protectionRelays,
    this.protectionRelaysAbnormal,
    this.activeSourceStatus,
    this.activeSourceStatusAbnormal,
    this.statusOperatingLights,
    this.statusOperatingLightsAbnormal,
    this.statusIndicatorStatus,
    this.statusIndicatorStatusAbnormal,
    this.secondChamber,
    this.secondChamberAbnormal,
    this.statusSignalLights,
    this.statusSignalLightsAbnormal,
    this.statusIndicatorDevicesMIMIC,
    this.statusIndicatorDevicesMIMICAbnormal,
    this.conditionDryingLightingCircuitSystem,
    this.conditionDryingLightingCircuitSystemAbnormal,
    this.circuitStatus,
    this.circuitStatusAbnormal,
    this.invasionForeignAnimals,
    this.invasionForeignAnimalsAbnormal,
    this.checkStateIndustrialHygiene,
    this.checkStateIndustrialHygieneAbnormal,
  }) : super(images: [], abnormals: []);

  RoleModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    protectionRelays = json['protectionRelays'];
    protectionRelaysAbnormal = json['protectionRelaysAbnormal'];
    activeSourceStatus = json['activeSourceStatus'];
    activeSourceStatusAbnormal = json['activeSourceStatusAbnormal'];
    statusOperatingLights = json['statusOperatingLights'];
    statusOperatingLightsAbnormal = json['statusOperatingLightsAbnormal'];
    statusIndicatorStatus = json['statusIndicatorStatus'];
    statusIndicatorStatusAbnormal = json['statusIndicatorStatusAbnormal'];
    secondChamber = json['secondChamber'];
    secondChamberAbnormal = json['secondChamberAbnormal'];
    statusSignalLights = json['statusSignalLights'];
    statusSignalLightsAbnormal = json['statusSignalLightsAbnormal'];
    statusIndicatorDevicesMIMIC = json['statusIndicatorDevicesMIMIC'];
    statusIndicatorDevicesMIMICAbnormal =
        json['statusIndicatorDevicesMIMICAbnormal'];
    conditionDryingLightingCircuitSystem =
        json['conditionDryingLightingCircuitSystem'];
    conditionDryingLightingCircuitSystemAbnormal =
        json['conditionDryingLightingCircuitSystemAbnormal'];
    circuitStatus = json['circuitStatus'];
    circuitStatusAbnormal = json['circuitStatusAbnormal'];
    invasionForeignAnimals = json['invasionForeignAnimals'];
    invasionForeignAnimalsAbnormal = json['invasionForeignAnimalsAbnormal'];
    checkStateIndustrialHygiene = json['checkStateIndustrialHygiene'];
    checkStateIndustrialHygieneAbnormal =
        json['checkStateIndustrialHygieneAbnormal'];
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
    data['protectionRelays'] = protectionRelays;
    data['protectionRelaysAbnormal'] = protectionRelaysAbnormal;
    data['activeSourceStatus'] = activeSourceStatus;
    data['activeSourceStatusAbnormal'] = activeSourceStatusAbnormal;
    data['statusOperatingLights'] = statusOperatingLights;
    data['statusOperatingLightsAbnormal'] = statusOperatingLightsAbnormal;
    data['statusIndicatorStatus'] = statusIndicatorStatus;
    data['statusIndicatorStatusAbnormal'] = statusIndicatorStatusAbnormal;
    data['secondChamber'] = secondChamber;
    data['secondChamberAbnormal'] = secondChamberAbnormal;
    data['statusSignalLights'] = statusSignalLights;
    data['statusSignalLightsAbnormal'] = statusSignalLightsAbnormal;
    data['statusIndicatorDevicesMIMIC'] = statusIndicatorDevicesMIMIC;
    data['statusIndicatorDevicesMIMICAbnormal'] =
        statusIndicatorDevicesMIMICAbnormal;
    data['conditionDryingLightingCircuitSystem'] =
        conditionDryingLightingCircuitSystem;
    data['conditionDryingLightingCircuitSystemAbnormal'] =
        conditionDryingLightingCircuitSystemAbnormal;
    data['circuitStatus'] = circuitStatus;
    data['circuitStatusAbnormal'] = circuitStatusAbnormal;
    data['invasionForeignAnimals'] = invasionForeignAnimals;
    data['invasionForeignAnimalsAbnormal'] = invasionForeignAnimalsAbnormal;
    data['checkStateIndustrialHygiene'] = checkStateIndustrialHygiene;
    data['checkStateIndustrialHygieneAbnormal'] =
        checkStateIndustrialHygieneAbnormal;
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
    return protectionRelays == null ||
        activeSourceStatus == null ||
        statusOperatingLights == null ||
        statusIndicatorStatus == null;
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      switch (abnormal.categoryIndex) {
        case ImageProblems.muc1_1:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_2:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_3:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc2_1:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc2_2:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc2_3:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc2_4:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc2_5:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc2_6:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
      }
    });
  }
}

