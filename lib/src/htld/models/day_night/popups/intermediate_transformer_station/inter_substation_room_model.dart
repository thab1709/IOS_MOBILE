// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';

/// entrance : 1
/// vent : 1
/// lighting : 1
/// barrierNet : 1
/// images : [{"imageStorageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","url":"string","problems":0}]

class InterSubstationRoomModel extends PopupBaseModel {
  int entrance;
  int vent;
  int lighting;
  int barrierNet;
  int isExist;

  InterSubstationRoomModel({
    this.entrance,
    this.vent,
    this.lighting,
    this.barrierNet,
    this.isExist,
  });

  InterSubstationRoomModel copy() {
    final data = InterSubstationRoomModel(
        isExist: isExist,
        entrance: entrance,
        vent: vent,
        lighting: lighting,
        barrierNet: barrierNet,);

    data.images = images;
    data.suggestedHandlingOfAbnormal = suggestedHandlingOfAbnormal;
    data.specificPhenomena = specificPhenomena;

    return data;
  }

  InterSubstationRoomModel.fromJson(JSON json) {
    entrance = json['entrance'].integer;
    vent = json['vent'].integer;
    lighting = json['lighting'].integer;
    barrierNet = json['barrierNet'].integer;
    isExist = json['isExist'].integer;
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
    map['entrance'] = entrance;
    map['vent'] = vent;
    map['lighting'] = lighting;
    map['barrierNet'] = barrierNet;
    map['isExist'] = isExist;
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
    if (isExist != CKOptions.first.value) {
      return true;
    }
    return ![entrance, vent, lighting, barrierNet].contains(null);
  }

}
