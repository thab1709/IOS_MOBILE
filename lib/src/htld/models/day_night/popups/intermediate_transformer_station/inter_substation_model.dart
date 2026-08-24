// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';

/// sound : 1
/// case : 1
/// oilLevel : 1
/// oilTemperature : "string"
/// insulation : 1
/// insulationSurface : 1
/// coolingFan : 1
/// steamRelay : 1
/// safetVvalve : 1
/// explosionProof : 1
/// signalingDevice : 1
/// contactHeatGeneration : 1
/// groundingSystem : 1
/// desiccantColor : 1
/// radiatorVane : 1
/// specificPhenomena : "string"
/// problems : 1
/// handlingImmediatelyInspection : 1
/// suggestAbnormalDamaged : "string"
/// images : [{"imageStorageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","url":"string","problems":0}]

class InterSubstationModel extends PopupBaseModel {
  int sound;
  int caseOption;
  int oilLevel;
  String oilTemperature;
  int insulation;
  int insulationSurface;
  int coolingFan;
  int steamRelay;
  int safetVvalve;
  int explosionProof;
  int signalingDevice;
  int contactHeatGeneration;
  int groundingSystem;
  int desiccantColor;
  int radiatorVane;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterSubstationModel(
      {this.sound,
      this.caseOption,
      this.oilLevel,
      this.oilTemperature,
      this.insulation,
      this.insulationSurface,
      this.coolingFan,
      this.steamRelay,
      this.safetVvalve,
      this.explosionProof,
      this.signalingDevice,
      this.contactHeatGeneration,
      this.groundingSystem,
      this.desiccantColor,
      this.radiatorVane,
      this.possibleProblematic,
      this.handlingImmediatelyInspection,});
  InterSubstationModel.fromJson(JSON json) {
    sound = json['sound'].integer;
    caseOption = json['case'].integer;
    oilLevel = json['oilLevel'].integer;
    oilTemperature = json['oilTemperature'].string;
    insulation = json['insulation'].integer;
    insulationSurface = json['insulationSurface'].integer;
    coolingFan = json['coolingFan'].integer;
    steamRelay = json['steamRelay'].integer;
    safetVvalve = json['safetVvalve'].integer;
    explosionProof = json['explosionProof'].integer;
    signalingDevice = json['signalingDevice'].integer;
    contactHeatGeneration = json['contactHeatGeneration'].integer;
    groundingSystem = json['groundingSystem'].integer;
    desiccantColor = json['desiccantColor'].integer;
    radiatorVane = json['radiatorVane'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    handlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
    if (json['images'] != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sound'] = sound;
    map['case'] = caseOption;
    map['oilLevel'] = oilLevel;
    map['oilTemperature'] = oilTemperature;
    map['insulation'] = insulation;
    map['insulationSurface'] = insulationSurface;
    map['coolingFan'] = coolingFan;
    map['steamRelay'] = steamRelay;
    map['safetVvalve'] = safetVvalve;
    map['explosionProof'] = explosionProof;
    map['signalingDevice'] = signalingDevice;
    map['contactHeatGeneration'] = contactHeatGeneration;
    map['groundingSystem'] = groundingSystem;
    map['desiccantColor'] = desiccantColor;
    map['radiatorVane'] = radiatorVane;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
    map['specificPhenomena'] = specificPhenomena;
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

    return ![sound, caseOption, oilLevel, oilTemperature, insulation, insulationSurface, coolingFan, steamRelay, safetVvalve, explosionProof,
    signalingDevice, contactHeatGeneration, groundingSystem, desiccantColor, radiatorVane, possibleProblematic, suggestedHandlingOfAbnormal, handlingImmediatelyInspection, specificPhenomena].contains(null);
  }
}
