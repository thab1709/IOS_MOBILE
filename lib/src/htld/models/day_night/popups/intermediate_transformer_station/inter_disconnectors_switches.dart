// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterDisconnectorsSwitches extends PopupBaseModel {
  int insulation1;
  int transmission;
  int bladeContact;
  int insulation2;
  int synchronizationBlade;
  int bladesAndMountsCountact;
  int blade;
  int contactSpring;
  int bolts;
  int sound;
  int mediumVoltageJunction;
  int grounding;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterDisconnectorsSwitches({
      this.insulation1, 
      this.transmission, 
      this.bladeContact, 
      this.insulation2, 
      this.synchronizationBlade, 
      this.bladesAndMountsCountact, 
      this.blade, 
      this.contactSpring, 
      this.bolts, 
      this.sound, 
      this.mediumVoltageJunction, 
      this.grounding,
      this.possibleProblematic,
      this.handlingImmediatelyInspection,
  });

  InterDisconnectorsSwitches.fromJson(JSON json) {
    insulation1 = json['insulation1'].integer;
    transmission = json['transmission'].integer;
    bladeContact = json['bladeContact'].integer;
    insulation2 = json['insulation2'].integer;
    synchronizationBlade = json['synchronizationBlade'].integer;
    bladesAndMountsCountact = json['bladesAndMountsCountact'].integer;
    blade = json['blade'].integer;
    contactSpring = json['contactSpring'].integer;
    bolts = json['bolts'].integer;
    sound = json['sound'].integer;
    mediumVoltageJunction = json['mediumVoltageJunction'].integer;
    grounding = json['grounding'].integer;
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
    map['insulation1'] = insulation1;
    map['transmission'] = transmission;
    map['bladeContact'] = bladeContact;
    map['insulation2'] = insulation2;
    map['synchronizationBlade'] = synchronizationBlade;
    map['bladesAndMountsCountact'] = bladesAndMountsCountact;
    map['blade'] = blade;
    map['contactSpring'] = contactSpring;
    map['bolts'] = bolts;
    map['sound'] = sound;
    map['mediumVoltageJunction'] = mediumVoltageJunction;
    map['grounding'] = grounding;
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
    return ![insulation1, insulation2, transmission, bladeContact, synchronizationBlade, bladesAndMountsCountact, blade, contactSpring
    , bolts, sound, mediumVoltageJunction, grounding, possibleProblematic, handlingImmediatelyInspection, specificPhenomena, suggestedHandlingOfAbnormal].contains(null);
  }
}

