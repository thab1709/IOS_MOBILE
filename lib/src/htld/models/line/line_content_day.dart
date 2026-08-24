// @dart=2.9
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/line/line_rights_of_way.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:g_json/g_json.dart';

import '../equipment_model.dart';
import 'line_insulation_content.dart';
import 'line_joint.dart';
import 'line_wire.dart';

class LineContentModel {
  LineRightsOfWay lineRightsOfWay;
  LineInsulationContent lineInsulationContent;
  LineJoint lineJoint;
  LineWire lineWire;
  List<PopupsDataModel> popups;
 // List<EquipmentModel> substations;
  List<EquipmentModel> underGroundCables;
  List<EquipmentModel> tis;
  List<EquipmentModel> tus;
  List<EquipmentModel> rmus;
  List<EquipmentModel> breakers;
  List<EquipmentModel> capacitor;
  String specificPhenomena;
  String processed;
  bool isUpdateOffline;

  LineContentModel() {
      lineInsulationContent = LineInsulationContent();
      lineJoint = LineJoint();
      lineWire = LineWire();
      lineRightsOfWay = LineRightsOfWay();
      tis = List.empty();
      tus = List.empty();
      rmus = List.empty();
      breakers = List.empty();
      capacitor = List.empty();
      underGroundCables = List.empty();
      popups = List.empty();
  }

  LineContentModel.fromJson(JSON json) {
    lineInsulationContent = LineInsulationContent.fromJson(json['lineInsulation']);
    lineJoint = LineJoint.fromJson(json['lineJoint']);
    lineWire = LineWire.fromJson(json['lineWire']);
    lineRightsOfWay = LineRightsOfWay.fromJson(json['lineRightsOfWay']);
    specificPhenomena = json['specificPhenomena'].string;
    processed = json['processed'].string;
    isUpdateOffline = json['isUpdateOffline']?.boolean ?? false;
    if (json['popups'].list != null) {
      popups = json['popups']?.list?.map((e) => PopupsDataModel.fromJson(e))?.toList();
    }
    // if (json['substations'].list != null) {
    //   substations = json['substations']?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    // }

    if (json['undergroundCable'].list != null) {
      underGroundCables = json['undergroundCable']?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    }

    if (json['tu'].list != null) {
      tus = json['tu']?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    }

    if (json['rmu'].list != null) {
      rmus = json['rmu']?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    }

    if (json['ti'].list != null) {
      tis = json['ti']?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    }

    if (json['breaker'].list != null) {
      breakers = json['breaker']?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    }

    if (json['capacitor'].list != null) {
      capacitor = json['capacitor']?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    }
  }

  Map<String, dynamic> toUpdateJson(TicketType ticketType) {
    if (ticketType != TicketType.periodicNight) {
      return {
        'lineRightsOfWay': lineRightsOfWay.toJson(),
        'specificPhenomena': specificPhenomena,
        'isExist': getAbnormalPhenomenonOffline()?.isNotEmpty == true,
        'processed': processed,
      };
    } else {
      return {
        'lineInsulation': lineInsulationContent.toJson(),
        'lineJoint': lineJoint.toJson(),
        'lineWire': lineWire.toJson(),
        'specificPhenomena': specificPhenomena,
        'isExist': getAbnormalPhenomenonOffline()?.isNotEmpty == true,
        'processed': processed,
      };
    }
  }

  Map<String, dynamic> toDataJson() {
      final map = <String, dynamic>{};
      map['specificPhenomena'] =  specificPhenomena;
      map['processed'] = processed;
      map['lineInsulation'] = lineInsulationContent.toJson();
      map['lineJoint'] = lineJoint.toJson();
      map['lineWire'] = lineWire.toJson();
      map['isUpdateOffline'] = isUpdateOffline ?? false;
      map['lineRightsOfWay'] = lineRightsOfWay.toJson();
      if (popups != null) {
        map['popups'] = popups.map((v) => v.toJson()).toList();
      }
      if (underGroundCables != null) {
        map['undergroundCable'] = underGroundCables.map((v) => v.toMap()).toList();
      }
      if (tis != null) {
        map['ti'] = tis.map((v) => v.toMap()).toList();
      }
      if (tus != null) {
        map['tu'] = tus.map((v) => v.toMap()).toList();
      }
      if (rmus != null) {
        map['rmu'] = rmus.map((v) => v.toMap()).toList();
      }
      if (breakers != null) {
        map['breaker'] = breakers.map((v) => v.toMap()).toList();
      }
      if (capacitor != null) {
        map['capacitor'] = capacitor.map((v) => v.toMap()).toList();
      }
      return map;

  }

  bool _validateData(){
    return ![processed, specificPhenomena].contains(null);
  }



  String getAbnormalPhenomenonOffline(){
    final insulationDes = '${lineInsulationContent?.description ?? ''}${lineInsulationContent?.description?.isNotEmpty == true ? '\n' : ''}';
    final jointDes = '${lineJoint?.description ?? ''}${lineJoint?.description?.isNotEmpty == true ? '\n' : ''}';
    final wireDes = '${lineWire?.description ?? ''}${lineWire?.description?.isNotEmpty == true ? '\n' : ''}';
    final rightsOfWay = '${lineRightsOfWay?.description ?? ''}${lineRightsOfWay?.description?.isNotEmpty == true ? '\n' : ''}';
    return '$insulationDes$jointDes$wireDes$rightsOfWay';
  }

  bool validateDataNight(){
    return
      lineInsulationContent.validateData() &&
        lineJoint.validateData() &&
        lineWire.validateData()
        && _validateData();
  }


  bool validateDataIncidentOrDay(){
    return lineRightsOfWay.validateData() && _validateData();
  }
}
