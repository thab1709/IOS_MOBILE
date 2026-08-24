// @dart=2.9
import 'package:g_json/g_json.dart';
import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterLightningConductor extends PopupBaseModel {
  int insulation;
  int contactAtInsulation;
  int sound;
  int joint;
  int grounding;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterLightningConductor({
      this.insulation, 
      this.contactAtInsulation, 
      this.sound, 
      this.joint, 
      this.grounding,
      this.possibleProblematic,
      this.handlingImmediatelyInspection,
  });

  InterLightningConductor.fromJson(JSON json) {
    insulation = json['insulation'].integer;
    contactAtInsulation = json['contactAtInsulation'].integer;
    sound = json['sound'].integer;
    joint = json['joint'].integer;
    grounding = json['grounding'].integer;
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
    map['insulation'] = insulation;
    map['contactAtInsulation'] = contactAtInsulation;
    map['sound'] = sound;
    map['joint'] = joint;
    map['grounding'] = grounding;
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
    return ![insulation, contactAtInsulation, sound, joint, grounding, possibleProblematic, handlingImmediatelyInspection, specificPhenomena, suggestedHandlingOfAbnormal].contains(null);
  }

}
