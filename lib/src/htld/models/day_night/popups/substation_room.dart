// @dart=2.9
import 'package:evnmobile/src/htld/models/attach_image_model.dart';
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:g_json/g_json.dart';

class SubstationRoom extends PopupBaseModel {
  int entrance;
  int vent;
  int lighting;
  int shield;
  int possibleProblematic;
  int handlingInCheck;
  int isExist;
  String title;

  SubstationRoom copy() {
    final data = SubstationRoom(
        isExist: isExist,
        entrance: entrance,
        vent: vent,
        lighting: lighting,
        shield: shield,
        possibleProblematic: possibleProblematic,
        handlingInCheck: handlingInCheck,
        title: title
    );

    data.images = images;
    data.suggestedHandlingOfAbnormal = suggestedHandlingOfAbnormal;
    data.specificPhenomena = specificPhenomena;

    return data;
  }

  SubstationRoom({
      this.isExist,
      this.entrance, 
      this.vent, 
      this.lighting, 
      this.shield, 
      this.possibleProblematic,
      this.handlingInCheck,
      this.title
  });

  SubstationRoom.fromJson(JSON json) {
    entrance = json['entrance'].integer;
    vent = json['vent'].integer;
    lighting = json['lighting'].integer;
    shield = json['shield'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingInCheck = json['handlingInCheck'].integer;
    isExist = json['isExist'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    if (json['images'] != null) {
      final data = json['images']?.list;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['entrance'] = entrance;
    map['vent'] = vent;
    map['lighting'] = lighting;
    map['shield'] = shield;
    map['specificPhenomena'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingInCheck'] = handlingInCheck;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['description'] = description;
    map['isExist'] = isExist;
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
    if (isExist != CKOptions.first.value) {
      return true;
    }

    return ![entrance, vent, lighting, shield, specificPhenomena, possibleProblematic, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }

}

