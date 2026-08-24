// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';

class LowPressureCabinetModel extends PopupBaseModel {
  String uhA;
  String uhB;
  String uhC;
  String ihA;
  String ihB;
  String ihC;
  String i0;
  String cosA;
  String cosB;
  String cosC;
  int operationStatus;
  int appearance;
  int doorWedge;
  int clearance;
  int contactSurface;
  int fixedClamp;
  int meteringSystem;
  int workingMeter;
  int housingGrounding;
  int possibleProblematic;
  int handlingInCheck;

  LowPressureCabinetModel({
      this.uhA = '',
      this.uhB = '',
      this.uhC = '',
      this.ihA = '',
      this.ihB = '',
      this.ihC = '',
      this.i0 = '',
      this.cosA = '',
      this.cosB = '',
      this.cosC = '',
      this.operationStatus,
      this.appearance,
      this.doorWedge, 
      this.clearance, 
      this.contactSurface, 
      this.fixedClamp, 
      this.meteringSystem, 
      this.workingMeter, 
      this.housingGrounding,
      this.possibleProblematic,
      this.handlingInCheck, 
      });

  LowPressureCabinetModel.fromJson(JSON json) {
    //final json = jsonRaw['lowPressureCabinet'];
    uhA = json['uhA'].string;
    uhB = json['uhB'].string;
    uhC = json['uhC'].string;
    ihA = json['ihA'].string;
    ihB = json['ihB'].string;
    ihC = json['ihC'].string;
    i0 = json['i0'].string;
    cosA = json['cosA'].string;
    cosB = json['cosB'].string;
    cosC = json['cosC'].string;
    operationStatus = json['operationStatus'].integer;
    appearance = json['appearance'].integer;
    doorWedge = json['doorWedge'].integer;
    clearance = json['clearance'].integer;
    contactSurface = json['contactSurface'].integer;
    fixedClamp = json['fixedClamp'].integer;
    meteringSystem = json['meteringSystem'].integer;
    workingMeter = json['workingMeter'].integer;
    housingGrounding = json['housingGrounding'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingInCheck = json['handlingInCheck'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
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
    map['uhA'] = uhA;
    map['uhB'] = uhB;
    map['uhC'] = uhC;
    map['ihA'] = ihA;
    map['ihB'] = ihB;
    map['ihC'] = ihC;
    map['i0'] = i0;
    map['cosA'] = cosA;
    map['cosB'] = cosB;
    map['cosC'] = cosC;
    map['operationStatus'] = operationStatus;
    map['appearance'] = appearance;
    map['doorWedge'] = doorWedge;
    map['clearance'] = clearance;
    map['contactSurface'] = contactSurface;
    map['fixedClamp'] = fixedClamp;
    map['meteringSystem'] = meteringSystem;
    map['workingMeter'] = workingMeter;
    map['housingGrounding'] = housingGrounding;
    map['specificPhenomena'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingInCheck'] = handlingInCheck;
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

 void addValueForKey(String key, String value) {
    switch (key) {
      case 'uhA':
        uhA = value;
        break;
      case 'uhB':
        uhB = value;
        break;

      case 'uhC':
        uhC = value;
        break;

      case 'ihA':
        ihA = value;
        break;

      case 'ihB':
        ihB = value;
        break;

      case 'ihC':
        ihC = value;
        break;

      case 'i0':
        i0 = value;
        break;

      case 'cosA':
        cosA = value;
        break;

      case 'cosB':
        cosB = value;
        break;

      case 'cosC':
        cosC = value;
        break;
    }
  }

  @override
  bool validateData() {
    return ![uhA, uhB, uhC, ihA, ihB, ihC, i0, cosA, cosB, cosC,
      operationStatus,appearance, doorWedge, clearance, contactSurface, fixedClamp, meteringSystem, workingMeter,
      housingGrounding, specificPhenomena, handlingInCheck, suggestedHandlingOfAbnormal].contains(null);
  }

}

