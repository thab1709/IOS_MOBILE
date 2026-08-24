// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';

/// switchingIndicator : 1
/// insulation : 1
/// mediumVoltageJunction : 1
/// lightingProtection : 1
/// signalCable : 1
/// powerSupply : 1
/// battery : 1
/// controlCabinet : 1
/// gasPressure : 1
/// contact : 1
/// bladeContact : 1
/// specificPhenomena : "string"
/// handlingImmediatelyInspection : 1
/// suggestedHandlingOfAbnormal : "string"
/// images : [{"imageStorageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","url":"string","problems":0}]

class InterRecloserModel extends PopupBaseModel {
  int switchingIndicator;
  int insulation;
  int mediumVoltageJunction;
  int lightingProtection;
  int signalCable;
  int powerSupply;
  int battery;
  int controlCabinet;
  int gasPressure;
  int contact;
  int bladeContact;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterRecloserModel({
      this.switchingIndicator,
    this. insulation,
    this. mediumVoltageJunction,
    this. lightingProtection,
    this. signalCable,
    this. powerSupply,
    this. battery,
    this. controlCabinet,
    this. gasPressure,
    this. contact,
    this. bladeContact,
    this. handlingImmediatelyInspection,});

  InterRecloserModel.fromJson(JSON json) {
    switchingIndicator = json['switchingIndicator'].integer;
    insulation = json['insulation'].integer;
    mediumVoltageJunction = json['mediumVoltageJunction'].integer;
    lightingProtection = json['lightingProtection'].integer;
    signalCable = json['signalCable'].integer;
    powerSupply = json['powerSupply'].integer;
    battery = json['battery'].integer;
    controlCabinet = json['controlCabinet'].integer;
    gasPressure = json['gasPressure'].integer;
    contact = json['contact'].integer;
    bladeContact = json['bladeContact'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    handlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    if (json['images'] != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['switchingIndicator'] = switchingIndicator;
    map['insulation'] = insulation;
    map['mediumVoltageJunction'] = mediumVoltageJunction;
    map['lightingProtection'] = lightingProtection;
    map['signalCable'] = signalCable;
    map['powerSupply'] = powerSupply;
    map['battery'] = battery;
    map['controlCabinet'] = controlCabinet;
    map['gasPressure'] = gasPressure;
    map['contact'] = contact;
    map['bladeContact'] = bladeContact;
    map['specificPhenomena'] = specificPhenomena;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
    map['possibleProblematic'] = possibleProblematic;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['description'] = description;
    if (images != null) {
      map['images'] = images.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      map['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  bool validateData() {
    return ![switchingIndicator, insulation, mediumVoltageJunction, lightingProtection, 
      signalCable, powerSupply, battery, controlCabinet, gasPressure, contact, bladeContact, specificPhenomena, handlingImmediatelyInspection, specificPhenomena, suggestedHandlingOfAbnormal].contains(null);
  }
}
