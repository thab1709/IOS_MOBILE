// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';
import '../../popup_base_model.dart';

class SubstationNightTime extends PopupBaseModel {
  int unusualSound;
  int possibleProblematic;
  int handlingInCheck;
  SubstationNightTime({
      int unusualSound,
      String abnormalPhenomenon,
      String description,
      int possibleProblematic,
      int handlingInCheck,
      String suggestedHandlingOfAbnormal,
      List<Images> images}){
    unusualSound = unusualSound;
    abnormalPhenomenon = abnormalPhenomenon;
    description = description;
    possibleProblematic = possibleProblematic;
    handlingInCheck = handlingInCheck;
    suggestedHandlingOfAbnormal = suggestedHandlingOfAbnormal;
    images = images;
}

  SubstationNightTime.fromJson(JSON json) {
    unusualSound = json['unusualSound'].integer;
    specificPhenomena = json['abnormalPhenomenon'].string;
    description = json['description'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingInCheck = json['handlingInCheck'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    if (json['images'].list != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson({bool includeImageURL = true}) {
    final map = <String, dynamic>{};
    map['unusualSound'] = unusualSound;
    map['abnormalPhenomenon'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingInCheck'] = handlingInCheck;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['description'] = description;
    if (images != null) {
      map['images'] = images.map((v) => includeImageURL ? v.toJson() : v.toJsonWithoutURL()).toList();
    }
    if (abnormals != null) {
      map['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return map;
  }

  SubstationNightTime copy() {
    final copyModel = SubstationNightTime.fromJson(JSON(toJson()));
    copyModel.unusually = unusually;
    return copyModel;
  }

  @override
  bool validateData() {
    return ![unusualSound, specificPhenomena, possibleProblematic, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }

}

