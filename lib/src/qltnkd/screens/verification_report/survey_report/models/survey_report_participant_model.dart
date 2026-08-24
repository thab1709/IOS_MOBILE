// @dart=2.9
import 'package:g_json/g_json.dart';

class SurveyReportParticipantModel {
  String id;
  String surveyReportId;
  int groupType;
  int sortOrder;
  String unitId;
  String unitName;
  String userId;
  String fullName;
  String position;
  bool isSigned;
  DateTime signedDate;
  bool isExternal;
  String signatureImagePath;
  String signatureCapturedByName;

  SurveyReportParticipantModel({
    this.id,
    this.surveyReportId,
    this.groupType,
    this.sortOrder,
    this.unitId,
    this.unitName,
    this.userId,
    this.fullName,
    this.position,
    this.isSigned,
    this.signedDate,
    this.isExternal,
    this.signatureImagePath,
    this.signatureCapturedByName,
  });

  factory SurveyReportParticipantModel.fromJson(JSON json) {
    if (json == null) return null;
    return SurveyReportParticipantModel(
      id: json['id'].string,
      surveyReportId: json['surveyReportId'].string,
      groupType: json['groupType'].integer ?? json['type'].integer,
      sortOrder: json['sortOrder'].integer,
      unitId: json['unitId'].string,
      unitName: json['unitName'].string,
      userId: json['userId'].string,
      fullName: json['fullName'].string ?? json['userName'].string,
      position: json['position'].string ?? json['userPositionName'].string,
      isSigned: json['isSigned'].boolean,
      signedDate: DateTime.tryParse(json['signedDate'].stringValue ?? ''),
      isExternal: json['isExternal'].boolean ?? false,
      signatureImagePath: json['signatureImagePath'].string,
      signatureCapturedByName: json['signatureCapturedByName'].string,
    );
  }
}
