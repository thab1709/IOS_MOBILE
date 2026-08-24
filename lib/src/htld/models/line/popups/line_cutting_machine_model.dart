// @dart=2.9
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:g_json/g_json.dart';
import 'package:get/get.dart';

import '../../attach_image_model.dart';
import '../../problem_positions_model.dart';

class LineCuttingMachineModel extends PopupBaseModel {

  LineCuttingMachineModel();

  LineCuttingMachineModel.fromJson(JSON json) {
    specificPhenomena = json['specificPhenomena'].string;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    isUpdateOffline = json['isUpdateOffline']?.boolean ?? false;
    if (json['images'] != null) {
      images = json['images']?.list?.map((e) => Images.fromJson(e))?.toList();
    }
    if (json['problemPositions'] != null) {
      problemPositions = json['problemPositions']?.list?.map((e) => ProblemPositions.fromJson(e))?.toList();
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['specificPhenomena'] = specificPhenomena;
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
    final _ticketController = Get.put(LineTicketController());
    final listDistinct = List<ProblemPositions>.empty(growable: true);
    problemPositions?.forEach((element) {
      final tamp = listDistinct?.firstWhere((e) => e?.fieldValue == element.fieldValue, orElse: () => null);
      if (tamp == null) {
        listDistinct.add(element);
      }
    });

    if (_ticketController.argument.ticketType != TicketType.incidentDay) {
      return ![specificPhenomena, suggestedHandlingOfAbnormal].contains(null) && listDistinct.length == 7;
    } else {
      return ![specificPhenomena, suggestedHandlingOfAbnormal].contains(null) && listDistinct.length == 3;
    }
  }
}
