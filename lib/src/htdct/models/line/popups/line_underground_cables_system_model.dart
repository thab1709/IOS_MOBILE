// @dart=2.9
import '../../../common/constance/content_option.dart';
import '../../base_popup_model.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class LineUndergroundCablesSystem extends BaseHighElectricPopupModel {
  int violationUndergroundCableSafetyCorridor;//1.1 Tình trạng vi phạm hành lang an toàn cáp ngầm
  String violationUndergroundCableSafetyCorridorAbnormal;
  int conditionWaterConnectingTunnel;//1.2 Tình trạng nước trong hầm nối, thấm nước hầm nối
  String conditionWaterConnectingTunnelAbnormal;
  int cableHolderCondition;//1.3 Tình trạng giá đỡ cáp (nứt, gỉ, …)
  String cableHolderConditionAbnormal;
  int signStatus;//1.4 Tình trạng biển báo, biển tên pha…
  String signStatusAbnormal;
  int cableCondition;//1.5 Tình trạng cáp, hộp nối (nứt, tổn thương …)
  String cableConditionAbnormal;
  int conditionCableGroundWire;//1.6 Tình trạng dây tiếp địa vỏ cáp, các mối nối dây tiếp địa linkbox
  String conditionCableGroundWireAbnormal;
  int statusLinkBox ;//1.7
  String statusLinkBoxAbnormal;
  int checkBondedAbnormal;//1.0 Kiểm tra ngoại quan bất thường

  int cableBoxHeatEmission;//2.0 Kiểm tra hộp nối cáp
  double cableBoxHeatEmissionCoefficientMaterial;// Hệ số
  int cableBoxHeatEmissionCoefficient;// Chọn vật liệu phát nhiệt
  int cableBoxHeatEmissionCoefficientMaterialOptions;//2.1 Chọn vật liệu phát nhiệt
  String cableBoxHeatEmissionAbnormal;
  double measuringTemperaturePhaseA;
  double measuringTemperaturePhaseB;
  double measuringTemperaturePhaseC;
  int measuringTemperature;//2.2 Nhiệt độ đo (ºC)
  String measuringTemperatureAbnormal;
  int actualTemperature;//2.3 Nhiệt độ thực
  double actualTemperaturePhaseA;
  double actualTemperaturePhasB;
  double actualTemperaturePhasC;
  String actualTemperatureAbnormal;
  String checkCableJunctionBoxAbnormal;

  double linkboxCableHeatEmissionCoefficient;//Hệ số phát xạ nhiệt cáp linkbox
  int linkboxCableHeatEmissionCoefficientOptions;//3.1 Hệ số phát xạ nhiệt cáp linkbox KL
  int linkboxCableHeatEmissionMaterial;// Chọn vật liệu phát nhiệt
  int linkboxCableHeatEmission;//3.0 Kết luận
  String linkboxCableHeatEmissionAbnormal;
  int linkboxCableTemperature;//3.2 Nhiệt độ cáp linkbox (ºC)
  double linkboxCableTemperaturePhaseA;
  double linkboxCableTemperaturePhaseB;
  double linkboxCableTemperaturePhaseC;
  double linkboxCableTemperatureGrounding;// Nối đất
  String linkboxCableTemperatureAbnormal;
  int cableSheathInducedMeasurement;//3.3 Đo dòng cảm ứng vỏ cáp (A)
  double cableSheathInducedMeasurementPhaseA;
  double cableSheathInducedMeasurementPhaseB;
  double cableSheathInducedMeasurementPhaseC;
  double cableSheathInducedMeasurementGrounding;// Nối đất
  String cableSheathInducedMeasurementAbnormal;
  String linkboxAbnormal;

  LineUndergroundCablesSystem(
      {this.violationUndergroundCableSafetyCorridor,
      this.violationUndergroundCableSafetyCorridorAbnormal,
      this.conditionWaterConnectingTunnel,
      this.conditionWaterConnectingTunnelAbnormal,
      this.cableHolderCondition,
      this.cableHolderConditionAbnormal,
      this.signStatus,
      this.signStatusAbnormal,
      this.cableCondition,
      this.cableConditionAbnormal,
      this.conditionCableGroundWire,
      this.conditionCableGroundWireAbnormal,
      this.statusLinkBox,
      this.statusLinkBoxAbnormal,
      this.checkBondedAbnormal,
      this.cableBoxHeatEmission,
      this.cableBoxHeatEmissionCoefficientMaterial,
      this.cableBoxHeatEmissionCoefficient,
      this.cableBoxHeatEmissionCoefficientMaterialOptions,
      this.cableBoxHeatEmissionAbnormal,
      this.measuringTemperaturePhaseA,
      this.measuringTemperaturePhaseB,
      this.measuringTemperaturePhaseC,
      this.measuringTemperature,
      this.measuringTemperatureAbnormal,
      this.actualTemperature,
      this.actualTemperaturePhaseA,
      this.actualTemperaturePhasB,
      this.actualTemperaturePhasC,
      this.actualTemperatureAbnormal,
      this.checkCableJunctionBoxAbnormal,
      this.linkboxCableHeatEmissionCoefficient,
      this.linkboxCableHeatEmissionCoefficientOptions,
      this.linkboxCableHeatEmissionMaterial,
      this.linkboxCableHeatEmission,
      this.linkboxCableHeatEmissionAbnormal,
      this.linkboxCableTemperature,
      this.linkboxCableTemperaturePhaseA,
      this.linkboxCableTemperaturePhaseB,
      this.linkboxCableTemperaturePhaseC,
      this.linkboxCableTemperatureGrounding,
      this.linkboxCableTemperatureAbnormal,
      this.cableSheathInducedMeasurement,
      this.cableSheathInducedMeasurementPhaseA,
      this.cableSheathInducedMeasurementPhaseB,
      this.cableSheathInducedMeasurementPhaseC,
      this.cableSheathInducedMeasurementGrounding,
      this.cableSheathInducedMeasurementAbnormal,
      this.linkboxAbnormal,})
      : super(images: [], abnormals: []);

  @override
  void fromJson(Map json) {
    if(json == null) return;
    violationUndergroundCableSafetyCorridor =
        json['violationUndergroundCableSafetyCorridor'];
    violationUndergroundCableSafetyCorridorAbnormal =
        json['violationUndergroundCableSafetyCorridorAbnormal'];
    conditionWaterConnectingTunnel = json['conditionWaterConnectingTunnel'];
    conditionWaterConnectingTunnelAbnormal =
        json['conditionWaterConnectingTunnelAbnormal'];
    cableHolderCondition = json['cableHolderCondition'];
    cableHolderConditionAbnormal = json['cableHolderConditionAbnormal'];
    signStatus = json['signStatus'];
    signStatusAbnormal = json['signStatusAbnormal'];
    cableCondition = json['cableCondition'];
    cableConditionAbnormal = json['cableConditionAbnormal'];
    conditionCableGroundWire = json['conditionCableGroundWire'];
    conditionCableGroundWireAbnormal = json['conditionCableGroundWireAbnormal'];
    statusLinkBox = json['statusLinkBox'];
    statusLinkBoxAbnormal = json['statusLinkBoxAbnormal'];
    checkBondedAbnormal = json['checkBondedAbnormal'];
    cableBoxHeatEmission = json['cableBoxHeatEmission'];
    cableBoxHeatEmissionCoefficientMaterial =
        json['cableBoxHeatEmissionCoefficientMaterial'];
    cableBoxHeatEmissionCoefficient = json['cableBoxHeatEmissionCoefficient'];
    cableBoxHeatEmissionCoefficientMaterialOptions = json['cableBoxHeatEmissionCoefficientMaterialOptions'];
    cableBoxHeatEmissionAbnormal = json['cableBoxHeatEmissionAbnormal'];
    measuringTemperaturePhaseA = json['measuringTemperaturePhaseA'];
    measuringTemperaturePhaseB = json['measuringTemperaturePhaseB'];
    measuringTemperaturePhaseC = json['measuringTemperaturePhaseC'];
    measuringTemperature = json['measuringTemperature'];
    measuringTemperatureAbnormal = json['measuringTemperatureAbnormal'];
    actualTemperature = json['actualTemperature'];
    actualTemperaturePhaseA = json['actualTemperaturePhaseA'];
    actualTemperaturePhasB = json['actualTemperaturePhasB'];
    actualTemperaturePhasC = json['actualTemperaturePhasC'];
    actualTemperatureAbnormal = json['actualTemperatureAbnormal'];
    checkCableJunctionBoxAbnormal = json['checkCableJunctionBoxAbnormal'];
    linkboxCableHeatEmissionCoefficient =
        json['linkboxCableHeatEmissionCoefficient'];
    linkboxCableHeatEmissionCoefficientOptions =
        json['linkboxCableHeatEmissionCoefficientOptions'];
    linkboxCableHeatEmissionMaterial = json['linkboxCableHeatEmissionMaterial'];
    linkboxCableHeatEmission = json['linkboxCableHeatEmission'];
    linkboxCableHeatEmissionAbnormal = json['linkboxCableHeatEmissionAbnormal'];
    linkboxCableTemperature = json['linkboxCableTemperature'];
    linkboxCableTemperaturePhaseA = json['linkboxCableTemperaturePhaseA'];
    linkboxCableTemperaturePhaseB = json['linkboxCableTemperaturePhaseB'];
    linkboxCableTemperaturePhaseC = json['linkboxCableTemperaturePhaseC'];
    linkboxCableTemperatureGrounding = json['linkboxCableTemperatureGrounding'];
    linkboxCableTemperatureAbnormal = json['linkboxCableTemperatureAbnormal'];
    cableSheathInducedMeasurement = json['cableSheathInducedMeasurement'];
    cableSheathInducedMeasurementPhaseA =
        json['cableSheathInducedMeasurementPhaseA'];
    cableSheathInducedMeasurementPhaseB =
        json['cableSheathInducedMeasurementPhaseB'];
    cableSheathInducedMeasurementPhaseC =
        json['cableSheathInducedMeasurementPhaseC'];
    cableSheathInducedMeasurementGrounding =
        json['cableSheathInducedMeasurementGrounding'];
    cableSheathInducedMeasurementAbnormal =
        json['cableSheathInducedMeasurementAbnormal'];
    linkboxAbnormal = json['linkboxAbnormal'];
    description = json['description'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json['abnormals'] != null) {
      abnormals = <Abnormals>[];
      json['abnormals'].forEach((v) {
        abnormals.add(Abnormals.fromJson(v));
      });
    }
    else
    {
      abnormals=[];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['violationUndergroundCableSafetyCorridor'] =
        violationUndergroundCableSafetyCorridor;
    data['violationUndergroundCableSafetyCorridorAbnormal'] =
        violationUndergroundCableSafetyCorridorAbnormal;
    data['conditionWaterConnectingTunnel'] =
        conditionWaterConnectingTunnel;
    data['conditionWaterConnectingTunnelAbnormal'] =
        conditionWaterConnectingTunnelAbnormal;
    data['cableHolderCondition'] = cableHolderCondition;
    data['cableHolderConditionAbnormal'] = cableHolderConditionAbnormal;
    data['signStatus'] = signStatus;
    data['signStatusAbnormal'] = signStatusAbnormal;
    data['cableCondition'] = cableCondition;
    data['cableConditionAbnormal'] = cableConditionAbnormal;
    data['conditionCableGroundWire'] = conditionCableGroundWire;
    data['conditionCableGroundWireAbnormal'] =
        conditionCableGroundWireAbnormal;
    data['statusLinkBox'] = statusLinkBox;
    data['statusLinkBoxAbnormal'] =
        statusLinkBoxAbnormal;
    data['checkBondedAbnormal'] = checkBondedAbnormal;
    data['cableBoxHeatEmission'] = cableBoxHeatEmission;
    data['cableBoxHeatEmissionCoefficientMaterial'] =
        cableBoxHeatEmissionCoefficientMaterial;
    data['cableBoxHeatEmissionCoefficient'] =
        cableBoxHeatEmissionCoefficient;
    data['cableBoxHeatEmissionCoefficientMaterialOptions'] =
        cableBoxHeatEmissionCoefficientMaterialOptions;
    data['cableBoxHeatEmissionAbnormal'] = cableBoxHeatEmissionAbnormal;
    data['measuringTemperaturePhaseA'] = measuringTemperaturePhaseA;
    data['measuringTemperaturePhaseB'] = measuringTemperaturePhaseB;
    data['measuringTemperaturePhaseC'] = measuringTemperaturePhaseC;
    data['measuringTemperature'] = measuringTemperature;
    data['measuringTemperatureAbnormal'] = measuringTemperatureAbnormal;
    data['actualTemperature'] = actualTemperature;
    data['actualTemperaturePhaseA'] = actualTemperaturePhaseA;
    data['actualTemperaturePhasB'] = actualTemperaturePhasB;
    data['actualTemperaturePhasC'] = actualTemperaturePhasC;
    data['actualTemperatureAbnormal'] = actualTemperatureAbnormal;
    data['checkCableJunctionBoxAbnormal'] = checkCableJunctionBoxAbnormal;
    data['linkboxCableHeatEmissionCoefficient'] =
        linkboxCableHeatEmissionCoefficient;
    data['linkboxCableHeatEmissionCoefficientOptions'] =
        linkboxCableHeatEmissionCoefficientOptions;
    data['linkboxCableHeatEmissionMaterial'] =
        linkboxCableHeatEmissionMaterial;
    data['linkboxCableHeatEmission'] = linkboxCableHeatEmission;
    data['linkboxCableHeatEmissionAbnormal'] =
        linkboxCableHeatEmissionAbnormal;
    data['linkboxCableTemperature'] = linkboxCableTemperature;
    data['linkboxCableTemperaturePhaseA'] = linkboxCableTemperaturePhaseA;
    data['linkboxCableTemperaturePhaseB'] = linkboxCableTemperaturePhaseB;
    data['linkboxCableTemperaturePhaseC'] = linkboxCableTemperaturePhaseC;
    data['linkboxCableTemperatureGrounding'] =
        linkboxCableTemperatureGrounding;
    data['linkboxCableTemperatureAbnormal'] =
        linkboxCableTemperatureAbnormal;
    data['cableSheathInducedMeasurement'] = cableSheathInducedMeasurement;
    data['cableSheathInducedMeasurementPhaseA'] =
        cableSheathInducedMeasurementPhaseA;
    data['cableSheathInducedMeasurementPhaseB'] =
        cableSheathInducedMeasurementPhaseB;
    data['cableSheathInducedMeasurementPhaseC'] =
        cableSheathInducedMeasurementPhaseC;
    data['cableSheathInducedMeasurementGrounding'] =
        cableSheathInducedMeasurementGrounding;
    data['cableSheathInducedMeasurementAbnormal'] =
        cableSheathInducedMeasurementAbnormal;
    data['linkboxAbnormal'] = linkboxAbnormal;
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
    return
      violationUndergroundCableSafetyCorridor!=null
        && conditionWaterConnectingTunnel!=null
        && cableHolderCondition!=null
        && signStatus!=null
        && cableCondition!=null
        && conditionCableGroundWire!=null
        && statusLinkBox!=null
        && checkBondedAbnormal!=null

        && cableBoxHeatEmission!=null
        && cableBoxHeatEmissionCoefficientMaterialOptions!=null
        && cableBoxHeatEmissionCoefficient!=null
        && cableBoxHeatEmissionCoefficientMaterial!=null
        && measuringTemperature!=null
        && actualTemperature!=null


        && linkboxCableHeatEmission!=null
        && linkboxCableHeatEmissionCoefficientOptions!=null
        && linkboxCableHeatEmissionCoefficient!=null
        && linkboxCableHeatEmissionMaterial!=null
        && linkboxCableTemperature!=null
        && linkboxCableTemperaturePhaseA!=null
        && linkboxCableTemperaturePhaseB!=null
        && linkboxCableTemperaturePhaseC!=null
        && linkboxCableTemperatureGrounding!=null
        &&  cableSheathInducedMeasurement!=null
        &&  cableSheathInducedMeasurementPhaseA!=null
        &&  cableSheathInducedMeasurementPhaseB!=null
        &&  cableSheathInducedMeasurementPhaseC!=null
        &&  cableSheathInducedMeasurementGrounding!=null;
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      abnormal.abnormalType = ContentOptions.lineType.value;
    });
  }
  void autoTunerCableGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      abnormal.abnormalType = ContentOptions.undefinedType.value;
    });
  }
}

