// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';
import '../../../popup_base_model.dart';

class InterResistanceTemperatureDetector extends PopupBaseModel {
  int status;
  int selfUsedSystem;
  int lightingSystem;

  InterResistanceTemperatureDetector({
      this.status,
      this.selfUsedSystem, 
      this.lightingSystem, 
      });

  InterResistanceTemperatureDetector.fromJson(JSON json)  {
    status = json['status'].integer;
    selfUsedSystem = json['selfUsedSystem'].integer;
    lightingSystem = json['lightingSystem'].integer;
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
    map['status'] = status;
    map['selfUsedSystem'] = selfUsedSystem;
    map['lightingSystem'] = lightingSystem;
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

    return ![status, selfUsedSystem, lightingSystem].contains(null);
  }

}

