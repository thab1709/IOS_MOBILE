// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class FallOfFuses extends PopupBaseModel {
  int insulation;
  int fuseHolder;
  int bolts;
  int sound;
  int joint;
  int handleActionLock;
  int possibleProblematic;
  int handlingInCheck;

  FallOfFuses({
      this.insulation, 
      this.fuseHolder, 
      this.bolts, 
      this.sound, 
      this.joint, 
      this.handleActionLock, 
      this.possibleProblematic, 
      this.handlingInCheck,
      });

  FallOfFuses.fromJson(JSON json) {
    insulation = json['insulation'].integer;
    fuseHolder = json['fuseHolder'].integer;
    bolts = json['bolts'].integer;
    sound = json['sound'].integer;
    joint = json['joint'].integer;
    handleActionLock = json['handleActionLock'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    handlingInCheck = json['handlingInCheck'].integer;
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
    map['insulation'] = insulation;
    map['fuseHolder'] = fuseHolder;
    map['bolts'] = bolts;
    map['sound'] = sound;
    map['joint'] = joint;
    map['handleActionLock'] = handleActionLock;
    map['possibleProblematic'] = possibleProblematic;
    map['specificPhenomena'] = specificPhenomena;
    map['handlingInCheck'] = handlingInCheck;
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
    return ![insulation, fuseHolder, bolts, sound, joint, handlingInCheck, possibleProblematic, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }

}

