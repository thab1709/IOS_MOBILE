// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import '../../../common/constance/content_option.dart';
import 'abnormal_model.dart';

class CuttingMachineModel extends BaseHighElectricPopupModel {
  int checkBonded; //1.0 Kết luận
  String checkBondedAbnormal;
  int cutterPosition; // Vị trí máy cắt
  int conditionContactPoints; // 1.1.Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
  String conditionContactPointsAbnormal;
  int conditionTransmissionCabinet; // 1.2.Tình trạng tủ truyền động (ATM, sấy, độ kín, chỉ danh thiết bị, vị trí khóa điều khiển …)
  String conditionTransmissionCabinetAbnormal;
  int operationMode; //1.3.Tình trạng hệ thống hút ẩm khoang cáp (nếu có)  Chế độ vận hành
  int conditionCableCompartment; //1.3.Tình trạng hệ thống hút ẩm khoang cáp (nếu có)  Kết luận
  String conditionCableCompartmentAbnormal;
  double temperature; //1.4 Nhiệt độ (oC)
  double humidity; //1.4 Độ ẩm
  int ventilators; //1.4 Quạt thông gió
  int distributionRoomStatus; // Kết luận
  String distributionRoomStatusAbnormal;
  int mechanicalStructureGrounding; // 1.5. Cấu trúc cơ khí và nối đất
  String mechanicalStructureGroundingAbnormal;
  int stateIndustrialHygiene; // 1.6.Tình trạng vệ sinh công nghiệp
  String stateIndustrialHygieneAbnormal;
  int insulationClassificationGISCompartment; // 1.7 "Phân loại cách điện hoặc phân loại theo ngăn GIS"
  String phaseA;
  String phaseB;
  String phaseC;
  int gasPressureSF6; // Kết luận
  String gasPressureSF6Abnormal;

  CuttingMachineModel({
    this.checkBonded,
    this.checkBondedAbnormal,
    this.cutterPosition,
    this.conditionContactPoints,
    this.conditionContactPointsAbnormal,
    this.conditionTransmissionCabinet,
    this.conditionTransmissionCabinetAbnormal,
    this.operationMode,
    this.conditionCableCompartment,
    this.conditionCableCompartmentAbnormal,
    this.temperature,
    this.humidity,
    this.ventilators,
    this.distributionRoomStatus,
    this.distributionRoomStatusAbnormal,
    this.mechanicalStructureGrounding,
    this.mechanicalStructureGroundingAbnormal,
    this.stateIndustrialHygiene,
    this.stateIndustrialHygieneAbnormal,
    this.insulationClassificationGISCompartment,
    this.phaseA,
    this.phaseB,
    this.phaseC,
    this.gasPressureSF6,
    this.gasPressureSF6Abnormal,
  }) : super(images: [], abnormals: []);

  CuttingMachineModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    cutterPosition = json['cutterPosition'];
    conditionContactPoints = json['conditionContactPoints'];
    conditionContactPointsAbnormal = json['conditionContactPointsAbnormal'];
    conditionTransmissionCabinet = json['conditionTransmissionCabinet'];
    conditionTransmissionCabinetAbnormal =
        json['conditionTransmissionCabinetAbnormal'];
    operationMode = json['operationMode'];
    conditionCableCompartment = json['conditionCableCompartment'];
    conditionCableCompartmentAbnormal =
        json['conditionCableCompartmentAbnormal'];
    temperature = json['temperature'];
    humidity = json['humidity'];
    ventilators = json['ventilators'];
    distributionRoomStatus = json['distributionRoomStatus'];
    distributionRoomStatusAbnormal = json['distributionRoomStatusAbnormal'];
    mechanicalStructureGrounding = json['mechanicalStructureGrounding'];
    mechanicalStructureGroundingAbnormal =
        json['mechanicalStructureGroundingAbnormal'];
    stateIndustrialHygiene = json['stateIndustrialHygiene'];
    stateIndustrialHygieneAbnormal = json['stateIndustrialHygieneAbnormal'];
    insulationClassificationGISCompartment =
        json['insulationClassificationGISCompartment'];
    phaseA = json['phaseA'];
    phaseB = json['phaseB'];
    phaseC = json['phaseC'];
    gasPressureSF6 = json['gasPressureSF6'];
    gasPressureSF6Abnormal = json['gasPressureSF6Abnormal'];
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
    data['cutterPosition'] = cutterPosition;
    data['conditionContactPoints'] = conditionContactPoints;
    data['conditionContactPointsAbnormal'] = conditionContactPointsAbnormal;
    data['conditionTransmissionCabinet'] = conditionTransmissionCabinet;
    data['conditionTransmissionCabinetAbnormal'] =
        conditionTransmissionCabinetAbnormal;
    data['operationMode'] = operationMode;
    data['conditionCableCompartment'] = conditionCableCompartment;
    data['conditionCableCompartmentAbnormal'] =
        conditionCableCompartmentAbnormal;
    data['temperature'] = temperature;
    data['humidity'] = humidity;
    data['ventilators'] = ventilators;
    data['distributionRoomStatus'] = distributionRoomStatus;
    data['distributionRoomStatusAbnormal'] = distributionRoomStatusAbnormal;
    data['mechanicalStructureGrounding'] = mechanicalStructureGrounding;
    data['mechanicalStructureGroundingAbnormal'] =
        mechanicalStructureGroundingAbnormal;
    data['stateIndustrialHygiene'] = stateIndustrialHygiene;
    data['stateIndustrialHygieneAbnormal'] = stateIndustrialHygieneAbnormal;
    data['insulationClassificationGISCompartment'] =
        insulationClassificationGISCompartment;
    data['phaseA'] = phaseA;
    data['phaseB'] = phaseB;
    data['phaseC'] = phaseC;
    data['gasPressureSF6'] = gasPressureSF6;
    data['gasPressureSF6Abnormal'] = gasPressureSF6Abnormal;
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
        cutterPosition == null ||
        mechanicalStructureGrounding == null ||
        stateIndustrialHygiene == null ||
        insulationClassificationGISCompartment == null ||
        (insulationClassificationGISCompartment !=
                ContentOptions.vacuum.value &&
            (phaseA.isNullOrBlank() || gasPressureSF6 == null));
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      switch (abnormal.categoryIndex) {
        case ImageProblems.muc1_1:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_2:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_3:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_4:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_5:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_6:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_7:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
      }
    });
  }
}

