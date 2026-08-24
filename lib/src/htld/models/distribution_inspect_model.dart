// @dart=2.9
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';

class DistributionInspectModel {
  DistributionInspectModel(
      {this.createDate,
        this.createBy,
        this.subStationId,
        this.inspectionType,
        this.predicType,
        this.lines,
        this.inspectTime,
        this.lastInspectTime,
        this.inspectRequest,
        this.subStationStatus,
        this.workId});
  String workId;
  String createDate;
  String createBy;
  String subStationId;
  int inspectionType;
  int predicType;
  String lines;
  String inspectTime;
  String lastInspectTime;
  String inspectRequest;
  String subStationStatus;
  TicketType type;
  List<EquipmentModel> equipments;
  String temperature_1;
  String weather_1;
  String temperature_2;
  String weather_2;
  String frequency;
  factory DistributionInspectModel.fromJSON() {

    return DistributionInspectModel();
  }

  Map<String, dynamic> toJSON() {
    final json = <String, dynamic>{};
    json['workId'] = workId;
    json['weather'] = weather_1;
    json['temperature'] = temperature_1;
    json['weather2'] = weather_2;
    json['temperature2'] = temperature_2;
    json['substationId'] = subStationId;
    json['type'] = type.code;
    json['inspectTime'] = inspectTime;
    json['inspectionRequest'] = inspectRequest;
    json['lastInspection'] = lastInspectTime;
    json['equipments'] = equipments?.map((e) {
      return {
        'equipmentId' : e.id,
      };
    })?.toList();
    return json;
  }
}
