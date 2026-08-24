// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';

class InterInsulation extends PopupBaseModel {
  int condition;
  int sound;
  int insulationAccessories;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterInsulation({
      this.condition, 
      this.sound, 
      this.insulationAccessories,
      this.possibleProblematic,
      this.handlingImmediatelyInspection, 
    });

  InterInsulation.fromJson(JSON json) {
    condition = json['condition'].integer;
    sound = json['sound'].integer;
    insulationAccessories = json['insulationAccessories'].integer;
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
    map['condition'] = condition;
    map['sound'] = sound;
    map['insulationAccessories'] = insulationAccessories;
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
    return ![condition, sound, insulationAccessories, possibleProblematic, handlingImmediatelyInspection, specificPhenomena, suggestedHandlingOfAbnormal].contains(null);
  }
}

