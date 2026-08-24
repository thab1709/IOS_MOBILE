// @dart=2.9
import 'package:g_json/g_json.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_participant_model.dart';

class PatcModel {
  String id;
  String code;
  String name;
  String constructionId;
  String constructionName;
  final DateTime createdDate;
  final DateTime confirmDate;
  final DateTime signedDate;
  final String createdBy;
  final String createdByName;
  final String confirmByName;
  int status;
  String statusName;
  String filePath;
  String fileName;
  String signedFilePath;
  bool isFileValid;
  bool isAllowEdit;
  bool isAllowDelete;
  bool isAllowSend;
  bool isAllowApprove;
  bool isAllowReject;
  int totalRows;
  String qlvhUnitName;
  String nextSignerId;
  int nextSignType;
  String note;
  String content;
  String nextSignerName;
  List<SurveyReportModel> surveyReports;
  List<PatcParticipantModel> participants;
  bool isMyTurn;
  List<dynamic> attachments; // Added attachments if returned by API

  PatcModel({
    this.id,
    this.code,
    this.name,
    this.constructionId,
    this.constructionName,
    this.createdDate,
    this.confirmDate,
    this.signedDate,
    this.createdBy,
    this.createdByName,
    this.confirmByName,
    this.status,
    this.statusName,
    this.filePath,
    this.fileName,
    this.signedFilePath,
    this.isFileValid,
    this.isAllowEdit,
    this.isAllowDelete,
    this.isAllowSend,
    this.isAllowApprove,
    this.isAllowReject,
    this.totalRows,
    this.qlvhUnitName,
    this.nextSignerId,
    this.nextSignType,
    this.note,
    this.content,
    this.nextSignerName,
    this.surveyReports,
    this.participants,
    this.isMyTurn,
    this.attachments,
  });

  factory PatcModel.fromJson(JSON json) {
    if (json == null) return null;
    final parsedParticipants = (json['participants'].list ?? json['constructionPlanParticipants'].list)
            ?.map((e) => PatcParticipantModel.fromJson(e))
            ?.toList() ?? [];

    String computedNextSigner = json['nextSignerName'].string ?? json['nextSignName'].string;
    if (computedNextSigner == null && parsedParticipants.isNotEmpty && json['status'].integer == 2) {
      final unsigned = parsedParticipants.where((p) => p.isSigned != true).toList();
      if (unsigned.isNotEmpty) {
        unsigned.sort((a, b) => (a.signOrder ?? 9999).compareTo(b.signOrder ?? 9999));
        computedNextSigner = unsigned.first.fullName;
      }
    }

    return PatcModel(
      id: json['id'].string,
      code: json['code'].string,
      name: json['name'].string,
      constructionId: json['constructionId'].string,
      constructionName: json['constructionName'].string,
      createdDate: json['reportDate'].string != null ? DateTime.tryParse(json['reportDate'].string) : null,
      confirmDate: json['confirmDate'].string != null ? DateTime.tryParse(json['confirmDate'].string) : null,
      signedDate: json['signedDate'].string != null ? DateTime.tryParse(json['signedDate'].string) : null,
      createdBy: json['createdBy'].string,
      createdByName: json['createdByName'].string,
      confirmByName: json['confirmByName'].string ?? json['confirmBy'].string,
      status: json['status'].integer,
      statusName: json['statusName'].string,
      filePath: json['filePath'].string,
      fileName: json['fileName'].string,
      signedFilePath: json['signedFilePath'].string,
      isFileValid: json['isFileValid'].boolean ?? false,
      isAllowEdit: json['isAllowEdit'].boolean ?? false,
      isAllowDelete: json['isAllowDelete'].boolean ?? false,
      isAllowSend: json['isAllowSend'].boolean ?? false,
      isAllowApprove: json['isAllowApprove'].boolean ?? false,
      isAllowReject: json['isAllowReject'].boolean ?? false,
      totalRows: json['totalRows'].integer ?? 0,
      qlvhUnitName: json['qlvhUnitName'].string,
      nextSignerId: json['nextSignerId'].string,
      nextSignType: json['nextSignType'].integer,
      note: json['note'].string,
      content: json['content'].string ?? json['note'].string,
      nextSignerName: computedNextSigner,
      surveyReports: json['surveyReports'] != null 
        ? json['surveyReports'].list?.map((e) => SurveyReportModel.fromJson(e))?.toList() 
        : null,
      participants: parsedParticipants,
      isMyTurn: json['isMyTurn'].boolean ?? false,
      attachments: json['attachments'].list?.map((e) => e.value)?.toList() ?? json['files'].list?.map((e) => e.value)?.toList(),
    );
  }
}
