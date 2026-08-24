// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../../attach_image_model.dart';


/// cuttingIndicator : 1
/// oilLevel : 1
/// insulation1 : 1
/// transmission : 1
/// electric : "string"
/// voltage : "string"
/// insulation2 : 1
/// connector : 1
/// fusingCircuit : 1
/// ground : 1
/// controlSource : 1
/// actuatorStatus : 1
/// switchingTimesNumber : "string"
/// specificPhenomena : "string"
/// problems : 1
/// handlingImmediatelyInspection : 1
/// suggestAbnormalDamaged : 1
/// images : [{"imageStorageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","url":"string","problems":0}]

class InterCuttingMachineModel extends PopupBaseModel {
  int cuttingIndicator;
  int oilLevel;
  int insulation1;
  int transmission;
  String electric;
  String voltage;
  int insulation2;
  int connector;
  int fusingCircuit;
  int ground;
  int controlSource;
  int actuatorStatus;
  String switchingTimesNumber;
  int possibleProblematic;
  int handlingImmediatelyInspection;

  InterCuttingMachineModel({
    this. cuttingIndicator,
    this. oilLevel,
    this. insulation1,
    this. transmission,
    this. electric,
    this. voltage,
    this. insulation2,
    this. connector,
    this. fusingCircuit,
    this. ground,
    this. controlSource,
    this. actuatorStatus,
    this. switchingTimesNumber,
    this. possibleProblematic,
     });

  InterCuttingMachineModel.fromJson(JSON json)  {
    cuttingIndicator = json['cuttingIndicator'].integer;
    oilLevel = json['oilLevel'].integer;
    insulation1 = json['insulation1'].integer;
    transmission = json['transmission'].integer;
    electric = json['electric'].string;
    voltage = json['voltage'].string;
    insulation2 = json['insulation2'].integer;
    connector = json['connector'].integer;
    fusingCircuit = json['fusingCircuit'].integer;
    ground = json['ground'].integer;
    controlSource = json['controlSource'].integer;
    actuatorStatus = json['actuatorStatus'].integer;
    switchingTimesNumber = json['switchingTimesNumber'].string;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
    if (json['images'] != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cuttingIndicator'] = cuttingIndicator;
    map['oilLevel'] = oilLevel;
    map['insulation1'] = insulation1;
    map['transmission'] = transmission;
    map['electric'] = electric;
    map['voltage'] = voltage;
    map['insulation2'] = insulation2;
    map['connector'] = connector;
    map['fusingCircuit'] = fusingCircuit;
    map['ground'] = ground;
    map['controlSource'] = controlSource;
    map['actuatorStatus'] = actuatorStatus;
    map['switchingTimesNumber'] = switchingTimesNumber;
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
    return ![cuttingIndicator, oilLevel, insulation1, transmission,
      electric, voltage, insulation2, connector, fusingCircuit,
      ground, controlSource, actuatorStatus, switchingTimesNumber, specificPhenomena, possibleProblematic, handlingImmediatelyInspection, suggestedHandlingOfAbnormal].contains(null);
  }
}
