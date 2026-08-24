// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';

class AlternatingCurrentSystem extends PopupBaseModel {
  int operatingStatus;
  String voltage;
  int handlingImmediatelyInspection;
  int possibleProblematic;
  String resistorInsulation;

  AlternatingCurrentSystem({
      this.operatingStatus, 
      this.voltage, 
      this.handlingImmediatelyInspection,
      });

  AlternatingCurrentSystem.fromJson(JSON data) {
      operatingStatus = data['operatingStatus'].integer;
      resistorInsulation = data['resistorInsulation'].string;
      voltage = data['voltage'].string;
      specificPhenomena = data['specificPhenomena'].string;
      possibleProblematic = data['possibleProblematic'].integer;
      handlingImmediatelyInspection = data['handlingImmediatelyInspection'].integer;
      suggestedHandlingOfAbnormal = data['suggestedHandlingOfAbnormal'].string;
      description = data['description'].string;
      if (data['images'] != null) {
        images = data['images']?.list?.map((e) => Images.fromJson(e))?.toList();
      }
      abnormals =
          data['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['operatingStatus'] = operatingStatus;
    map['voltage'] = voltage;
    map['resistorInsulation'] = resistorInsulation;
    map['specificPhenomena'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
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
    if (specificPhenomena == null ||
        specificPhenomena.isEmpty ||
        suggestedHandlingOfAbnormal == null ||
        suggestedHandlingOfAbnormal.isEmpty ||
        voltage == null ||
        voltage.isEmpty ||
        resistorInsulation == null ||
        resistorInsulation.isEmpty) {
      return false;
    }

    return ![operatingStatus, voltage, resistorInsulation, specificPhenomena, possibleProblematic, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }

}


