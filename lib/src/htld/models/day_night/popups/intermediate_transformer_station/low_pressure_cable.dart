// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';

class LowPressureCable extends PopupBaseModel {
  int operatingStatus;
  String voltage;
  int problems;
  int handlingImmediatelyInspection;

  LowPressureCable({
    this.operatingStatus,
    this.voltage,
    this.problems,
    this.handlingImmediatelyInspection,
  });

  LowPressureCable.fromJson(JSON data) {
    operatingStatus = data['operatingStatus'].integer;
    voltage = data['voltage'].string;
    specificPhenomena = data['specificPhenomena'].string;
    problems = data['problems'].integer;
    handlingImmediatelyInspection = data['handlingImmediatelyInspection'].integer;
    suggestedHandlingOfAbnormal = data['suggestedHandlingOfAbnormal'].string;
    description = data['description'].string;
    if (data['images'] != null) {
      final listImage = data['images'].listObject;
      images = listImage?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        data['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['operatingStatus'] = operatingStatus;
    map['voltage'] = voltage;
    map['specificPhenomena'] = specificPhenomena;
    map['problems'] = problems;
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
    return ![operatingStatus, voltage, specificPhenomena, problems, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }
}

