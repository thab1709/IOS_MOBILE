// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class DistributionBuildingStructureModel extends PopupBaseModel {
  int safetyCorridor;
  int illumination;
  int industrialHygiene;
  int beams;
  int columnFoot;
  int columns;
  int ropes;
  int bolts;
  int safetySigns;
  int columnsNumber;
  //int structures;
  int firePrevention;
  int wireToConnect;
  int penetration;
  int isExist;

  DistributionBuildingStructureModel({
      this.safetyCorridor, 
      this.illumination, 
      this.industrialHygiene, 
      this.beams,
      this.columnFoot, 
      this.columns, 
      this.ropes,
      this.bolts, 
      this.safetySigns, 
      this.columnsNumber, 
      //this.structures,
      this.firePrevention, 
      this.wireToConnect, 
      this.penetration, 
      });

  DistributionBuildingStructureModel.fromJson(JSON json) {
    safetyCorridor = json['safetyCorridor'].integer;
    illumination = json['illumination'].integer;
    industrialHygiene = json['industrialHygiene'].integer;
    beams = json['beams'].integer;
    columnFoot = json['columnFoot'].integer;
    columns = json['columns'].integer;
    beams = json['beams'].integer;
    ropes = json['ropes'].integer;
    bolts = json['bolts'].integer;
    isExist = json['isExist'].integer;
    safetySigns = json['safetySigns'].integer;
    columnsNumber = json['columnsNumber'].integer;
    //structures = json['structures'].integer;
    firePrevention = json['firePrevention'].integer;
    wireToConnect = json['wireToConnect'].integer;
    penetration = json['penetration'].integer;
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
    map['isExist'] = isExist;
    map['safetyCorridor'] = safetyCorridor;
    map['illumination'] = illumination;
    map['industrialHygiene'] = industrialHygiene;
    map['beams'] = beams;
    map['columnFoot'] = columnFoot;
    map['columns'] = columns;
    map['beams'] = beams;
    map['ropes'] = ropes;
    map['bolts'] = bolts;
    map['safetySigns'] = safetySigns;
    map['columnsNumber'] = columnsNumber;
    //map['structures'] = structures;
    map['firePrevention'] = firePrevention;
    map['wireToConnect'] = wireToConnect;
    map['penetration'] = penetration;
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
    return ![safetyCorridor, illumination, industrialHygiene, beams,
      columnFoot, columns, beams, ropes, bolts, safetySigns,
      columnsNumber, firePrevention, wireToConnect, penetration].contains(null);
  }


}

