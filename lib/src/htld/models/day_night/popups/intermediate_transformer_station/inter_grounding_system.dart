// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterGroundingSystem extends PopupBaseModel {
  int lightningProtectionStatus;
  int neutralGroundCondition;
  int groundWire;
  int bolts;
  int groundWireConnection;
  int groundStakes;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterGroundingSystem({
      this.lightningProtectionStatus, 
      this.neutralGroundCondition, 
      this.groundWire, 
      this.bolts, 
      this.groundWireConnection, 
      this.groundStakes,
      this.possibleProblematic,
      this.handlingImmediatelyInspection,
  });

  @override
  InterGroundingSystem.fromJson(JSON json) {
    lightningProtectionStatus = json['lightningProtectionStatus'].integer;
    neutralGroundCondition = json['neutralGroundCondition'].integer;
    groundWire = json['groundWire'].integer;
    bolts = json['bolts'].integer;
    groundWireConnection = json['groundWireConnection'].integer;
    groundStakes = json['groundStakes'].integer;
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
    map['lightningProtectionStatus'] = lightningProtectionStatus;
    map['neutralGroundCondition'] = neutralGroundCondition;
    map['groundWire'] = groundWire;
    map['bolts'] = bolts;
    map['groundWireConnection'] = groundWireConnection;
    map['groundStakes'] = groundStakes;
    map['specificPhenomena'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
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
    return ![lightningProtectionStatus, neutralGroundCondition, groundWire, bolts, groundWireConnection, groundStakes,
    specificPhenomena, possibleProblematic, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }

}

