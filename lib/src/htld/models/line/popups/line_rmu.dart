// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';
import '../../problem_positions_model.dart';

class LineRmu extends PopupBaseModel {
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
  int measurePartialDischargeOptions;
  LineRmu({
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
    this.measurePartialDischargeOptions,
    this.handlingImmediatelyInspection,
  });

  LineRmu.fromJson(JSON json) {
    externalCondition = json['externalCondition'].integer;
    sound = json['sound'].integer;
    driveStructureClosed = json['driveStructureClosed'].integer;
    sf6Gas = json['sf6Gas'].integer;
    measurePartialDischargeOptions = json['measurePartialDischargeOptions'].integer;
    cableFaultRelay = json['cableFaultRelay'].integer;
    dryingResistance = json['dryingResistance'].integer;
    insulation = json['insulation'].integer;
    measurePartialDischarge = json['measurePartialDischarge'].string;
    contactAtBlade = json['contactAtBlade'].integer;
    springPressesContact = json['springPressesContact'].integer;
    bolts = json['bolts'].integer;
    groundingEquipment = json['groundingEquipment'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    isUpdateOffline = json['isUpdateOffline']?.boolean ?? false;
    if (json['images'] != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    if (json['problemPositions'] != null) {
      problemPositions = json['problemPositions']?.list?.map((e) => ProblemPositions.fromJson(e))?.toList();
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
    map['measurePartialDischargeOptions'] = measurePartialDischargeOptions;
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
    map['isUpdateOffline'] = isUpdateOffline ?? false;
    if (images != null) {
      map['images'] = images.map((v) => v.toJson()).toList();
    }
    if (problemPositions != null) {
      map['problemPositions'] = problemPositions.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      map['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  bool validateData() {
    final listDistinct = List<ProblemPositions>.empty(growable: true);
    problemPositions?.forEach((element) {
      final tamp = listDistinct?.firstWhere((e) => e?.fieldValue == element.fieldValue, orElse: () => null);
      if (tamp == null) {
        listDistinct.add(element);
      }
    });
    return ![specificPhenomena, suggestedHandlingOfAbnormal].contains(null) && listDistinct.length == 12;
  }

}

