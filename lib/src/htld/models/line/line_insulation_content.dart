// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../attach_image_model.dart';
import '../problem_positions_model.dart';

class LineInsulationContent extends PopupBaseModel {
  String damaged;
  String materialClingToInsulation;
  int electricDischarge;
  int handlingImmediatelyInspection;
  int possibleProblematic;

  LineInsulationContent({
      this.damaged, 
      this.materialClingToInsulation, 
      this.electricDischarge,
      this.handlingImmediatelyInspection, 
      this.possibleProblematic, 
      });

  LineInsulationContent.fromJson(JSON json) {
    damaged = json['damaged'].string;
    materialClingToInsulation = json['materialClingToInsulation'].string;
    electricDischarge = json['electricDischarge'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    handlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    if (json['images'].list != null) {
      images = [];
      json['images']?.list?.forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json['problemPositions'].list != null) {
      problemPositions = [];
      json['problemPositions']?.list?.forEach((v) {
        problemPositions.add(ProblemPositions.fromJson(v));
      });
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['damaged'] = damaged;
    map['materialClingToInsulation'] = materialClingToInsulation;
    map['electricDischarge'] = electricDischarge;
    map['specificPhenomena'] = specificPhenomena;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
    map['possibleProblematic'] = possibleProblematic;
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
          //damaged,
          //materialClingToInsulation,
          electricDischarge,
          specificPhenomena,
          handlingImmediatelyInspection,
          possibleProblematic,
          suggestedHandlingOfAbnormal,
        ].contains(null);
  }

}

