// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterCutterLBS extends PopupBaseModel {

  int switchingState;
  int movementStructure;
  int insulation;
  int contactAtInsulation;
  int sound;
  int joint;
  int lightningProtection;
  int gasPressure;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterCutterLBS({
    this.switchingState,
    this.movementStructure,
    this.insulation,
    this.contactAtInsulation,
    this.sound,
    this.joint,
    this.lightningProtection,
    this.gasPressure,
    this.possibleProblematic,
    this.handlingImmediatelyInspection
  });

  InterCutterLBS.fromJson(JSON json) {
    switchingState = json['switchingState'].integer;
    movementStructure = json['movementStructure'].integer;
    insulation = json['insulation'].integer;
    contactAtInsulation = json['contactAtInsulation'].integer;
    sound = json['sound'].integer;
    joint = json['joint'].integer;
    lightningProtection = json['lightningProtection'].integer;
    gasPressure = json['gasPressure'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
    specificPhenomena = json['specificPhenomena'].string;
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
    map['switchingState'] = switchingState;
    map['movementStructure'] = movementStructure;
    map['insulation'] = insulation;
    map['contactAtInsulation'] = contactAtInsulation;
    map['sound'] = sound;
    map['joint'] = joint;
    map['lightningProtection'] = lightningProtection;
    map['gasPressure'] = gasPressure;
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
    return ![switchingState,movementStructure, insulation, contactAtInsulation, sound
    , joint, lightningProtection, gasPressure, possibleProblematic, handlingImmediatelyInspection, suggestedHandlingOfAbnormal, specificPhenomena].contains(null);
  }
}
