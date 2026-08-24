// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';

class LightSystemNight extends PopupBaseModel {
  int operatingStatus;
  int possibleProblematic;
  int handlingInCheck;
  bool isExist;
  LightSystemNight({
      this.operatingStatus,
      this.isExist = true,
      this.possibleProblematic, 
      this.handlingInCheck,});

  LightSystemNight.fromJson(JSON json) {
    isExist = json['isExist']?.boolean ?? true;
    operatingStatus = json['operatingStatus'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    specificPhenomena = json['specificPhenomena'].string;
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isExist'] = isExist;
    map['operatingStatus'] = operatingStatus;
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
    if (isExist == false) {
      return true;
    }
    return ![operatingStatus, possibleProblematic, specificPhenomena, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }

}

