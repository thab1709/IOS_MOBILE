// @dart=2.9
import 'package:g_json/g_json.dart';


class SurveyHistoryModel {
  String id;
  String surveyReportId;
  int action;
  String actionName;
  String actionBy;
  String actionById;
  DateTime actionDate;
  String note;
  String nextSigners;

  SurveyHistoryModel({
    this.id,
    this.surveyReportId,
    this.action,
    this.actionName,
    this.actionBy,
    this.actionById,
    this.actionDate,
    this.note,
    this.nextSigners,
  });

  factory SurveyHistoryModel.fromJson(JSON json) {
    if (json == null) return null;
    return SurveyHistoryModel(
      id: json['id'].string,
      surveyReportId: json['surveyReportId'].string,
      action: json['action'].integer,
      actionName: json['actionName'].string,
      actionBy: json['actionBy'].string,
      actionById: json['actionById'].string,
      actionDate: DateTime.tryParse(json['actionDate'].stringValue ?? ''),
      note: json['note'].string,
      nextSigners: json['nextSigners'].string,
    );
  }
}
