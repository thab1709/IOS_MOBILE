// @dart=2.9
import 'package:evnmobile/src/htld/models/problem_positions_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';
import '../../popup_base_model.dart';

class LineUndergroundCable extends PopupBaseModel {
  int violation;
  int worksUnderConstruction;
  int possibleProblematic;
  int handlingImmediatelyInspection;
  int cableMold;
  String worksUnderConstructionDescription;
  String seaCableSpecificPhenomena;
  String outSideCableSpecificPhenomena;
  String otherUnusualPhenomenon;
  LineUndergroundCable({
    this.violation,
    this.worksUnderConstruction,
    this.possibleProblematic,
    this.handlingImmediatelyInspection,
    this.seaCableSpecificPhenomena,
    this.outSideCableSpecificPhenomena,
    this.otherUnusualPhenomenon,
  });

  LineUndergroundCable.fromJson(JSON json) {
    violation = json['violation'].integer;
    worksUnderConstructionDescription =
        json['worksUnderConstructionDescription'].string;
    worksUnderConstruction = json['worksUnderConstruction'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    handlingImmediatelyInspection =
        json['handlingImmediatelyInspection'].integer;
    suggestedHandlingOfAbnormal =
        json['suggestedHandlingOfAbnormal'].string ?? 'Không';
    cableMold = json['cableMold'].integer;
    specificPhenomena = json['specificPhenomena'].string ?? 'Không';
    seaCableSpecificPhenomena =
        json['seaCableSpecificPhenomena'].string ?? 'Không';
    outSideCableSpecificPhenomena =
        json['outSideCableSpecificPhenomena'].string ?? 'Không';
    isUpdateOffline = json['isUpdateOffline']?.boolean ?? false;
    otherUnusualPhenomenon = json['otherUnusualPhenomenon'].string ?? 'Không';
    if (json['images'] != null) {
      images = json['images']?.list?.map((e) => Images.fromJson(e))?.toList();
    }
    if (json['problemPositions'] != null) {
      problemPositions = json['problemPositions']
          ?.list
          ?.map((e) => ProblemPositions.fromJson(e))
          ?.toList();
    }
    description = json['description'].string;
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['violation'] = violation;
    map['cableMold'] = cableMold;
    map['worksUnderConstructionDescription'] =
        worksUnderConstructionDescription;
    map['worksUnderConstruction'] = worksUnderConstruction;
    map['possibleProblematic'] = possibleProblematic;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['specificPhenomena'] = specificPhenomena;
    map['seaCableSpecificPhenomena'] = seaCableSpecificPhenomena;
    map['outSideCableSpecificPhenomena'] = outSideCableSpecificPhenomena;
    map['otherUnusualPhenomenon'] = otherUnusualPhenomenon;
    map['isUpdateOffline'] = isUpdateOffline ?? false;
    if (images != null) {
      map['images'] = images.map((v) => v.toJson()).toList();
    }
    if (problemPositions != null) {
      map['problemPositions'] =
          problemPositions.map((v) => v.toJson()).toList();
    }
    map['description'] = description;
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

    if (worksUnderConstruction == CKOptions.first.value) {
      return ![
        violation,
        cableMold,
        worksUnderConstructionDescription,
        possibleProblematic,
        handlingImmediatelyInspection,
        suggestedHandlingOfAbnormal,
        specificPhenomena,
        seaCableSpecificPhenomena,
        outSideCableSpecificPhenomena,
        otherUnusualPhenomenon
      ].contains(null) && listDistinct.length == 8;
    }
    return ![
      violation,
      cableMold,
      possibleProblematic,
      handlingImmediatelyInspection,
      suggestedHandlingOfAbnormal,
      specificPhenomena,
      seaCableSpecificPhenomena,
      outSideCableSpecificPhenomena,
      otherUnusualPhenomenon
    ].contains(null) && listDistinct.length == 7;
  }
}

