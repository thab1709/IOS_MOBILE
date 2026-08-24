// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';
import '../../popup_base_model.dart';

class LowVoltageCapacitoModel extends PopupBaseModel {
  int condition;
  int connector;
  int sound;
  int grounding;
  int systemProtection;
  int capacitorDisplay;
  int compensationCable;
  int possibleProblematic;
  int handlingInCheck;

  LowVoltageCapacitoModel({
      this.condition, 
      this.connector, 
      this.sound, 
      this.grounding, 
      this.systemProtection, 
      this.capacitorDisplay, 
      this.compensationCable, 
      this.possibleProblematic, 
      this.handlingInCheck,});

  LowVoltageCapacitoModel.fromJson(JSON json) {
    condition = json['condition'].integer;
    connector = json['connector'].integer;
    sound = json['sound'].integer;
    grounding = json['grounding'].integer;
    systemProtection = json['systemProtection'].integer;
    capacitorDisplay = json['capacitorDisplay'].integer;
    compensationCable = json['compensationCable'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
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
    map['condition'] = condition;
    map['connector'] = connector;
    map['sound'] = sound;
    map['grounding'] = grounding;
    map['systemProtection'] = systemProtection;
    map['capacitorDisplay'] = capacitorDisplay;
    map['compensationCable'] = compensationCable;
    map['possibleProblematic'] = possibleProblematic;
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
    return ![condition, connector, sound, grounding,
      systemProtection, capacitorDisplay, compensationCable,
      possibleProblematic, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }

}

