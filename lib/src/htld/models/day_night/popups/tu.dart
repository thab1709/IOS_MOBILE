// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class TUModel extends PopupBaseModel {
  int insulation;
  int contactAtTerminals;
  int sound;
  int handlingInCheck;
  int possibleProblematic;

  TUModel({
      this.insulation, 
      this.contactAtTerminals, 
      this.sound, 
      this.handlingInCheck,
      });

  TUModel.fromJson(JSON json) {
    insulation = json['insulation'].integer;
    contactAtTerminals = json['contactAtTerminals'].integer;
    sound = json['sound'].integer;
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
    map['contactAtTerminals'] = contactAtTerminals;
    map['sound'] = sound;
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
    return ![insulation, contactAtTerminals, sound, possibleProblematic, specificPhenomena, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }

}

