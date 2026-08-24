// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterClampRow extends PopupBaseModel {
  int condition;
  int lightSignal;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterClampRow({
      this.condition, 
      this.lightSignal, 
      this.possibleProblematic,
      this.handlingImmediatelyInspection, 
      });

  @override
  InterClampRow.fromJson(JSON json) {
    condition = json['condition'].integer;
    lightSignal = json['lightSignal'].integer;
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
    map['condition'] = condition;
    map['lightSignal'] = lightSignal;
    map['specificPhenomena'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
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
    return ![condition, lightSignal, specificPhenomena, possibleProblematic, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }
}

