// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';
import '../../popup_base_model.dart';

class JointNightTime extends PopupBaseModel {
  int operatingStatus;
  String temperature;
  int possibleProblematic;
  int handlingInCheck;

  JointNightTime({
    this.operatingStatus,
    this.temperature,
    this.possibleProblematic,
    this.handlingInCheck,
  });

  JointNightTime.fromJson(JSON json) {
    operatingStatus = json['operatingStatus'].integer;
    temperature = json['temperature'].string;
    description = json['description'].string;
    specificPhenomena = json['specificPhenomena'].string;
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
    map['operatingStatus'] = operatingStatus;
    map['temperature'] = temperature;
    map['specificPhenomena'] = specificPhenomena;
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

  JointNightTime copy() {
    final copyModel = JointNightTime.fromJson(JSON(toJson()));
    copyModel.unusually = unusually;
    return copyModel;
  }

  @override
  bool validateData() {
    return ![operatingStatus, temperature, specificPhenomena, possibleProblematic, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }
}

