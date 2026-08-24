// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class DistributionGroundingSystem extends PopupBaseModel {
  int groundWire;
  int theContact;
  int neutralGround;
  int possibleProblematic;
  int safeGrounding;
  int handlingInCheck;

  DistributionGroundingSystem({
      this.groundWire, 
      this.theContact, 
      this.neutralGround, 
      this.possibleProblematic, 
      this.safeGrounding, 
      this.handlingInCheck});

  DistributionGroundingSystem.fromJson(JSON json) {
    groundWire = json['groundWire'].integer;
    theContact = json['theContact'].integer;
    neutralGround = json['neutralGround'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    safeGrounding = json['safeGrounding'].integer;
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
    map['groundWire'] = groundWire;
    map['theContact'] = theContact;
    map['neutralGround'] = neutralGround;
    map['possibleProblematic'] = possibleProblematic;
    map['safeGrounding'] = safeGrounding;
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
    return ![groundWire, theContact, neutralGround, possibleProblematic, safeGrounding, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }

}

