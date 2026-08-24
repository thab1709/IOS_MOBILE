// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class LightningConductor extends PopupBaseModel {
  int insulation;
  int sound;
  int deviceGrounding;
  int handlingInCheck;
  int possibleProblematic;

  LightningConductor({
      this.insulation, 
      this.sound, 
      this.deviceGrounding, 
      this.handlingInCheck,
      });

  LightningConductor.fromJson(JSON json) {
    insulation = json['insulation'].integer;
    sound = json['sound'].integer;
    deviceGrounding = json['deviceGrounding'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingInCheck = json['handlingInCheck'].integer;
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
    map['insulation'] = insulation;
    map['possibleProblematic'] = possibleProblematic;
    map['sound'] = sound;
    map['deviceGrounding'] = deviceGrounding;
    map['handlingInCheck'] = handlingInCheck;
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

  LightningConductor copy() {
    final model = LightningConductor.fromJson(JSON(toJson()));
    return model;
  }

  @override
  bool validateData() {
    return ![insulation, possibleProblematic, sound, deviceGrounding, handlingInCheck, specificPhenomena, suggestedHandlingOfAbnormal].contains(null);
  }
}

