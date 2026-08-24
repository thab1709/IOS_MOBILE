// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';
import '../../popup_base_model.dart';
import '../../problem_positions_model.dart';

class LineBreaker extends PopupBaseModel {
  int driveStructureClose;
  int contactAtBladeAndMount;
  int blade;
  int contactPressureSpring;
  int bolts;
  int sound;
  int insulation;
  int isolationKnifeGrounding;
  int handleActionLock;
  int possibleProblematic;
  int handlingInCheck;

  LineBreaker({
    this.driveStructureClose,
    this.contactAtBladeAndMount,
    this.blade,
    this.contactPressureSpring,
    this.bolts,
    this.sound,
    this.insulation,
    this.isolationKnifeGrounding,
    this.handleActionLock,
    this.possibleProblematic,
    this.handlingInCheck,
  });

  LineBreaker.fromJson(JSON json) {
    driveStructureClose = json['driveStructureClose'].integer;
    contactAtBladeAndMount = json['contactAtBladeAndMount'].integer;
    blade = json['blade'].integer;
    contactPressureSpring = json['contactPressureSpring'].integer;
    bolts = json['bolts'].integer;
    sound = json['sound'].integer;
    isUpdateOffline = json['isUpdateOffline']?.boolean ?? false;
    insulation = json['insulation'].integer;
    isolationKnifeGrounding = json['isolationKnifeGrounding'].integer;
    handleActionLock = json['handleActionLock'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingInCheck = json['handlingInCheck'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    if (json['images'] != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJson(JSON(e)))?.toList();
    }
    if (json['problemPositions'] != null) {
      problemPositions = json['problemPositions']?.list?.map((e) => ProblemPositions.fromJson(e))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['driveStructureClose'] = driveStructureClose;
    map['contactAtBladeAndMount'] = contactAtBladeAndMount;
    map['blade'] = blade;
    map['contactPressureSpring'] = contactPressureSpring;
    map['bolts'] = bolts;
    map['sound'] = sound;
    map['insulation'] = insulation;
    map['isolationKnifeGrounding'] = isolationKnifeGrounding;
    map['handleActionLock'] = handleActionLock;
    map['specificPhenomena'] = specificPhenomena;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingInCheck'] = handlingInCheck;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['description'] = description;
    map['isUpdateOffline'] = isUpdateOffline ?? false;
    if (images != null) {
      map['images'] = images.map((v) => v.toJson()).toList();
    }
    if (problemPositions != null) {
      map['problemPositions'] = problemPositions.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      map['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  bool validateData() {
    final listDistinct = List<ProblemPositions>.empty(growable: true);
    problemPositions?.forEach((element) {
      final tamp = listDistinct?.firstWhere((e) => e?.fieldValue == element.fieldValue, orElse: () => null);
      if (tamp == null) {
        listDistinct.add(element);
      }
    });

    return ![specificPhenomena, suggestedHandlingOfAbnormal].contains(null) && listDistinct.length == 11;
  }

}
