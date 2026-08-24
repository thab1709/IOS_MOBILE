// @dart=2.9
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:g_json/g_json.dart';

import '../problem_positions_model.dart';

class Group {
  List<ListProblemPosition> listProblemPosition;

  Group({
      this.listProblemPosition});

  Group.fromJson(JSON json) {
    if (json['listProblemPosition'] != null) {
      listProblemPosition = [];
      json['listProblemPosition'].list.forEach((v) {
        listProblemPosition.add(ListProblemPosition.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (listProblemPosition != null) {
      map['listProblemPosition'] = listProblemPosition.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ListProblemPosition {
  int fieldValue;
  List<Problems> problems;

  ListProblemPosition({
      this.fieldValue, 
      this.problems});

  ListProblemPosition.fromJson(JSON json) {
    fieldValue = json['fieldValue'].integer;
    if (json['problems'] != null) {
      problems = [];
      json['problems'].list.forEach((v) {
        problems.add(Problems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fieldValue'] = fieldValue;
    if (problems != null) {
      map['Problems'] = problems.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Problems {
  int problemValue;
  List<List<ProblemPositions>> group;

  Problems({
      this.problemValue, 
      this.group});

  Problems.fromJson(JSON json) {
    problemValue = json['problemValue'].integer;
    if (json['group'] != null) {
      group = [];
      json['group'].list.forEach((v) {
        group.add(v.list.map((element) {
          ProblemPositions.fromJson(element);
        }).toList());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['problemValue'] = problemValue;
    if (group != null) {
      map['group'] = group.map((v) => v.map((e) => ProblemPositions.fromJson(JSON(e))).toList()).toList();
    }
    return map;
  }

  List<List<EquipmentModel>> getListArea(){
    return group.map((e) => e.map((v) => EquipmentModel(id: v.positionId, name: v.title, groupId: v.groupId)).toList()).toList();
  }

}

// class E {
//   String positionId;
//   String createdDate;
//
//   GroupEquipment({
//       this.positionId,
//       this.createdDate});
//
//   GroupEquipment.fromJson(JSON json) {
//     positionId = json['positionId'].string;
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['positionId'] = positionId;
//     return map;
//   }
//
// }
