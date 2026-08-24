// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import 'abnormal_model.dart';

class ChargingCabinetModel extends BaseHighElectricPopupModel {
  double operatingVoltageBYIn; // BY vào (VAC)
  double operatingVoltageBYOut; //BY ra (VDC)
  double operatingVoltageACCU; // ACCU (VDC)
  double operatingVoltageDCLoad; // Phụ tải DC (VDC)
  int operatingVoltage; // Kết luận
  String operatingVoltageAbnormal; // Bất thường
  double operatingCurrentBYIn; // BY vào (AAC)
  double operatingCurrentBYOut; // BY ra (ADC)
  double operatingCurrentACCU; // ACCU (ADC)
  double operatingCurrentDCLoad; // Phụ tải DC (ADC)
  int operatingCurrent; // Kết luận
  String operatingCurrentAbnormal; // Bất thường
  int cabinetSignalStatus; // Trạng thái tín hiệu mặt tủ
  String cabinetSignalStatusAbnormal; // Bất thường
  int loadingCabinetStatus; // Tình trạng tủ (tiếng kêu, phát nhiệt, ATM …)
  String loadingCabinetStatusAbnormal; // Tình trạng tủ Bất thường
  int checkLoadingCabinet; // Tủ nạp bất thường
  String checkLoadingCabinetAbnormal; // Tủ nạp bất thường

  ChargingCabinetModel({
    this.operatingVoltageBYIn,
    this.operatingVoltageBYOut,
    this.operatingVoltageACCU,
    this.operatingVoltageDCLoad,
    this.operatingVoltage,
    this.operatingVoltageAbnormal,
    this.operatingCurrentBYIn,
    this.operatingCurrentBYOut,
    this.operatingCurrentACCU,
    this.operatingCurrentDCLoad,
    this.operatingCurrent,
    this.operatingCurrentAbnormal,
    this.cabinetSignalStatus,
    this.cabinetSignalStatusAbnormal,
    this.loadingCabinetStatus,
    this.loadingCabinetStatusAbnormal,
    this.checkLoadingCabinet,
    this.checkLoadingCabinetAbnormal,
  }) : super(images: [], abnormals: []);

  ChargingCabinetModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    checkLoadingCabinet = json['checkLoadingCabinet'];
    checkLoadingCabinetAbnormal = json['checkLoadingCabinetAbnormal'];
    operatingVoltageBYIn = json['operatingVoltageBYIn'];
    operatingVoltageBYOut = json['operatingVoltageBYOut'];
    operatingVoltageACCU = json['operatingVoltageACCU'];
    operatingVoltageDCLoad = json['operatingVoltageDCLoad'];
    operatingVoltage = json['operatingVoltage'];
    operatingVoltageAbnormal = json['operatingVoltageAbnormal'];
    operatingCurrentBYIn = json['operatingCurrentBYIn'];
    operatingCurrentBYOut = json['operatingCurrentBYOut'];
    operatingCurrentACCU = json['operatingCurrentACCU'];
    operatingCurrentDCLoad = json['operatingCurrentDCLoad'];
    operatingCurrent = json['operatingCurrent'];
    operatingCurrentAbnormal = json['operatingCurrentAbnormal'];
    cabinetSignalStatus = json['cabinetSignalStatus'];
    cabinetSignalStatusAbnormal = json['cabinetSignalStatusAbnormal'];
    loadingCabinetStatus = json['loadingCabinetStatus'];
    loadingCabinetStatusAbnormal = json['loadingCabinetStatusAbnormal'];
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
    data['checkLoadingCabinet'] = checkLoadingCabinet;
    data['checkLoadingCabinetAbnormal'] = checkLoadingCabinetAbnormal;
    data['operatingVoltageBYIn'] = operatingVoltageBYIn;
    data['operatingVoltageBYOut'] = operatingVoltageBYOut;
    data['operatingVoltageACCU'] = operatingVoltageACCU;
    data['operatingVoltageDCLoad'] = operatingVoltageDCLoad;
    data['operatingVoltage'] = operatingVoltage;
    data['operatingVoltageAbnormal'] = operatingVoltageAbnormal;
    data['operatingCurrentBYIn'] = operatingCurrentBYIn;
    data['operatingCurrentBYOut'] = operatingCurrentBYOut;
    data['operatingCurrentACCU'] = operatingCurrentACCU;
    data['operatingCurrentDCLoad'] = operatingCurrentDCLoad;
    data['operatingCurrent'] = operatingCurrent;
    data['operatingCurrentAbnormal'] = operatingCurrentAbnormal;
    data['cabinetSignalStatus'] = cabinetSignalStatus;
    data['cabinetSignalStatusAbnormal'] = cabinetSignalStatusAbnormal;
    data['loadingCabinetStatus'] = loadingCabinetStatus;
    data['loadingCabinetStatusAbnormal'] = loadingCabinetStatusAbnormal;
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
    return operatingVoltageBYIn == null ||
        operatingVoltageBYOut == null ||
        // operatingVoltageACCU == null ||
        operatingVoltageDCLoad == null ||
        // operatingCurrentBYIn == null ||
        // operatingCurrentBYOut == null ||
        // operatingCurrentACCU == null ||
        operatingCurrentDCLoad == null ||
        operatingVoltage == null ||
        operatingCurrent == null ||
        loadingCabinetStatus == null ||
        cabinetSignalStatus == null ||
        checkLoadingCabinet == null;
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
        case ImageProblems.muc1_4:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
      }
    });
  }
}

