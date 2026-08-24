// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../attach_image_model.dart';
import '../problem_positions_model.dart';

class LineJoint extends PopupBaseModel{
  int jointSituation;
  String jointTemperature;
  int possibleProblematic;
  int jointHandlingImmediatelyInspection;

  LineJoint({
      this.jointSituation, 
      this.jointTemperature, 
      this.possibleProblematic,
      this.jointHandlingImmediatelyInspection, 
      });

  LineJoint.fromJson(JSON json) {
    jointSituation = json['jointSituation'].integer;
    jointTemperature = json['temperature'].string;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    jointHandlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    if (json['images'].list != null) {
      images = [];
      json['images']?.list?.forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json['problemPositions'] != null) {
      problemPositions = json['problemPositions']?.list?.map((e) => ProblemPositions.fromJson(e))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jointSituation'] = jointSituation;
    map['temperature'] = jointTemperature;
    map['specificPhenomena'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingImmediatelyInspection'] = jointHandlingImmediatelyInspection;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['description'] = description;
    if (images != null) {
      map['images'] = images.map((v) => v.toJson()).toList();
    }
    if (problemPositions != null) {
      map['problemPositions'] = problemPositions.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      map['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  bool validateData() {
    return ![
      jointTemperature,
      specificPhenomena,
      possibleProblematic,
      jointHandlingImmediatelyInspection,
      suggestedHandlingOfAbnormal,
    ].contains(null)  &&
        problemPositions.firstWhere((element) => element.problemValue == null, orElse: () => null) == null;
  }
}
