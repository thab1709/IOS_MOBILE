// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import '../../../common/constance/content_option.dart';
import 'abnormal_model.dart';

class IsolationKnifeModel extends BaseHighElectricPopupModel {
  int checkBonded; // 1.0 Kiểm tra ngoại quan KL
  String checkBondedAbnormal;
  int locationIsolators; // Vị trí dao cách ly
  int insulationClassificationGISCompartment; // "Phân loại cách điện hoặc phân loại theo ngăn GIS"
  double phaseA;
  double phaseB;
  double phaseC;
  int gasPressureSF6; // Kết luận
  String gasPressureSF6Abnormal;
  int statusContactPoints; //1.2 Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện KL
  String statusContactPointsAbnormal;
  int mechanicalStructureGrounding; // 1.3.Cấu trúc cơ khí và nối đất
  String mechanicalStructureGroundingAbnormal;
  int conditionTransmissionCabinet; // 1.4. Tình trạng tủ truyền động
  String conditionTransmissionCabinetAbnormal;

  IsolationKnifeModel({
    this.checkBonded,
    this.checkBondedAbnormal,
    this.locationIsolators,
    this.insulationClassificationGISCompartment,
    this.phaseA,
    this.phaseB,
    this.phaseC,
    this.gasPressureSF6,
    this.gasPressureSF6Abnormal,
    this.statusContactPoints,
    this.statusContactPointsAbnormal,
    this.mechanicalStructureGrounding,
    this.mechanicalStructureGroundingAbnormal,
    this.conditionTransmissionCabinet,
    this.conditionTransmissionCabinetAbnormal,
  }) : super(images: [], abnormals: []);

  IsolationKnifeModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    locationIsolators = json['locationIsolators'];
    insulationClassificationGISCompartment =
        json['insulationClassificationGISCompartment'];
    phaseA = json['phaseA'];
    phaseB = json['phaseB'];
    phaseC = json['phaseC'];
    gasPressureSF6 = json['gasPressureSF6'];
    gasPressureSF6Abnormal = json['gasPressureSF6Abnormal'];
    statusContactPoints = json['statusContactPoints'];
    statusContactPointsAbnormal = json['statusContactPointsAbnormal'];
    mechanicalStructureGrounding = json['mechanicalStructureGrounding'];
    mechanicalStructureGroundingAbnormal =
        json['mechanicalStructureGroundingAbnormal'];
    conditionTransmissionCabinet = json['conditionTransmissionCabinet'];
    conditionTransmissionCabinetAbnormal =
        json['conditionTransmissionCabinetAbnormal'];
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
    data['locationIsolators'] = locationIsolators;
    data['insulationClassificationGISCompartment'] =
        insulationClassificationGISCompartment;
    data['phaseA'] = phaseA;
    data['phaseB'] = phaseB;
    data['phaseC'] = phaseC;
    data['gasPressureSF6'] = gasPressureSF6;
    data['gasPressureSF6Abnormal'] = gasPressureSF6Abnormal;
    data['statusContactPoints'] = statusContactPoints;
    data['statusContactPointsAbnormal'] = statusContactPointsAbnormal;
    data['mechanicalStructureGrounding'] = mechanicalStructureGrounding;
    data['mechanicalStructureGroundingAbnormal'] =
        mechanicalStructureGroundingAbnormal;
    data['conditionTransmissionCabinet'] = conditionTransmissionCabinet;
    data['conditionTransmissionCabinetAbnormal'] =
        conditionTransmissionCabinetAbnormal;
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
    return locationIsolators == null || mechanicalStructureGrounding == null;
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
          abnormal.abnormalType = ContentOptions.second.value;
          break;
      }
    });
  }
}

