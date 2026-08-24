// @dart=2.9
import 'package:evnmobile/src/htld/models/line/line_insulation_content.dart';
import 'package:evnmobile/src/htld/models/line/line_joint.dart';
import 'package:evnmobile/src/htld/models/line/line_wire.dart';
import 'package:g_json/g_json.dart';

import '../equipment_model.dart';

class LineContentNight{
  LineInsulationContent lineInsulationContent;
  LineJoint lineJoint;
  LineWire lineWire;
  String otherUnusualPhenomenon;
  List<EquipmentModel> substations;


  LineContentNight() {
    lineInsulationContent = LineInsulationContent();
    lineJoint = LineJoint();
    lineWire = LineWire();
  }

  LineContentNight.fromJson(JSON json) {
    lineInsulationContent = LineInsulationContent.fromJson(json['lineInsulationContent']);
    lineJoint = LineJoint.fromJson(json['lineJoint']);
    lineWire = LineWire.fromJson(json['lineWire']);
    otherUnusualPhenomenon = json['otherUnusualPhenomenon'].string;
    if (json['substations'].list != null) {
      substations = json['substations']?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'lineInsulationContent': lineInsulationContent.toJson(),
      'lineJoint': lineJoint.toJson(),
      'lineWire': lineWire.toJson(),
      'otherUnusualPhenomenon': otherUnusualPhenomenon,
    };
  }
}
