// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class LightingSystemNightTime extends PopupBaseModel {
  int operatingStatus;
  int possibleProblematic;
  int handlingInCheck;
  bool isExist;

  LightingSystemNightTime({
      int operatingStatus,
      int possibleProblematic,
      String specificPhenomena,
      int handlingInCheck,
      String description,
      String suggestedHandlingOfAbnormal,
      List<Images> images}){
    operatingStatus = operatingStatus;
    possibleProblematic = possibleProblematic;
    specificPhenomena = specificPhenomena;
    handlingInCheck = handlingInCheck;
    description = description;
    suggestedHandlingOfAbnormal = suggestedHandlingOfAbnormal;
    images = images;
}

  LightingSystemNightTime.fromJson(JSON json) {
    operatingStatus = json['operatingStatus'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    description = json['description'].string;
    handlingInCheck = json['handlingInCheck'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    isExist = json['isExist'].boolean;

    if (json['images'].list != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson({bool includeImageURL = true}) {
    final map = <String, dynamic>{};
    map['isExist'] = isExist;
    map['operatingStatus'] = operatingStatus;
    map['possibleProblematic'] = possibleProblematic;
    map['specificPhenomena'] = specificPhenomena;
    map['handlingInCheck'] = handlingInCheck;
    map['description'] = description;
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

  LightingSystemNightTime copy() {
    final copyModel = LightingSystemNightTime.fromJson(JSON(toJson()));
    copyModel.unusually = unusually;
    return copyModel;
  }

  @override
  bool validateData() {
    if (isExist == false) {
      return true;
    }
    return ![operatingStatus, possibleProblematic, specificPhenomena, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }
}

