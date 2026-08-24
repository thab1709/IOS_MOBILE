// @dart=2.9
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:g_json/g_json.dart';
import 'package:get/get.dart';

import '../attach_image_model.dart';
import '../problem_positions_model.dart';

class LineRightsOfWay extends PopupBaseModel {
  int anotherLineCrossing;
  int treeFall;
  int violation;
  String subjectOfViolation;
  int treeFellingCondition;
  int informationOnTreeFellingAndPlanting;
  String informationConstructionPlan;
  int rockSlide;
  int changesConstruction;
  String theWorksAreUnderConstruction;
  int handlingImmediatelyInspection;
  int possibleProblematic;

  LineRightsOfWay({
      this.anotherLineCrossing, 
      this.treeFall, 
      this.violation, 
      this.subjectOfViolation, 
      this.treeFellingCondition, 
      this.informationOnTreeFellingAndPlanting, 
      this.rockSlide, 
      this.theWorksAreUnderConstruction, 
      this.handlingImmediatelyInspection,});

  LineRightsOfWay.fromJson(JSON json) {
    anotherLineCrossing = json['anotherLineCrossing'].integer;
    treeFall = json['treeFall'].integer;
    violation = json['violation'].integer;
    changesConstruction = json['changesConstruction'].integer;
    possibleProblematic = json['possibleProblematic'].integer;
    subjectOfViolation = json['subjectOfViolation'].string;
    treeFellingCondition = json['treeFellingCondition'].integer;
    informationOnTreeFellingAndPlanting = json['informationOnTreeFellingAndPlanting'].integer;
    rockSlide = json['rockSlide'].integer;
    informationConstructionPlan = json['informationConstructionPlan'].string;
    theWorksAreUnderConstruction = json['theWorksAreUnderConstruction'].string;
    handlingImmediatelyInspection = json['handlingImmediatelyInspection'].integer;
    suggestedHandlingOfAbnormal = json['suggestedHandlingOfAbnormal'].string;
    description = json['description'].string;
    if (json['images'].list != null) {
      images = [];
      json['images']?.list?.forEach((v) {
        images.add(Images.fromJson(v));
      });
    }

    if (json['problemPositions'].list != null) {
      problemPositions = [];
      json['problemPositions']?.list?.forEach((v) {
        problemPositions.add(ProblemPositions.fromJson(v));
      });
    }
    abnormals =
        json['abnormals']?.listObject?.map((e) => TAbnormal.fromJson(JSON(e)))?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['anotherLineCrossing'] = anotherLineCrossing;
    map['treeFall'] = treeFall;
    map['violation'] = violation;
    map['changesConstruction'] = changesConstruction;
    map['possibleProblematic'] = possibleProblematic;
    map['subjectOfViolation'] = subjectOfViolation;
    map['treeFellingCondition'] = treeFellingCondition;
    map['informationOnTreeFellingAndPlanting'] = informationOnTreeFellingAndPlanting;
    map['informationConstructionPlan'] = informationConstructionPlan;
    map['rockSlide'] = rockSlide;
    map['theWorksAreUnderConstruction'] = theWorksAreUnderConstruction;
    map['handlingImmediatelyInspection'] = handlingImmediatelyInspection;
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
    final _ticketController = Get.put(LineTicketController());
    if (_ticketController.argument.ticketType == TicketType.periodicDay || _ticketController.argument.ticketType == TicketType.techDay) {
      return ![
        anotherLineCrossing,
        //treeFall,
        violation,
        changesConstruction,
        possibleProblematic,
        subjectOfViolation,
        treeFellingCondition,
        informationOnTreeFellingAndPlanting,
        informationConstructionPlan,
        //rockSlide,
        theWorksAreUnderConstruction,
        handlingImmediatelyInspection,
        suggestedHandlingOfAbnormal,
      ].contains(null);
    } else {
      return ![
        anotherLineCrossing,
        //treeFall,
        violation,
        //changesConstruction,
        //possibleProblematic,
        subjectOfViolation,
        treeFellingCondition,
        informationOnTreeFellingAndPlanting,
        //informationConstructionPlan,
        //rockSlide,
        theWorksAreUnderConstruction,
        handlingImmediatelyInspection,
        suggestedHandlingOfAbnormal,
      ].contains(null);
    }


  }

}
