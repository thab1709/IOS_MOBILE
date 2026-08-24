// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';
import '../../../attach_image_model.dart';

class InterVariableVoltage extends PopupBaseModel {
  int insulation;
  int cableContactPoint;
  int caseMachine;
  int ground;
  int oilColor;
  int oilLevel;
  int desiccantColor;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterVariableVoltage({
      this.insulation, 
      this.cableContactPoint, 
      this.caseMachine,
      this.ground, 
      this.oilColor, 
      this.oilLevel, 
      this.desiccantColor,
      this.possibleProblematic,
      this.handlingImmediatelyInspection,
  });

  @override
  InterVariableVoltage.fromJson(JSON json) {
    insulation = json['insulation'].integer;
    cableContactPoint = json['cableContactPoint'].integer;
    caseMachine = json['case'].integer;
    ground = json['ground'].integer;
    oilColor = json['oilColor'].integer;
    oilLevel = json['oilLevel'].integer;
    desiccantColor = json['desiccantColor'].integer;
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
    map['cableContactPoint'] = cableContactPoint;
    map['case'] = caseMachine;
    map['ground'] = ground;
    map['oilColor'] = oilColor;
    map['oilLevel'] = oilLevel;
    map['desiccantColor'] = desiccantColor;
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
    return ![insulation, cableContactPoint, caseMachine, ground, oilColor, oilLevel, desiccantColor, possibleProblematic, handlingImmediatelyInspection, specificPhenomena, suggestedHandlingOfAbnormal].contains(null);
  }
}
