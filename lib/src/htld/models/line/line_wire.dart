// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../attach_image_model.dart';
import '../problem_positions_model.dart';

class LineWire extends PopupBaseModel {
  int unusualSound;
  String materialClingingToWire;
  int electricDischarge;
  String saggingValue;
  int handlingImmediatelyInspection;
  int possibleProblematic;

  LineWire({
      this.unusualSound, 
      this.materialClingingToWire, 
      this.electricDischarge, 
      this.saggingValue, 
      this.handlingImmediatelyInspection,
      this.possibleProblematic, 
      });

  LineWire.fromJson(JSON json) {
    unusualSound = json['unusualSound'].integer;
    materialClingingToWire = json['materialClingingToWire'].string;
    electricDischarge = json['electricDischarge'].integer;
    saggingValue = json['saggingValue'].string;
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
    map['unusualSound'] = unusualSound;
    map['materialClingingToWire'] = materialClingingToWire;
    map['electricDischarge'] = electricDischarge;
    map['saggingValue'] = saggingValue;
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
    return ![unusualSound,materialClingingToWire,electricDischarge, specificPhenomena, suggestedHandlingOfAbnormal].contains(null);
  }

}


