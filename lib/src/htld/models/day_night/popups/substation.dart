// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class Substation extends PopupBaseModel {
  int voice;
  int caseSubstation;
  int subOilTankLevel;
  int color;
  int insulation;
  int contactHeatGeneration;
  int groundingSystem;
  int desiccantColor;
  int radiatorFins;
  int possibleProblematic;
  int handingInCheck;

  Substation({
      this.voice, 
      this.caseSubstation,
      this.subOilTankLevel, 
      this.color, 
      this.insulation, 
      this.contactHeatGeneration, 
      this.groundingSystem, 
      this.desiccantColor, 
      this.radiatorFins, 
      this.possibleProblematic,
      this.handingInCheck, 
      });

  Substation.fromJson(JSON json) {
    voice = json['voice'].integer;
    caseSubstation = json['case'].integer;
    subOilTankLevel = json['subOilTankLevel'].integer;
    color = json['color'].integer;
    insulation = json['insulation'].integer;
    contactHeatGeneration = json['contactHeatGeneration'].integer;
    groundingSystem = json['groundingSystem'].integer;
    desiccantColor = json['desiccantColor'].integer;
    radiatorFins = json['radiatorFins'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    handingInCheck = json['handingInCheck'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    if (json['images'] != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJSON() {
    final map = <String, dynamic>{};
    map['voice'] = voice;
    map['case'] = caseSubstation;
    map['subOilTankLevel'] = subOilTankLevel;
    map['color'] = color;
    map['insulation'] = insulation;
    map['contactHeatGeneration'] = contactHeatGeneration;
    map['groundingSystem'] = groundingSystem;
    map['desiccantColor'] = desiccantColor;
    map['radiatorFins'] = radiatorFins;
    map['specificPhenomena'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['handingInCheck'] = handingInCheck;
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
    return ![voice, caseSubstation, subOilTankLevel, color, insulation,
      contactHeatGeneration, groundingSystem, desiccantColor, radiatorFins, specificPhenomena, possibleProblematic, handingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }
}

