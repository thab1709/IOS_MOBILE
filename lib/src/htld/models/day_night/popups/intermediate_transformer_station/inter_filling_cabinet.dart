// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class FillingCabinet extends PopupBaseModel {
  int operatingStatus;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  FillingCabinet({
      this.operatingStatus, 
      this.possibleProblematic,
      this.handlingImmediatelyInspection, 
  });

  FillingCabinet.fromJson(JSON data){
    operatingStatus = data['operatingStatus'].integer;
    specificPhenomena = data['specificPhenomena'].string;
    possibleProblematic = data['possibleProblematic'].integer;
    handlingImmediatelyInspection = data['handlingImmediatelyInspection'].integer;
    suggestedHandlingOfAbnormal = data['suggestedHandlingOfAbnormal'].string;
    description = data['description'].string;
    if (data['images'] != null) {
      final imgs = data['images'].listObject;
      images = imgs?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        data['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)));
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['operatingStatus'] = operatingStatus;
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
    return ![operatingStatus, specificPhenomena, possibleProblematic, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }

}

