// @dart=2.9
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:g_json/g_json.dart';

import '../../attach_image_model.dart';
import '../../problem_positions_model.dart';

class LineTiModel extends PopupBaseModel {
  int insulation;
  int contactAtTerminals;
  int sound;
  int handlingInCheck;
  int possibleProblematic;

  LineTiModel({
    this.insulation,
    this.contactAtTerminals,
    this.sound,
    this.handlingInCheck,
  });

  @override
  LineTiModel.fromJson(JSON json) {
    possibleProblematic = json['possibleProblematic'].integer;
    insulation = json['insulation'].integer;
    contactAtTerminals = json['contactAtTerminals'].integer;
    sound = json['sound'].integer;
    handlingInCheck = json['handlingInCheck'].integer;
    specificPhenomena = json['specificPhenomena'].string;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    isUpdateOffline = json['isUpdateOffline']?.boolean ?? false;
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
    map['insulation'] = insulation;
    map['possibleProblematic'] = possibleProblematic;
    map['contactAtTerminals'] = contactAtTerminals;
    map['sound'] = sound;
    map['isUpdateOffline'] = isUpdateOffline ?? false;
    map['handlingInCheck'] = handlingInCheck;
    map['specificPhenomena'] = specificPhenomena;
    map['suggestedHandlingOfAbnormal'] = suggestedHandlingOfAbnormal;
    map['description'] = description;
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
      final tamp = listDistinct?.firstWhere((e) =>
      e?.fieldValue == element.fieldValue, orElse: () => null);
      if (tamp == null) {
        listDistinct.add(element);
      }
    });
    return ![specificPhenomena, suggestedHandlingOfAbnormal].contains(null) &&
        listDistinct.length == 5;
  }
}

