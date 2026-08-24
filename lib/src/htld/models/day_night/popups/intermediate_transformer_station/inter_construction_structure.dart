// @dart=2.9
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterConstructionStructure extends PopupBaseModel {
  int condition;
  int beamSystem;
  int bolt;
  int columns;
  int bracket;
  int foundation;
  int ropes;
  int weld;
  int ground;
  int covers;
  //int operator;
  int possibleProblematic;
  int handlingImmediatelyInspection;
  int isExist;
  InterConstructionStructure({
      this.condition, 
      this.beamSystem, 
      this.bolt, 
      this.columns, 
      this.bracket, 
      this.foundation, 
      this.ropes, 
      this.weld, 
      this.ground, 
      this.covers, 
      //this.operator,
      this.possibleProblematic,
      this.handlingImmediatelyInspection, 
      });

  @override
  InterConstructionStructure.fromJson(JSON json) {
    isExist = json['isExist'].integer;
    condition = json['condition'].integer;
    beamSystem = json['beamSystem'].integer;
    bolt = json['bolt'].integer;
    columns = json['columns'].integer;
    bracket = json['bracket'].integer;
    foundation = json['foundation'].integer;
    ropes = json['ropes'].integer;
    weld = json['weld'].integer;
    ground = json['ground'].integer;
    covers = json['covers'].integer;
    //operator = json['operator'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    specificPhenomena = json['specificPhenomena'].string;
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
    map['isExist'] = isExist;
    map['condition'] = condition;
    map['beamSystem'] = beamSystem;
    map['bolt'] = bolt;
    map['columns'] = columns;
    map['bracket'] = bracket;
    map['foundation'] = foundation;
    map['ropes'] = ropes;
    map['weld'] = weld;
    map['ground'] = ground;
    map['covers'] = covers;
    //map['operator'] = operator;
    map['possibleProblematic'] = possibleProblematic;
    map['specificPhenomena'] = specificPhenomena;
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
    if (isExist != CKOptions.first.value) {
      return true;
    }

    return ![condition, beamSystem, bolt, columns, bracket, foundation, ropes, weld, ground, covers, possibleProblematic, specificPhenomena, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }

}

