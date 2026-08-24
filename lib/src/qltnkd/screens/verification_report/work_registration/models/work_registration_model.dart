// @dart=2.9
import 'package:g_json/g_json.dart';

class WorkRegistrationModel {
  String id;
  String code;
  String name;
  String patcId;
  String patcCode;
  String constructionId;
  String constructionName;
  String qlvhUnitId;
  String qlvhUnitName;
  String createdBy;
  String createdByName;
  String registerDate;
  String confirmDate;
  String confirmBy;
  int status;
  String statusName;
  bool isAllowApprove;
  bool isAllowReject;
  bool isAllowSend;
  bool isAllowEdit;
  bool isAllowDelete;
  int totalRows;
  String basePdfPath;
  String signedPdfPath;

  WorkRegistrationModel({
    this.id,
    this.code,
    this.name,
    this.patcId,
    this.patcCode,
    this.constructionId,
    this.constructionName,
    this.qlvhUnitId,
    this.qlvhUnitName,
    this.createdBy,
    this.createdByName,
    this.registerDate,
    this.confirmDate,
    this.confirmBy,
    this.status,
    this.statusName,
    this.isAllowApprove,
    this.isAllowReject,
    this.isAllowSend,
    this.isAllowEdit,
    this.isAllowDelete,
    this.totalRows,
    this.basePdfPath,
    this.signedPdfPath,
  });

  factory WorkRegistrationModel.fromJson(JSON json) {
    return WorkRegistrationModel(
      id: json['id'].string,
      code: json['code'].string,
      name: json['name'].string,
      patcId: json['patcId'].string,
      patcCode: json['patcCode'].string,
      constructionId: json['constructionId'].string,
      constructionName: json['constructionName'].string,
      qlvhUnitId: json['qlvhUnitId'].string,
      qlvhUnitName: json['qlvhUnitName'].string,
      createdBy: json['createdBy'].string,
      createdByName: json['createdByName'].string,
      registerDate: json['registerDate'].string,
      confirmDate: json['confirmDate'].string,
      confirmBy: json['confirmBy'].string,
      status: json['status'].integer,
      statusName: json['statusName'].string,
      isAllowApprove: json['canApprove'].boolean ?? json['isAllowApprove'].boolean ?? false,
      isAllowReject: json['canReject'].boolean ?? json['isAllowReject'].boolean ?? json['canApprove'].boolean ?? false,
      isAllowSend: json['canSend'].boolean ?? json['isAllowSend'].boolean ?? false,
      isAllowEdit: json['canEdit'].boolean ?? json['isAllowEdit'].boolean ?? false,
      isAllowDelete: json['canDelete'].boolean ?? json['isAllowDelete'].boolean ?? false,
      totalRows: json['totalRows'].integer ?? 0,
      basePdfPath: json['basePdfPath'].string,
      signedPdfPath: json['signedPdfPath'].string,
    );
  }
}

class WorkRegistrationDetailModel extends WorkRegistrationModel {
  String note;
  String confirmById;
  String patcSignedFilePath;
  String patcFileName;
  List<WorkRegistrationAttachmentModel> attachments;
  List<BbksFileModel> bbksFiles;

  String commanderName;
  String commanderSafetyLevel;
  String phoneNumber;
  String workContent;
  String workLocation;
  String workCondition;
  String startTime;
  String endTime;
  int workUnitCount;
  int workerCount;
  String workLeaderName;
  String workLeaderSafetyLevel;
  String supervisorName;
  String supervisorSafetyLevel;
  String guardName;
  String guardSafetyLevel;
  String receiverNote;

  List<WorkRegistrationWorkerModel> workers;
  List<WorkRegistrationRelatedUnitModel> relatedUnits;
  List<WorkRegistrationRiskModel> risks;

  WorkRegistrationDetailModel({
    String id,
    String code,
    String name,
    String patcId,
    String patcCode,
    String constructionId,
    String constructionName,
    String qlvhUnitId,
    String qlvhUnitName,
    String createdBy,
    String createdByName,
    String registerDate,
    String confirmDate,
    String confirmBy,
    int status,
    String statusName,
    bool isAllowApprove,
    bool isAllowReject,
    bool isAllowSend,
    bool isAllowEdit,
    bool isAllowDelete,
    int totalRows,
    String basePdfPath,
    String signedPdfPath,
    this.note,
    this.confirmById,
    this.patcSignedFilePath,
    this.patcFileName,
    this.attachments,
    this.bbksFiles,
    this.commanderName,
    this.commanderSafetyLevel,
    this.phoneNumber,
    this.workContent,
    this.workLocation,
    this.workCondition,
    this.startTime,
    this.endTime,
    this.workUnitCount,
    this.workerCount,
    this.workLeaderName,
    this.workLeaderSafetyLevel,
    this.supervisorName,
    this.supervisorSafetyLevel,
    this.guardName,
    this.guardSafetyLevel,
    this.receiverNote,
    this.workers,
    this.relatedUnits,
    this.risks,
  }) : super(
          id: id,
          code: code,
          name: name,
          patcId: patcId,
          patcCode: patcCode,
          constructionId: constructionId,
          constructionName: constructionName,
          qlvhUnitId: qlvhUnitId,
          qlvhUnitName: qlvhUnitName,
          createdBy: createdBy,
          createdByName: createdByName,
          registerDate: registerDate,
          confirmDate: confirmDate,
          confirmBy: confirmBy,
          status: status,
          statusName: statusName,
          isAllowApprove: isAllowApprove,
          isAllowReject: isAllowReject,
          isAllowSend: isAllowSend,
          isAllowEdit: isAllowEdit,
          isAllowDelete: isAllowDelete,
          totalRows: totalRows,
          basePdfPath: basePdfPath,
          signedPdfPath: signedPdfPath,
        );

  factory WorkRegistrationDetailModel.fromJson(JSON json) {
    return WorkRegistrationDetailModel(
      id: json['id'].string,
      code: json['code'].string,
      name: json['name'].string,
      patcId: json['patcId'].string,
      patcCode: json['patcCode'].string,
      constructionId: json['constructionId'].string,
      constructionName: json['constructionName'].string,
      qlvhUnitId: json['qlvhUnitId'].string,
      qlvhUnitName: json['qlvhUnitName'].string,
      createdBy: json['createdBy'].string,
      createdByName: json['createdByName'].string,
      registerDate: json['registerDate'].string,
      confirmDate: json['confirmDate'].string,
      confirmBy: json['confirmBy'].string,
      status: json['status'].integer,
      statusName: json['statusName'].string,
      isAllowApprove: json['canApprove'].boolean ?? json['isAllowApprove'].boolean ?? false,
      isAllowReject: json['canReject'].boolean ?? json['isAllowReject'].boolean ?? json['canApprove'].boolean ?? false,
      isAllowSend: json['canSend'].boolean ?? json['isAllowSend'].boolean ?? false,
      isAllowEdit: json['canEdit'].boolean ?? json['isAllowEdit'].boolean ?? false,
      isAllowDelete: json['canDelete'].boolean ?? json['isAllowDelete'].boolean ?? false,
      totalRows: json['totalRows'].integer ?? 0,
      basePdfPath: json['basePdfPath'].string,
      signedPdfPath: json['signedPdfPath'].string,
      note: json['note'].string,
      confirmById: json['confirmById'].string,
      patcSignedFilePath: json['patcSignedFilePath'].string,
      patcFileName: json['patcFileName'].string,
      attachments: json['attachments'].list?.map((e) => WorkRegistrationAttachmentModel.fromJson(e))?.toList(),
      bbksFiles: json['bbksFiles'].list?.map((e) => BbksFileModel.fromJson(e))?.toList(),
      commanderName: json['commanderName'].string,
      commanderSafetyLevel: json['commanderSafetyLevel'].string,
      phoneNumber: json['phoneNumber'].string,
      workContent: json['workContent'].string,
      workLocation: json['workLocation'].string,
      workCondition: json['workCondition'].string,
      startTime: json['startTime'].string,
      endTime: json['endTime'].string,
      workUnitCount: json['workUnitCount'].integer,
      workerCount: json['workerCount'].integer,
      workLeaderName: json['workLeaderName'].string,
      workLeaderSafetyLevel: json['workLeaderSafetyLevel'].string,
      supervisorName: json['supervisorName'].string,
      supervisorSafetyLevel: json['supervisorSafetyLevel'].string,
      guardName: json['guardName'].string,
      guardSafetyLevel: json['guardSafetyLevel'].string,
      receiverNote: json['receiverNote'].string,
      workers: json['workers'].list?.map((e) => WorkRegistrationWorkerModel.fromJson(e))?.toList(),
      relatedUnits: json['relatedUnits'].list?.map((e) => WorkRegistrationRelatedUnitModel.fromJson(e))?.toList(),
      risks: json['risks'].list?.map((e) => WorkRegistrationRiskModel.fromJson(e))?.toList(),
    );
  }
}

class WorkRegistrationAttachmentModel {
  String id;
  String workRegistrationId;
  String filePath;
  String fileName;
  int fileSize;
  String contentType;

  WorkRegistrationAttachmentModel({
    this.id,
    this.workRegistrationId,
    this.filePath,
    this.fileName,
    this.fileSize,
    this.contentType,
  });

  factory WorkRegistrationAttachmentModel.fromJson(JSON json) {
    return WorkRegistrationAttachmentModel(
      id: json['id'].string,
      workRegistrationId: json['workRegistrationId'].string,
      filePath: json['url'].string ?? json['filePath'].string ?? json['path'].string,
      fileName: json['fileName'].string,
      fileSize: json['fileSize'].integer,
      contentType: json['contentType'].string,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workRegistrationId': workRegistrationId,
      'filePath': filePath,
      'fileName': fileName,
      'fileSize': fileSize,
      'contentType': contentType,
    };
  }
}

class WorkRegistrationWorkerModel {
  String id;
  int sortOrder;
  String fullName;
  String safetyLevel;
  String duty;

  WorkRegistrationWorkerModel({this.id, this.sortOrder, this.fullName, this.safetyLevel, this.duty});

  factory WorkRegistrationWorkerModel.fromJson(JSON json) {
    return WorkRegistrationWorkerModel(
      id: json['id'].string,
      sortOrder: json['sortOrder'].integer,
      fullName: json['fullName'].string,
      safetyLevel: json['safetyLevel'].string,
      duty: json['duty'].string,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'sortOrder': sortOrder,
    'fullName': fullName,
    'safetyLevel': safetyLevel,
    'duty': duty,
  };
}

class WorkRegistrationRelatedUnitModel {
  String id;
  int sortOrder;
  String unitName;

  WorkRegistrationRelatedUnitModel({this.id, this.sortOrder, this.unitName});

  factory WorkRegistrationRelatedUnitModel.fromJson(JSON json) {
    return WorkRegistrationRelatedUnitModel(
      id: json['id'].string,
      sortOrder: json['sortOrder'].integer,
      unitName: json['unitName'].string,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'sortOrder': sortOrder,
    'unitName': unitName,
  };
}

class WorkRegistrationRiskModel {
  String id;
  int sortOrder;
  String hazardContent;
  String safetyMeasure;
  String execUnit;

  WorkRegistrationRiskModel({this.id, this.sortOrder, this.hazardContent, this.safetyMeasure, this.execUnit});

  factory WorkRegistrationRiskModel.fromJson(JSON json) {
    return WorkRegistrationRiskModel(
      id: json['id'].string,
      sortOrder: json['sortOrder'].integer,
      hazardContent: json['hazardContent'].string,
      safetyMeasure: json['safetyMeasure'].string,
      execUnit: json['execUnit'].string,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'sortOrder': sortOrder,
    'hazardContent': hazardContent,
    'safetyMeasure': safetyMeasure,
    'execUnit': execUnit,
  };
}

class BbksFileModel {
  String surveyReportId;
  String code;
  String signedFilePath;
  String fileName;

  BbksFileModel({
    this.surveyReportId,
    this.code,
    this.signedFilePath,
    this.fileName,
  });

  factory BbksFileModel.fromJson(JSON json) {
    return BbksFileModel(
      surveyReportId: json['surveyReportId'].string,
      code: json['code'].string,
      signedFilePath: json['signedFilePath'].string,
      fileName: json['fileName'].string,
    );
  }
}
