// @dart=2.9
import 'package:g_json/g_json.dart';


import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_participant_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';

class SurveyReportModel {
  String id;
  String code;
  String name;
  String constructionId;
  String constructionName;
  DateTime reportDate;
  DateTime confirmDate;
  String confirmByName;
  int status;
  String statusName;
  String patcId;
  String patcCode;
  String qlvhUnitId;
  String qlvhUnitName;
  DateTime createdDate;
  String createdByName;
  String filePath;
  String basePdfPath;
  String signedFilePath;
  String fileName;
  String createdBy;
  bool isFileValid;
  String nextSignerId;
  String nextSignerName;
  bool isAllowEdit;
  bool isAllowDelete;
  bool isAllowSend;
  bool isAllowApprove;
  bool isAllowReject;
  int totalRows;
  String note;
  bool isMyTurn;
  List<SurveyReportParticipantModel> participants;
  List<dynamic> attachments;

  SurveyReportModel({
    this.id,
    this.code,
    this.name,
    this.constructionId,
    this.constructionName,
    this.reportDate,
    this.confirmDate,
    this.confirmByName,
    this.status,
    this.statusName,
    this.patcId,
    this.patcCode,
    this.qlvhUnitId,
    this.qlvhUnitName,
    this.createdDate,
    this.createdByName,
    this.filePath,
    this.basePdfPath,
    this.signedFilePath,
    this.fileName,
    this.createdBy,
    this.isFileValid,
    this.nextSignerId,
    this.nextSignerName,
    this.isAllowEdit,
    this.isAllowDelete,
    this.isAllowSend,
    this.isAllowApprove,
    this.isAllowReject,
    this.totalRows,
    this.note,
    this.isMyTurn,
    this.participants,
    this.attachments,
  });

  factory SurveyReportModel.fromJson(JSON json) {
    if (json == null) return null;
    
    final parsedParticipants = (json['participants'].list ?? json['surveyReportParticipants'].list ?? json['listParticipants'].list)
            ?.map((e) => SurveyReportParticipantModel.fromJson(e))
            ?.toList() ?? [];

    String computedNextSigner = json['nextSignerName'].string ?? json['nextSignName'].string;
    if (computedNextSigner == null && parsedParticipants.isNotEmpty && json['status'].integer == SurveyReportStatusCode.waitConfirm) {
      final unsigned = parsedParticipants.where((p) => p.isSigned != true).toList();
      if (unsigned.isNotEmpty) {
        unsigned.sort((a, b) => (a.sortOrder ?? 9999).compareTo(b.sortOrder ?? 9999));
        computedNextSigner = unsigned.first.fullName;
      }
    }

    return SurveyReportModel(
      id: json['surveyReportId'].string ?? json['id'].string,
      code: json['surveyReportCode'].string ?? json['code'].string,
      name: json['name'].string ?? json['surveyReportName'].string,
      constructionId: json['constructionId'].string,
      constructionName: json['constructionName'].string ?? json['surveyReportName'].string, // Sometimes they use surveyReportName as constructionName in the view
      reportDate: DateTime.tryParse(json['reportDate'].stringValue ?? ''),
      confirmDate: DateTime.tryParse(json['confirmDate'].stringValue ?? ''),
      confirmByName: json['confirmByName'].string ?? json['confirmBy'].string,
      status: json['status'].integer,
      statusName: json['statusName'].string,
      patcId: json['patcId'].string,
      patcCode: json['patcCode'].string,
      qlvhUnitId: json['qlvhUnitId'].string,
      qlvhUnitName: json['qlvhUnitName'].string,
      createdDate: DateTime.tryParse(json['createdDate'].stringValue ?? ''),
      createdByName: json['createdByName'].string,
      filePath: json['filePath'].string,
      basePdfPath: json['basePdfPath'].string,
      signedFilePath: json['signedFilePath'].string,
      fileName: json['fileName'].string,
      createdBy: json['createdBy'].string,
      isFileValid: json['isFileValid'].boolean ?? false,
      nextSignerId: json['nextSignerId'].string,
      nextSignerName: computedNextSigner,
      isAllowEdit: json['isAllowEdit'].boolean ?? false,
      isAllowDelete: json['isAllowDelete'].boolean ?? false,
      isAllowSend: json['isAllowSend'].boolean ?? false,
      isAllowApprove: json['isAllowApprove'].boolean ?? false,
      isAllowReject: json['isAllowReject'].boolean ?? false,
      totalRows: json['totalRows'].integer ?? 0,
      note: json['note'].string,
      isMyTurn: json['isMyTurn'].boolean ?? false,
      participants: parsedParticipants,
      attachments: json['attachments'].list?.map((e) => e.value)?.toList() ?? json['files'].list?.map((e) => e.value)?.toList(),
    );
  }
}
