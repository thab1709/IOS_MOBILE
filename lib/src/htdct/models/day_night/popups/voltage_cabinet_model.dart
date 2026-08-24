// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';

import '../../../common/constance/content_option.dart';
import 'abnormal_model.dart';

class VoltageCabinetModel extends BaseHighElectricPopupModel {
  int cabinetsType; // Loại tủ
  int checkVoltageCabinets; // Kết luận
  String checkVoltageCabinetsAbnormal;
  int statusIndicatorLights; // 1.1. Tình trạng đèn chỉ thị trạng thái, thông số mặt tủ
  String statusIndicatorLightsAbnormal;
  int cabinetStatus; // 1.2. Tình trạng tủ (tiếng kêu, phát nhiệt, ATM …)
  String cabinetStatusAbnormal;
  int conditionDryingLighting; // 1.3. Tình trạng hệ thống mạch sấy, chiếu sáng
  String conditionDryingLightingAbnormal;
  int circuitStatusClampATM; // 1.4. Tình trạng mạch, hàng kẹp, ATM (phát nhiệt, lỏng, …)
  String circuitStatusClampATMAbnormal;
  int waterproofStatus; // 1.5. Tình trạng chống nước; động vật lạ xâm nhập.
  String waterproofStatusAbnormal;
  int checkGroundingSystem; // 1.6. Kiểm tra hệ thống nối đất
  String checkGroundingSystemAbnormal;
  int stateIndustrialHygiene; // 1.7. Tình trạng vệ sinh công nghiệp
  String stateIndustrialHygieneAbnormal;
  double dC1Plus; // DC1+
  double dC1Subtract; // DC1-
  double dC2Plus; // DC2+
  double dC2Subtract; // DC2-
  int busbarVoltageDC; // Kết luận
  String busbarVoltageDCAbnormal;
  double degreeDifference; // Mức độ chênh lệch
  double ia;
  double ib;
  double ic;
  double utb;
  int busbarVoltageAC; // Kết luận
  String busbarVoltageACAbnormal;
  int mainBoardOperatingStatus; // 1.10. Tình trạng nguồn hoạt động của bo mạch chính
  String mainBoardOperatingStatusAbnormal;
  int statusExpansionCardOperatingStatus; // 1.11. Tình trạng các đèn báo trạng thái vận hành card mở rộng
  String statusExpansionCardOperatingStatusAbnormal;
  int systemStatusHMIServerNetworkSwitchGPS; // 1.12. Tình trạng hệ thống HMI, SERVER, Switch mạng, GPS
  String systemStatusHMIServerNetworkSwitchGPSAbnormal;
  int statusCabinetLeadClamp; // 1.13. Tình trạng kẹp chì tủ, kẹp chì công tơ
  String statusCabinetLeadClampAbnormal;
  int statusIndicatorLightsParameters; // 1.14. Tình trạng đèn chỉ thị trạng thái, thông số mặt các công tơ
  String statusIndicatorLightsParametersAbnormal;
  int statusOutdoorLightingHT; // 1.15. Tình trạng HT chiếu sáng ngoài trời
  String statusOutdoorLightingHTAbnormal;
  int workingStatusMergingUnit; // 1.16. Tình trạng HT chiếu sáng ngoài trời
  String workingStatusMergingUnitAbnormal;

  VoltageCabinetModel({
    this.cabinetsType,
    this.checkVoltageCabinets,
    this.checkVoltageCabinetsAbnormal,
    this.statusIndicatorLights,
    this.statusIndicatorLightsAbnormal,
    this.cabinetStatus,
    this.cabinetStatusAbnormal,
    this.conditionDryingLighting,
    this.conditionDryingLightingAbnormal,
    this.circuitStatusClampATM,
    this.circuitStatusClampATMAbnormal,
    this.waterproofStatus,
    this.waterproofStatusAbnormal,
    this.checkGroundingSystem,
    this.checkGroundingSystemAbnormal,
    this.stateIndustrialHygiene,
    this.stateIndustrialHygieneAbnormal,
    this.dC1Plus,
    this.dC1Subtract,
    this.dC2Plus,
    this.dC2Subtract,
    this.busbarVoltageDC,
    this.busbarVoltageDCAbnormal,
    this.degreeDifference,
    this.ia,
    this.ib,
    this.ic,
    this.utb,
    this.busbarVoltageAC,
    this.busbarVoltageACAbnormal,
    this.mainBoardOperatingStatus,
    this.mainBoardOperatingStatusAbnormal,
    this.statusExpansionCardOperatingStatus,
    this.statusExpansionCardOperatingStatusAbnormal,
    this.systemStatusHMIServerNetworkSwitchGPS,
    this.systemStatusHMIServerNetworkSwitchGPSAbnormal,
    this.statusCabinetLeadClamp,
    this.statusCabinetLeadClampAbnormal,
    this.statusIndicatorLightsParameters,
    this.statusIndicatorLightsParametersAbnormal,
    this.statusOutdoorLightingHT,
    this.statusOutdoorLightingHTAbnormal,
    this.workingStatusMergingUnit,
    this.workingStatusMergingUnitAbnormal,
  }) : super(images: [], abnormals: []);

  VoltageCabinetModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    cabinetsType = json['cabinetsType'];
    checkVoltageCabinets = json['checkVoltageCabinets'];
    checkVoltageCabinetsAbnormal = json['checkVoltageCabinetsAbnormal'];
    statusIndicatorLights = json['statusIndicatorLights'];
    statusIndicatorLightsAbnormal = json['statusIndicatorLightsAbnormal'];
    cabinetStatus = json['cabinetStatus'];
    cabinetStatusAbnormal = json['cabinetStatusAbnormal'];
    conditionDryingLighting = json['conditionDryingLighting'];
    conditionDryingLightingAbnormal = json['conditionDryingLightingAbnormal'];
    circuitStatusClampATM = json['circuitStatusClampATM'];
    circuitStatusClampATMAbnormal = json['circuitStatusClampATMAbnormal'];
    waterproofStatus = json['waterproofStatus'];
    waterproofStatusAbnormal = json['waterproofStatusAbnormal'];
    checkGroundingSystem = json['checkGroundingSystem'];
    checkGroundingSystemAbnormal = json['checkGroundingSystemAbnormal'];
    stateIndustrialHygiene = json['stateIndustrialHygiene'];
    stateIndustrialHygieneAbnormal = json['stateIndustrialHygieneAbnormal'];
    dC1Plus = json['dC1Plus'];
    dC1Subtract = json['dC1Subtract'];
    dC2Plus = json['dC2Plus'];
    dC2Subtract = json['dC2Subtract'];
    busbarVoltageDC = json['busbarVoltageDC'];
    busbarVoltageDCAbnormal = json['busbarVoltageDCAbnormal'];
    degreeDifference = json['degreeDifference'];
    ia = json['ia'];
    ib = json['ib'];
    ic = json['ic'];
    utb = json['utb'];
    busbarVoltageAC = json['busbarVoltageAC'];
    busbarVoltageACAbnormal = json['busbarVoltageACAbnormal'];
    mainBoardOperatingStatus = json['mainBoardOperatingStatus'];
    mainBoardOperatingStatusAbnormal = json['mainBoardOperatingStatusAbnormal'];
    statusExpansionCardOperatingStatus =
        json['statusExpansionCardOperatingStatus'];
    statusExpansionCardOperatingStatusAbnormal =
        json['statusExpansionCardOperatingStatusAbnormal'];
    systemStatusHMIServerNetworkSwitchGPS =
        json['systemStatusHMIServerNetworkSwitchGPS'];
    systemStatusHMIServerNetworkSwitchGPSAbnormal =
        json['systemStatusHMIServerNetworkSwitchGPSAbnormal'];
    statusCabinetLeadClamp = json['statusCabinetLeadClamp'];
    statusCabinetLeadClampAbnormal = json['statusCabinetLeadClampAbnormal'];
    statusIndicatorLightsParameters = json['statusIndicatorLightsParameters'];
    statusIndicatorLightsParametersAbnormal =
        json['statusIndicatorLightsParametersAbnormal'];
    statusOutdoorLightingHT = json['statusOutdoorLightingHT'];
    statusOutdoorLightingHTAbnormal = json['statusOutdoorLightingHTAbnormal'];
    workingStatusMergingUnit = json['workingStatusMergingUnit'];
    workingStatusMergingUnitAbnormal = json['workingStatusMergingUnitAbnormal'];
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
    data['cabinetsType'] = cabinetsType;
    data['checkVoltageCabinets'] = checkVoltageCabinets;
    data['checkVoltageCabinetsAbnormal'] = checkVoltageCabinetsAbnormal;
    data['statusIndicatorLights'] = statusIndicatorLights;
    data['statusIndicatorLightsAbnormal'] = statusIndicatorLightsAbnormal;
    data['cabinetStatus'] = cabinetStatus;
    data['cabinetStatusAbnormal'] = cabinetStatusAbnormal;
    data['conditionDryingLighting'] = conditionDryingLighting;
    data['conditionDryingLightingAbnormal'] = conditionDryingLightingAbnormal;
    data['circuitStatusClampATM'] = circuitStatusClampATM;
    data['circuitStatusClampATMAbnormal'] = circuitStatusClampATMAbnormal;
    data['waterproofStatus'] = waterproofStatus;
    data['waterproofStatusAbnormal'] = waterproofStatusAbnormal;
    data['checkGroundingSystem'] = checkGroundingSystem;
    data['checkGroundingSystemAbnormal'] = checkGroundingSystemAbnormal;
    data['stateIndustrialHygiene'] = stateIndustrialHygiene;
    data['stateIndustrialHygieneAbnormal'] = stateIndustrialHygieneAbnormal;
    data['dC1Plus'] = dC1Plus;
    data['dC1Subtract'] = dC1Subtract;
    data['dC2Plus'] = dC2Plus;
    data['dC2Subtract'] = dC2Subtract;
    data['busbarVoltageDC'] = busbarVoltageDC;
    data['busbarVoltageDCAbnormal'] = busbarVoltageDCAbnormal;
    data['degreeDifference'] = degreeDifference;
    data['ia'] = ia;
    data['ib'] = ib;
    data['ic'] = ic;
    data['utb'] = utb;
    data['busbarVoltageAC'] = busbarVoltageAC;
    data['busbarVoltageACAbnormal'] = busbarVoltageACAbnormal;
    data['mainBoardOperatingStatus'] = mainBoardOperatingStatus;
    data['mainBoardOperatingStatusAbnormal'] = mainBoardOperatingStatusAbnormal;
    data['statusExpansionCardOperatingStatus'] =
        statusExpansionCardOperatingStatus;
    data['statusExpansionCardOperatingStatusAbnormal'] =
        statusExpansionCardOperatingStatusAbnormal;
    data['systemStatusHMIServerNetworkSwitchGPS'] =
        systemStatusHMIServerNetworkSwitchGPS;
    data['systemStatusHMIServerNetworkSwitchGPSAbnormal'] =
        systemStatusHMIServerNetworkSwitchGPSAbnormal;
    data['statusCabinetLeadClamp'] = statusCabinetLeadClamp;
    data['statusCabinetLeadClampAbnormal'] = statusCabinetLeadClampAbnormal;
    data['statusIndicatorLightsParameters'] = statusIndicatorLightsParameters;
    data['statusIndicatorLightsParametersAbnormal'] =
        statusIndicatorLightsParametersAbnormal;
    data['statusOutdoorLightingHT'] = statusOutdoorLightingHT;
    data['statusOutdoorLightingHTAbnormal'] = statusOutdoorLightingHTAbnormal;
    data['workingStatusMergingUnit'] = workingStatusMergingUnit;
    data['workingStatusMergingUnitAbnormal'] = workingStatusMergingUnitAbnormal;
    data['description'] = getDescription();
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      data['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void setCabinType(int type) {
    cabinetsType = type;
    if (cabinetsType == ContentOptions.AcElectricCabinet.value) {
      dC1Plus = null;
      dC1Subtract = null; // DC1-
      dC2Plus = null; // DC2+
      dC2Subtract = null; // DC2-

    } else if (cabinetsType == ContentOptions.DcElectricCabinet.value) {
      ia = null;
      ib = null;
      ic = null;
      utb = null;
      degreeDifference = null;
    } else {
      dC1Plus = null;
      dC1Subtract = null; // DC1-
      dC2Plus = null; // DC2+
      dC2Subtract = null; // DC2-
      busbarVoltageDC = null;
      busbarVoltageDCAbnormal = null;

      ia = null;
      ib = null;
      ic = null;
      utb = null;
      degreeDifference = null;
      busbarVoltageAC = null;
      busbarVoltageACAbnormal = null;
    }
  }

  bool isEnoughDataMeasure() {
    return (ia != null && ib != null && ic != null) ||
        (dC1Plus != null && dC1Subtract != null);
  }

  @override
  bool validateData() {
    return checkVoltageCabinets == null ||
        (cabinetsType != ContentOptions.CtElectricCabinet.value &&
            statusIndicatorLights == null) ||
        cabinetStatus == null ||
        conditionDryingLighting == null ||
        circuitStatusClampATM == null ||
        waterproofStatus == null ||
        checkGroundingSystem == null ||
        stateIndustrialHygiene == null ||
        (cabinetsType == ContentOptions.DcElectricCabinet.value &&
            (dC1Plus == null ||
                dC1Subtract == null ||
                // dC2Plus == null ||
                // dC2Subtract == null ||
                busbarVoltageDC == null)) ||
        (cabinetsType == ContentOptions.AcElectricCabinet.value &&
            (ia == null ||
                ib == null ||
                ic == null ||
                utb == null ||
                busbarVoltageAC == null)) ||
        (cabinetsType == ContentOptions.ScadaElectricCabinet.value &&
            (mainBoardOperatingStatus == null ||
                statusExpansionCardOperatingStatus == null ||
                systemStatusHMIServerNetworkSwitchGPS == null)) ||
        (cabinetsType == ContentOptions.CtElectricCabinet.value &&
            (statusCabinetLeadClamp == null ||
                statusIndicatorLightsParameters == null)) ||
        (cabinetsType == ContentOptions.MkElectricCabinet.value &&
            (statusOutdoorLightingHT == null ||
                workingStatusMergingUnit == null));
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
        case ImageProblems.muc1_5:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_6:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_7:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_8:
          abnormal.abnormalType = ContentOptions.htOneDirection.value;
          break;
        case ImageProblems.muc1_9:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_10:
          abnormal.abnormalType = ContentOptions.scada.value;
          break;
        case ImageProblems.muc1_11:
          abnormal.abnormalType = ContentOptions.scada.value;
          break;
        case ImageProblems.muc1_12:
          abnormal.abnormalType = ContentOptions.scada.value;
          break;
        case ImageProblems.muc1_13:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_14:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
        case ImageProblems.muc1_15:
          abnormal.abnormalType = ContentOptions.otherAbnormalType.value;
          break;
        case ImageProblems.muc1_16:
          abnormal.abnormalType = ContentOptions.second.value;
          break;
      }
    });
  }
}

