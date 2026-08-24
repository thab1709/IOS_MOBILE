// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class DistributionPowerCableModel extends PopupBaseModel {
  int possibleProblematic;
  int handlingInCheck;
  int mediumVoltageCable;
  int lowVoltageCable;

  DistributionPowerCableModel({
      this.possibleProblematic, 
      this.handlingInCheck, 
      this.mediumVoltageCable,
      this.lowVoltageCable, 
      });

  DistributionPowerCableModel.fromJson(JSON json) {
    possibleProblematic = json['possibleProblematic'].integer;
    handlingInCheck = json['handlingInCheck'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    mediumVoltageCable = json['mediumVoltageCable'].integer;
    lowVoltageCable = json['lowVoltageCable'].integer;
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
    map['possibleProblematic'] = possibleProblematic;
    map['handlingInCheck'] = handlingInCheck;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['mediumVoltageCable'] = mediumVoltageCable;
    map['lowVoltageCable'] = lowVoltageCable;
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
    if (
        suggestedHandlingOfAbnormal == null ||
        suggestedHandlingOfAbnormal.isEmpty) {
      return false;
    }

    return true;
  }

}

