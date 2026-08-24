// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';
import '../../popup_base_model.dart';

class CuttingMachine extends PopupBaseModel {
  int externalCondition;
  int sound;
  int driveStructureClosed;
  int sf6Gas;
  int cableFaultRelay;
  int dryingResistance;
  int insulation;
  String measurePartialDischarge;
  int contactAtBlade;
  int springPressesContact;
  int bolts;
  int groundingEquipment;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  CuttingMachine({
      this.externalCondition, 
      this.sound, 
      this.driveStructureClosed, 
      this.sf6Gas, 
      this.cableFaultRelay, 
      this.dryingResistance, 
      this.insulation, 
      this.measurePartialDischarge, 
      this.contactAtBlade,
      this.springPressesContact, 
      this.bolts, 
      this.groundingEquipment, 
      this.possibleProblematic,
      this.handlingImmediatelyInspection, 
      });

  CuttingMachine.fromJson(JSON json) {
    externalCondition = json['externalCondition'].integer;
    sound = json['sound'].integer;
    driveStructureClosed = json['driveStructureClosed'].integer;
    sf6Gas = json['sf6Gas'].integer;
    cableFaultRelay = json['cableFaultRelay'].integer;
    dryingResistance = json['dryingResistance'].integer;
    insulation = json['insulation'].integer;
    measurePartialDischarge = json['measurePartialDischarge'].string;
    contactAtBlade = json['contactAtBlade'].integer;
    springPressesContact = json['springPressesContact'].integer;
    bolts = json['xbolts'].integer;
    groundingEquipment = json['groundingEquipment'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
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
    map['externalCondition'] = externalCondition;
    map['sound'] = sound;
    map['driveStructureClosed'] = driveStructureClosed;
    map['sf6Gas'] = sf6Gas;
    map['cableFaultRelay'] = cableFaultRelay;
    map['dryingResistance'] = dryingResistance;
    map['insulation'] = insulation;
    map['measurePartialDischarge'] = measurePartialDischarge;
    map['contactAtBlade'] = contactAtBlade;
    map['springPressesContact'] = springPressesContact;
    map['bolts'] = bolts;
    map['groundingEquipment'] = groundingEquipment;
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

    return ![externalCondition, sound, driveStructureClosed, sf6Gas,
      cableFaultRelay, dryingResistance, insulation, measurePartialDischarge, springPressesContact, bolts, groundingEquipment, specificPhenomena, possibleProblematic, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }
}

