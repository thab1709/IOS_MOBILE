// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterElectricCabinet extends PopupBaseModel {
  int condition;
  int problems;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterElectricCabinet({
      this.condition, 
      this.problems,
      this.possibleProblematic,
      this.handlingImmediatelyInspection,
      });

  InterElectricCabinet.fromJson(JSON json) {
    condition = json['condition'].integer;
    specificPhenomena = json['specificPhenomena'].string;
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
    return ![condition, specificPhenomena, possibleProblematic, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }

}

