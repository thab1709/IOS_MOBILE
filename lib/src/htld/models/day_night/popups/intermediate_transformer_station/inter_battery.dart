// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterBattery extends PopupBaseModel {
  int operatingStatus;
  String voltage;
  String auxiliaryCurrent;
  int handlingImmediatelyInspection;
  int possibleProblematic;

  InterBattery({
      this.operatingStatus, 
      this.voltage, 
      this.handlingImmediatelyInspection,
      this.possibleProblematic, 
      });

  InterBattery.fromJson(JSON data) {
    operatingStatus = data['operatingStatus'].integer;
    voltage = data['voltage'].string;
    auxiliaryCurrent = data['auxiliaryCurrent'].string;
    specificPhenomena = data['specificPhenomena'].string;
    handlingImmediatelyInspection = data['handlingImmediatelyInspection'].integer;
    possibleProblematic = data['possibleProblematic'].integer;
    suggestedHandlingOfAbnormal = data['suggestedHandlingOfAbnormal'].string;
    description = data['description'].string;
    if (data['images'] != null) {
      images = [];
      data['images']?.list?.forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    abnormals =
        data['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['operatingStatus'] = operatingStatus;
    map['voltage'] = voltage;
    map['auxiliaryCurrent'] = auxiliaryCurrent;
    map['specificPhenomena'] = specificPhenomena;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
    map['possibleProblematic'] = possibleProblematic;
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
    return ![operatingStatus, voltage, auxiliaryCurrent, specificPhenomena, handlingImmediatelyInspection, possibleProblematic, suggestedHandlingOfAbnormal].contains(null);
  }

}

